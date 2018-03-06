import logging
import json
import xlwt
import time
import os
import math
import threading
from datetime import date
from RzAdmin import settings
from django.utils.timezone import datetime, now
from automatic import models
from automatic.forms import create_table_form, AddUserProfileForm
from django.shortcuts import render, HttpResponse, redirect
from django.contrib.auth.decorators import login_required
from automatic.utils import (
    get_condition_dict, get_contact_list, get_paginator_query_sets, query_sets_sort, get_info_list, create_id
)
from automatic.permissions.permission import check_permission_decorate
from django.db import connections

# Create your views here.
logger = logging.getLogger("__name__")  # 生成一个以当前模块名为名字的logger实例
c_logger = logging.getLogger("collect")  # 生成一个名为'collect'的logger实例，用于收集一些需要特殊记录的日志
data_dict = {
    "message": None,  # 提示信息
    "update_time": "",  # 更新时间
    "registered_num": 0,  # 对应首页用户数据统计的注册用户数
    "real_names_num": 0,  # 对应首页用户数据统计的实名用户数
    "supply_chain_amount": 0,  # 对应首页投资金额统计的供应链投资金额
    "consumer_amount": 0,  # 对应首页投资金额统计的消费金融投资金额
    "un_R_xt_person_num": 0,  # 对应首页图表的投资用户数
    "un_R_xt_amount": "0万",  # 对应首页非自动续投投资金额
    "recharge_num": 0,  # 对应首页用户数据统计的充值用户数
    "recover_account": 0,  # 对应首页总待收金额
    "amount": 0,  # 对应首页总投资金额
    "recharge_money": 0,  # 对应首页的总充值金额
    "withdraw_money": 0,  # 对应首页的总提现金额
    "income": 0,  # 对应首页的总收益
    "balance": 0,  # 对应首页的站岗资金
}  # 首页数据字典模板

lock = threading.Lock()


def get_home_page_data():
    """
    获取首页数据
    :return:
    """
    print("更新首页数据的线程运行了！")
    lock.acquire()  # 加锁
    # 当天注册人数
    data_dict["registered_num"] = get_info_list(
        "rz", models.SQLRecord.objects.get(id=20).content)[0].get("registered_num") or 0
    # 当天实名绑卡人数
    data_dict["real_names_num"] = get_info_list(
        "rz", models.SQLRecord.objects.get(id=21).content)[0].get("real_names_num") or 0
    # 当天供应链消费投资详情
    supply_chain_and_consumer_info = get_info_list("rz", models.SQLRecord.objects.get(id=33).content)[0]
    data_dict["supply_chain_amount"] = float(supply_chain_and_consumer_info.get("supply_chain_amount") or 0) / 10000
    data_dict["consumer_amount"] = float(supply_chain_and_consumer_info.get("consumer_amount") or 0) / 10000
    # 当天非自动续投投资详情
    un_R_xt_amount = get_info_list("rz", models.SQLRecord.objects.get(id=22).content)[0]
    data_dict["un_R_xt_person_num"] = un_R_xt_amount.get("un_R_xt_person_num") or 0
    data_dict["un_R_xt_amount"] = "%s万" % (float(un_R_xt_amount.get("un_R_xt_amount") or 0) / 10000)
    # 昨天截止同一时刻非自动续投投资详情
    yesterday_un_R_xt_amount_info = get_info_list("rz", models.SQLRecord.objects.get(id=34).content)[0]
    yesterday_un_R_xt_amount = float(yesterday_un_R_xt_amount_info.get("yesterday_un_R_xt_amount") or 0)
    data_dict["amount_compare"] = round(((
                                                 float(un_R_xt_amount.get(
                                                     "un_R_xt_amount") or 0) - yesterday_un_R_xt_amount
                                         ) / yesterday_un_R_xt_amount) * 100, 2)

    # 首页底部仪表盘详情
    # 当天总计投资详情
    data_dict["amount"] = float(
        get_info_list("rz", models.SQLRecord.objects.get(id=23).content)[0].get("amount") or 0) / 10000
    # 当天总充值
    recharge_info = get_info_list("rz", models.SQLRecord.objects.get(id=31).content)[0]
    data_dict["recharge_num"] = recharge_info.get("recharge_num") or 0
    data_dict["recharge_money"] = float(recharge_info.get("recharge_money") or 0) / 10000
    # 当天总提现
    withdraw_info = get_info_list("rz", models.SQLRecord.objects.get(id=32).content)[0]
    data_dict["withdraw_money"] = float(withdraw_info.get("withdraw_money") or 0) / 10000

    # 当天总待收金额
    data_dict["recover_account"] = float(
        get_info_list("rz", models.SQLRecord.objects.get(id=45).content)[0].get("recover_account") or 0
    ) / 10000
    # 当天总收益
    data_dict["income"] = float(
        get_info_list("rz", models.SQLRecord.objects.get(id=47).content)[0].get("income") or 0
    ) / 10000
    # 当天站岗金额
    data_dict["balance"] = float(
        get_info_list("rz", models.SQLRecord.objects.get(id=46).content)[0].get("balance") or 0
    ) / 10000

    data_dict["message"] = None  # 数据更新完毕，则充值消息为空
    lock.release()  # 释放锁


