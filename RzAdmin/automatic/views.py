import logging
import json
import xlwt
import time
import os
from datetime import date
from RzAdmin import settings
from django.utils.timezone import datetime
from automatic import models
from automatic.forms import create_table_form
from django.shortcuts import render, HttpResponse, redirect
from django.contrib.auth.decorators import login_required
from automatic.utils import (
    get_condition_dict, get_contact_list, get_paginator_query_sets, query_sets_sort, get_info_list, create_id
)

# Create your views here.
logger = logging.getLogger("__name__")  # 生成一个以当前模块名为名字的logger实例
c_logger = logging.getLogger("collect")  # 生成一个名为'collect'的logger实例，用于收集一些需要特殊记录的日志


@login_required
def index(request):
    data_dict = {}  # 用来存放首页数据
    data_dict["registered_num"] = get_info_list("rz", models.SQLRecord.objects.get(id=20).content)[0]["注册人数"]
    data_dict["real_names_num"] = get_info_list("rz", models.SQLRecord.objects.get(id=21).content)[0]["实名人数"]
    un_R_xt_amount = get_info_list("rz", models.SQLRecord.objects.get(id=22).content)[0]
    data_dict["un_R_xt_person_num"] = un_R_xt_amount["投资人数"]
    data_dict["un_R_xt_amount"] = "%s万" % (float(un_R_xt_amount["投资金额"]) / 10000)
    data_dict["amount"] = float(get_info_list("rz", models.SQLRecord.objects.get(id=23).content)[0]["投资金额"]) / 10000
    return render(request, "index.html", {"data_dict": data_dict})


@login_required
def search_table_list(request):
    """可用查询页面"""
    user = request.user  # 获取用户对象
    sql_record_objs = models.SQLRecord.objects.filter(roles__in=user.roles.all(), query_page=True).all()
    sql_record_objs = get_paginator_query_sets(request, sql_record_objs, request.GET.get("list_per_page", 10))
    return render(request, "search_table_list.html", {"sql_record_objs": sql_record_objs})


@login_required
def table_search_detail(request, sql_record_id):
    """详细查询页面"""
    query_sets = []  # 要返回的查询结果
    order_by_dict = {}  # 排序相关字典
    sql_record_obj = models.SQLRecord.objects.get(id=sql_record_id)  # sql记录
    table_form_class = create_table_form(sql_record_obj)  # 动态生成table_form类
    table_form_obj = table_form_class()  # 生成table_form对象
    condition_dict = get_condition_dict(request)  # 获取查询条件
    if condition_dict:  # 有查询条件时，才会进行from验证，否则为第一访问该地址不需要验证
        table_form_obj = table_form_class(data=condition_dict)
        if table_form_obj.is_valid():  # form验证
            # 添加查询日志
            logger.info("用户%s查询了%s,使用条件%s!" % (request.user.name, sql_record_obj.name, condition_dict))
            query_sets = get_contact_list(sql_record_obj, table_form_obj.cleaned_data)
            query_sets, order_by_dict = query_sets_sort(request, query_sets)  # 进行排序
    query_sets = get_paginator_query_sets(request, query_sets, request.GET.get("list_per_page", 10))
    return render(request, "table_search_detail.html", {
        "sql_record_obj": sql_record_obj,
        "table_form_obj": table_form_obj,
        "query_sets": query_sets,
        "condition_dict": condition_dict,
        "order_by_dict": order_by_dict
    })


@login_required
def search_channel_name(request):
    """查询渠道名称"""
    ret = {"status": True, "errors": None, "data": None}  # 定义返回内容
    if request.method == "POST":
        channel_name = request.POST.get("qudaoName")  # 获取用户输入的渠道名称
        # 通过用户输入的渠道名称查询对应的渠道标识
        info_list = get_info_list(
            'rz',
            "SELECT DISTINCT name from rzjf_bi.rzjf_qudao_name where name REGEXP '%s' limit 10" % channel_name
        )
        ret["data"] = info_list  # 返回给前端
        return HttpResponse(json.dumps(ret))


