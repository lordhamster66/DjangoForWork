import logging
import json
import xlwt
import time
from datetime import date
from django.utils.timezone import datetime
from automatic import models
from automatic.forms import create_table_form
from django.shortcuts import render, HttpResponse
from django.contrib.auth.decorators import login_required
from automatic.utils import (
    get_condition_dict, get_contact_list, get_paginator_query_sets, query_sets_sort, get_info_list
)

# Create your views here.
logger = logging.getLogger("__name__")  # 生成一个以当前模块名为名字的logger实例
c_logger = logging.getLogger("collect")  # 生成一个名为'collect'的logger实例，用于收集一些需要特殊记录的日志


@login_required
def index(request):
    return render(request, "index.html")


@login_required
def search_table_list(request):
    """可用查询页面"""
    user = request.user  # 获取用户对象
    sql_record_objs = models.SQLRecord.objects.filter(roles__in=user.roles.all(), query_page=True).all()
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
    sql_record_obj = models.SQLRecord.objects.get(id=sql_record_id)  # sql记录
    table_form_class = create_table_form(sql_record_obj)  # 动态生成table_form类
    condition_dict = get_condition_dict(request)  # 获取查询条件
    table_form_obj = table_form_class(data=condition_dict)
    if table_form_obj.is_valid():  # form验证
        query_sets = get_contact_list(sql_record_obj, table_form_obj.cleaned_data)
        query_sets, order_by_dict = query_sets_sort(request, query_sets)  # 进行排序
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename=' + time.strftime('%Y%m%d-%H.%M.%S', time.localtime(
            time.time())) + '.xls'
        workbook = xlwt.Workbook(encoding='utf-8')  # 创建工作簿
        sheet = workbook.add_sheet("sheet1")  # 创建工作页
        style = xlwt.XFStyle()  # 创建格式style
        font = xlwt.Font()  # 创建font，设置字体
        font.name = 'Arial Unicode MS'  # 字体格式
        style.font = font  # 将字体font，应用到格式style
        alignment = xlwt.Alignment()  # 创建alignment，居中
        alignment.horz = xlwt.Alignment.HORZ_CENTER  # 居中
        style.alignment = alignment  # 应用到格式style
        style1 = xlwt.XFStyle()
        font1 = xlwt.Font()
        font1.name = 'Arial Unicode MS'
        # font1.colour_index = 3                  #字体颜色（绿色）
        font1.bold = True  # 字体加粗
        style1.font = font1
        style1.alignment = alignment
        if query_sets:
            for index, field in enumerate(query_sets[0].keys()):
                sheet.write(0, index, field)
            for index, item in enumerate(query_sets):
                for value_index, value in enumerate(item.values()):
                    if isinstance(value, datetime):
                        value = value.strftime("%Y-%m-%d %H:%M:%S")
                    if isinstance(value, date):
                        value = value.strftime("%Y-%m-%d")
                    sheet.write(index + 1, value_index, value)
        workbook.save(response)
        return response


@login_required
def user_center(request):
    """用户中心"""
    return render(request, "user_center.html")