@check_permission_decorate
@login_required
def index(request):
    update_require = False  # 是否需要更新
    time_of_now = datetime.strftime(now(), "%Y-%m-%d %H:%M:%S")  # 现在的时间
    timestamp_of_now = time.mktime(time.strptime(time_of_now, "%Y-%m-%d %H:%M:%S"))  # 现在时间对应的时间戳
    last_update_time = data_dict.get("update_time")  # 上次更新的时间
    if last_update_time:  # 能获取到上次的更新时间，则将上次更新时间和现在的时间进行比较
        timestamp_of_last_update = time.mktime(time.strptime(last_update_time, "%Y-%m-%d %H:%M:%S"))  # 上次更新对应的时间戳
        if timestamp_of_now - timestamp_of_last_update >= 5 * 60:  # 间隔五分钟则会更新数据
            update_require = True
        else:
            date_of_now = datetime.strftime(now(), "%Y-%m-%d")  # 现在的日期
            last_update_date = data_dict.get("update_time").split(" ")[0]  # 上次更新的日期
            if date_of_now != last_update_date:  # 上次更新日期和现在的日期不相等则更新数据
                data_dict["message"] = "数据正在更新中，请稍后！"
                update_require = True
    else:  # 获取不到上次更新时间，则说明服务器第一次启动，需要进行更新数据操作
        update_require = True
    # print(data_dict)
    # print(time_of_now, last_update_time, update_require)
    if update_require:  # 需要更新，才会更新数据
        data_dict["update_time"] = time_of_now  # 记录本次更新时间
        data_dict["message"] = "数据正在更新中，请稍后！"
        t = threading.Thread(target=get_home_page_data)  # 生成一个用来更新数据的线程
        t.start()  # 启动线程
    return render(request, "automatic_index.html", {"data_dict": data_dict})


@check_permission_decorate
@login_required
def search_table_list(request):
    """可用查询页面"""
    if request.method == "GET":
        condition_dict = {
            "search_q": "",
            "list_per_page": [[10, 25, 50, 100], int(request.GET.get("list_per_page", 25))]
        }  # 返回给前端的过滤条件
        user = request.user  # 获取用户对象
        sql_record_objs = models.SQLRecord.objects.filter(roles__in=user.roles.all(), query_page=True).all()
        search_q = request.GET.get("search_q")  # 获取用户想要检索的查询内容
        if search_q:  # 如果用户有输入检索内容才会进行检索操作
            sql_record_objs = sql_record_objs.filter(name__contains=search_q).all()
            condition_dict["search_q"] = search_q
        sql_record_objs = get_paginator_query_sets(request, sql_record_objs, condition_dict["list_per_page"][1])
        return render(request, "search_table_list.html", {
            "sql_record_objs": sql_record_objs,
            "condition_dict": condition_dict
        })