@login_required
def download_excel(request, sql_record_id):
    """导出明细至EXCEL"""
    detaile_jurisdiction = ["数据组", "管理员", "财务部"]  # 有详细信息查看权限的角色 todo 希望做成数据库里面可以自定义的
    # todo 希望做成数据库里面可以自定义的
    user_roles_list = [i.name for i in request.user.roles.all() if i.name in detaile_jurisdiction]
    sql_record_obj = models.SQLRecord.objects.get(id=sql_record_id)  # sql记录
    table_form_class = create_table_form(sql_record_obj)  # 动态生成table_form类
    condition_dict = get_condition_dict(request)  # 获取查询条件
    table_form_obj = table_form_class(data=condition_dict)
    download_record_obj = models.DownloadRecord.objects.filter(
        user=request.user, download_url=request.get_full_path()
    ).first()
    if len(user_roles_list) == 0:  # 没有直接下载权限则需要进行下载认证
        if download_record_obj:
            if download_record_obj.check_status != 1:
                return HttpResponse("该下载记录未审核通过,您无权下载!")
        else:
            return HttpResponse("您未申请该下载记录!")
    if table_form_obj.is_valid():  # form验证
        query_sets = get_contact_list(sql_record_obj, table_form_obj.cleaned_data)
        query_sets, order_by_dict = query_sets_sort(request, query_sets)  # 进行排序
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename=' + time.strftime('%Y%m%d-%H.%M.%S', time.localtime(
            time.time())) + '.xls'
        workbook = xlwt.Workbook(encoding='utf-8')  # 创建工作簿
        sheet = workbook.add_sheet("sheet1")  # 创建工作页
        style_heading = xlwt.easyxf("""
                font:
                    name Arial,
                    colour_index white,
                    bold on,
                    height 0xA0;
                align:
                    wrap off,
                    vert center,
                    horiz center;
                pattern:
                    pattern solid,
                    fore-colour 0x19;
                borders:
                    left THIN,
                    right THIN,
                    top THIN,
                    bottom THIN;
                """
                                    )
        style_body = xlwt.easyxf("""
                font:
                    name Arial,
                    bold off,
                    height 0XA0;
                align:
                    vert center,
                    horiz center;
                borders:
                    left THIN,
                    right THIN,
                    top THIN,
                    bottom THIN;
                """
                                 )
        if query_sets:
            for index, field in enumerate(query_sets[0].keys()):
                sheet.write(0, index, field, style_heading)
            for index, item in enumerate(query_sets):
                for value_index, value in enumerate(item.values()):
                    if isinstance(value, datetime):
                        value = value.strftime("%Y-%m-%d %H:%M:%S")
                    if isinstance(value, date):
                        value = value.strftime("%Y-%m-%d")
                    sheet.write(index + 1, value_index, value, style_body)
        workbook.save(response)
        return response
    else:
        return HttpResponse("没有数据!")


@login_required
def user_center(request):
    """用户中心"""
    download_objs = request.user.user_download.all().order_by('-date')
    download_objs = get_paginator_query_sets(request, download_objs, request.GET.get("list_per_page", 10))
    if request.method == "GET":
        pass
    return render(request, "user_center.html", {"download_objs": download_objs})


@login_required
def download_check(request, sql_record_id):
    """下载审核页面"""
    sql_record_obj = models.SQLRecord.objects.get(id=sql_record_id)  # sql记录
    table_form_class = create_table_form(sql_record_obj)  # 动态生成table_form类
    condition_dict = get_condition_dict(request)  # 获取查询条件
    table_form_obj = table_form_class(data=condition_dict)
    if request.method == "GET":
        if table_form_obj.is_valid():  # 进行form验证
            pass
        else:
            return redirect("/automatic/table_search_detail/%s/" % sql_record_id)
    elif request.method == "POST":
        condition_str = ""  # 下载条件
        keywords = ["check_img", "sql_record_id"]
        for k, v in request.POST.items():
            if k in keywords:
                continue
            condition_str += "&%s=%s" % (k, v)
        models.DownloadRecord.objects.create(
            user=request.user,
            check_img=request.POST.get("check_img", "/static/img/check_default.jpg"),
            download_detail="%s %s<br>%s %s" % (
                request.POST.get("qudao_name", ""), sql_record_obj.name,
                request.POST.get("start_time", ""), request.POST.get("end_time", "")
            ),
            detail_url="/automatic/table_search_detail/%s/?%s" % (request.POST.get("sql_record_id", ""), condition_str),
            download_url="/automatic/download_excel/%s/?%s" % (request.POST.get("sql_record_id", ""), condition_str),
        )
        return redirect("/automatic/user_center.html")
    return render(request, "download_check.html", {
        "sql_record_obj": sql_record_obj,
        "table_form_obj": table_form_obj
    })


@login_required
def delete_download_record(request, download_record_id):
    """删除下载记录"""
    ret = {"status": False, "error": None, "data": None}
    download_record_obj = models.DownloadRecord.objects.filter(id=download_record_id).first()
    if download_record_obj:
        if download_record_obj.check_status == 1:
            ret["error"] = "审核通过的下载记录将作为历史记录，您无法删除！"
        else:
            download_record_obj.delete()
            ret["status"] = True
    else:
        ret["error"] = "下载记录不存在！"
    return HttpResponse(json.dumps(ret))


@login_required
def upload_file(request):
    """上传文件至服务器"""
    ret = {"status": False, "error": None, "data": None}
    file_obj = request.FILES.get("upload_file")
    if file_obj:
        upload_file_path = os.path.join(settings.BASE_DIR, "static", "img", "upload")
        file_name = "%s&%s" % (create_id(), file_obj._name)
        with open(os.path.join(upload_file_path, file_name), "wb") as f:
            for line in file_obj:
                f.write(line)
        ret["status"] = True
        ret["data"] = "/static/img/upload/%s" % file_name
    return HttpResponse(json.dumps(ret))