@check_permission_decorate
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
            # 用户没有进行翻页和排序操作才会记录查询日志
            if not request.GET.get("page") and not request.GET.get("o"):
                logger.info("用户%s查询了%s,使用条件%s!" % (request.user.name, sql_record_obj.name, condition_dict))
                # 将用户查询记录添加至数据库
                models.UserSearchLog.objects.create(
                    user=request.user,
                    search_name=str(sql_record_obj.name),
                    condition_dict=str(condition_dict)
                )
            query_sets = get_contact_list(sql_record_obj, table_form_obj.cleaned_data)
            query_sets, order_by_dict = query_sets_sort(request, query_sets)  # 进行排序
    query_sets = get_paginator_query_sets(
        request, query_sets,
        request.GET.get("list_per_page", sql_record_obj.list_per_page)
    )
    return render(request, "table_search_detail.html", {
        "sql_record_obj": sql_record_obj,
        "table_form_obj": table_form_obj,
        "query_sets": query_sets,
        "condition_dict": condition_dict,
        "order_by_dict": order_by_dict
    })


@check_permission_decorate
@login_required
def search_channel_name(request):
    """查询渠道名称"""
    ret = {"status": True, "errors": None, "data": None}  # 定义返回内容
    if request.method == "GET":
        channel_name = request.GET.get("qudaoName")  # 获取用户输入的渠道名称
        # 通过用户输入的渠道名称查询对应的渠道标识
        info_list = get_info_list(
            'rz',
            "SELECT DISTINCT name from rzjf_bi.rzjf_qudao_name where name REGEXP '%s' limit 10" % channel_name
        )
        ret["data"] = info_list  # 返回给前端
        return HttpResponse(json.dumps(ret))


@check_permission_decorate
@login_required
def download_excel(request, sql_record_id):
    """导出明细至EXCEL"""
    sql_record_obj = models.SQLRecord.objects.get(id=sql_record_id)  # sql记录
    table_form_class = create_table_form(sql_record_obj)  # 动态生成table_form类
    condition_dict = get_condition_dict(request)  # 获取查询条件
    table_form_obj = table_form_class(data=condition_dict)
    download_record_obj = models.DownloadRecord.objects.filter(id=request.GET.get("download_record_id")).first()
    download_status = False  # 是否有下载权限
    # 循环用户的角色，看用户是否有角色具有下载权限
    for role_obj in request.user.roles.all():
        if role_obj.download_status:
            download_status = True
            break
    # 没有直接下载权限且对应查询记录不具备直接下载属性则需要进行下载认证
    if not download_status and not sql_record_obj.directly_download_status:
        if download_record_obj:
            if download_record_obj.check_status != 1:
                return HttpResponse("该下载记录未审核通过,您无权下载!")
        else:
            return HttpResponse("您未申请该下载记录!")
    if table_form_obj.is_valid():  # form验证
        query_sets = get_contact_list(sql_record_obj, table_form_obj.cleaned_data)
        query_sets, order_by_dict = query_sets_sort(request, query_sets)  # 进行排序
        # response = HttpResponse(content_type='application/vnd.ms-excel')
        # response['Content-Disposition'] = 'attachment; filename=' + time.strftime('%Y%m%d-%H.%M.%S', time.localtime(
        #     time.time())) + '.xls'
        workbook = xlwt.Workbook(encoding='utf-8')  # 创建工作簿
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
            data_list = []  # 存放数据的数据结构
            if len(query_sets) > 50000:  # 超过5万行的数据分sheet存放
                sheet_num = math.ceil(len(query_sets) / 50000)  # 计算需要几个sheet存放
                start = 0  # 起始位置
                for i in range(int(sheet_num)):  # 需要几个sheet就讲数据拆分几次
                    new_sheet = workbook.add_sheet("sheet%s" % (i + 1))  # 创建工作页
                    new_query_sets = query_sets[start:start + 50000]  # 对query_sets进行切片，选取本次所对应的数据列表
                    start += 50000  # 起始位置往后推5万位
                    data_list.append({"query_sets": new_query_sets, "sheet": new_sheet})
            else:
                sheet = workbook.add_sheet("sheet1")  # 创建工作页
                data_list = [{"query_sets": query_sets, "sheet": sheet}]

            for query_sets_dict in data_list:
                for index, field in enumerate(query_sets_dict["query_sets"][0].keys()):
                    query_sets_dict["sheet"].write(0, index, field, style_heading)
                for index, item in enumerate(query_sets_dict["query_sets"]):
                    for value_index, value in enumerate(item.values()):
                        if isinstance(value, datetime):
                            value = value.strftime("%Y-%m-%d %H:%M:%S")
                        if isinstance(value, date):
                            value = value.strftime("%Y-%m-%d")
                        if isinstance(value, str):
                            if value.isdigit() and len(value) == 11:  # 是数字且为11位，可以初步判断为手机号
                                value = int(value)
                        query_sets_dict["sheet"].write(index + 1, value_index, value, style_body)
        user_for_download_path = os.path.join(settings.BASE_DIR, "static", "for_download", str(request.user.id))
        os.makedirs(user_for_download_path, exist_ok=True)  # 确保路径存在
        for file_name in os.listdir(user_for_download_path):  # 将已经存在的文件删除，确保不会造成文件堆积
            file_path = os.path.join(user_for_download_path, file_name)
            os.remove(file_path)
        for_download_file_name = "%s.xls" % time.strftime('%Y%m%d-%H.%M.%S', time.localtime(time.time()))  # 生成文件名
        for_download_file_path = os.path.join(user_for_download_path, for_download_file_name)  # 要下载的文件的绝对路径
        workbook.save(for_download_file_path)  # 保存至静态文件
        download_static_url = os.path.join(
            "/static/for_download/%s/%s" % (str(request.user.id), for_download_file_name)
        )  # 生成文件的静态路径
        return redirect(download_static_url)  # 利用静态文件实现下载
    else:
        return HttpResponse("没有数据!")


@check_permission_decorate
@login_required
def user_center(request):
    """用户中心"""
    download_objs = request.user.user_download.all().order_by('-date')
    download_objs = get_paginator_query_sets(request, download_objs, request.GET.get("list_per_page", 10))
    if request.method == "GET":
        pass
    return render(request, "user_center.html", {"download_objs": download_objs})


@check_permission_decorate
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
        download_record_obj = models.DownloadRecord.objects.create(
            user=request.user,
            check_img=request.POST.get("check_img", "/static/img/check_default.jpg"),
            download_detail="%s %s<br>%s %s" % (
                request.POST.get("qudao_name", ""), sql_record_obj.name,
                request.POST.get("start_time", ""), request.POST.get("end_time", "")
            ),
            detail_url="/automatic/table_search_detail/%s/?%s" % (request.POST.get("sql_record_id", ""), condition_str),
            download_url="/automatic/download_excel/%s/?%s" % (request.POST.get("sql_record_id", ""), condition_str),
        )
        download_record_obj.download_url = "%s&download_record_id=%s" % (
            download_record_obj.download_url, download_record_obj.id
        )
        download_record_obj.save()
        return redirect("/automatic/user_center.html")
    return render(request, "download_check.html", {
        "sql_record_obj": sql_record_obj,
        "table_form_obj": table_form_obj
    })


@check_permission_decorate
@login_required
def delete_download_record(request):
    """删除下载记录"""
    ret = {"status": False, "error": None, "data": None}
    if request.method == "POST":
        download_record_id = request.POST.get("download_record_id")
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


@check_permission_decorate
@login_required
def upload_file(request):
    """上传文件至服务器"""
    ret = {"status": False, "error": None, "data": None}
    file_obj = request.FILES.get("upload_file")
    if file_obj:
        upload_file_path = os.path.join(settings.BASE_DIR, "static", "img", "upload", request.user.email)
        os.makedirs(upload_file_path, exist_ok=True)
        file_name = "%s&%s" % (create_id(), file_obj._name)
        with open(os.path.join(upload_file_path, file_name), "wb") as f:
            for line in file_obj:
                f.write(line)
        ret["status"] = True
        ret["data"] = "/static/img/upload/%s/%s" % (request.user.email, file_name)
    return HttpResponse(json.dumps(ret))


@login_required
def channel_name_detail(request):
    """渠道来源对应名称信息修改查看添加功能页面"""
    errors = {}  # 要返回的错误信息
    if request.method == "POST":
        channel_sign = request.POST.get("channel_sign")  # 渠道标识
        channel_name = request.POST.get("channel_name")  # 渠道名称
        try:
            if channel_sign and channel_name:
                cursor = connections["rz"].cursor()  # 获取一个游标
                cursor.execute(
                    "INSERT INTO `rzjf_bi`.`rzjf_qudao_name` (`sign`, `name`) VALUES ('%s', '%s');" % (
                        channel_sign, channel_name
                    )
                )  # 执行SQL
        except Exception as e:
            errors["invalid"] = e
    list_per_page = request.GET.get("list_per_page", 25)  # 获取一页显示多少条
    qudao_name = request.GET.get("qudao_name", "")  # 获取用户要查询的渠道名称
    condition_dict = {
        "list_per_page": [[10, 25, 50, 100], int(list_per_page)],
        "qudao_name": qudao_name
    }  # 返回给前端的本次查询条件
    if qudao_name:  # 查询对应渠道名称的列表信息
        channel_name_list = get_info_list(
            "rz", "SELECT sign,name from rzjf_bi.rzjf_qudao_name WHERE name REGEXP '%s'" % qudao_name
        )  # 获取用户查询的渠道名称列表
    else:
        channel_name_list = get_info_list("rz", "SELECT sign,name from rzjf_bi.rzjf_qudao_name ")  # 获取用户查询的渠道名称列表
    # 生成带分页对象的渠道名称列表
    channel_name_list = get_paginator_query_sets(request, channel_name_list, list_per_page)
    return render(request, "channel_name_detail.html", {
        "channel_name_list": channel_name_list,
        "condition_dict": condition_dict,
        "errors": errors
    })


@login_required
def change_channel_name(request):
    """修改渠道名称"""
    if request.method == "POST":
        if request.is_ajax():  # 确保是Ajax请求
            ret = {"status": False, "error": None, "data": None}  # 要返回的数据
            channel_sign = request.POST.get("channel_sign")  # 获取渠道标识
            channel_name = request.POST.get("channel_name")  # 获取渠道名称
            try:
                cursor = connections["rz"].cursor()  # 获取一个游标
                cursor.execute(
                    "update rzjf_bi.rzjf_qudao_name set name = '%s' WHERE sign = '%s'" % (
                        channel_name, channel_sign)
                )  # 执行SQL
                ret["status"] = True
            except Exception as e:
                ret["error"] = e
            return HttpResponse(json.dumps(ret))


# @login_required
# def add_userprofile(request):
#     """添加新的自动化后台账户"""
#     if request.method == "GET":
#         add_userprofile_form_obj = AddUserProfileForm()  # 创建添加账户的form对象
#     elif request.method == "POST":
#         add_userprofile_form_obj = AddUserProfileForm(request.POST)
#         if add_userprofile_form_obj.is_valid():
#             objects = models.UserProfileManager()
#             objects.create_user(
#                 add_userprofile_form_obj.cleaned_data.pop("email"),
#                 password=add_userprofile_form_obj.cleaned_data.pop("password"),
#                 name=add_userprofile_form_obj.cleaned_data.pop("name"),
#             )
#     return render(request, "add_userprofile.html", {"add_userprofile_form_obj": add_userprofile_form_obj})
