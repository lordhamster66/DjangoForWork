#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/16
import json
import xlwt
import time
from datetime import date
from django.utils.timezone import datetime, timedelta
from django.shortcuts import render
from django.shortcuts import HttpResponse
from dm.forms.check_detail_form import CheckDetailForm
from dm.utils import get_info_list, get_qudao_sign, get_paginator_query_sets, query_sets_sort
from dm.utils import get_query_sets, get_condition_dict, login_decorator


@login_decorator
def check_detail(request):
    """查看一些明细专用"""
    alert_message = ""  # 错误信息
    if request.method == "GET":
        yesterday = datetime.strftime(datetime.now() - timedelta(1), "%Y-%m-%d")  # 获取昨天的日期
        query_sets = []  # 要D返回的数据
        order_by_dict = {}
        qudao_name = request.GET.get("qudao_name", "")  # 渠道名称
        data_type = request.GET.get("data_type", 25)  # 要查询的类型
        start_time = request.GET.get("start_time", yesterday)  # 起始日期
        end_time = request.GET.get("end_time", yesterday)  # 终止日期
        # 定义查询条件
        condition_dict = {
            "data_type": data_type,
            "start_time": start_time,
            "end_time": end_time,
            "qudao_name": qudao_name,
        }
        check_detail_form = CheckDetailForm(data=condition_dict)  # 实例化CheckDetailForm
        if check_detail_form.is_valid():
            ret = get_qudao_sign(qudao_name)  # 获取渠道名称对应的渠道标识
            if ret["status"]:
                query_sets = get_query_sets(request, ret, condition_dict)
                # 进行排序并获取排序相关的字典
                query_sets, order_by_dict = query_sets_sort(request, query_sets, data_type="info_list")
            else:
                check_detail_form.add_error("qudao_name", "渠道名称有误或者不存在！")
        query_sets = get_paginator_query_sets(request, query_sets, 10)  # 获取带分页功能的query_sets
        return render(request, "check_detail.html", {
            "check_detail_form": check_detail_form,
            "query_sets": query_sets,
            "condition_dict": condition_dict,
            "order_by_dict": order_by_dict,
            "search_content": request.GET.get("_q", ""),
            "alert_message": alert_message
        })


@login_decorator
def download_detail(request):
    """导出明细至EXCEL"""
    condition_dict = get_condition_dict(request)
    ret = get_qudao_sign(condition_dict.get("qudao_name", ""))  # 获取渠道名称对应的渠道标识
    if ret["status"]:
        query_sets = get_query_sets(request, ret, condition_dict)
        # 进行排序并获取排序相关的字典
        query_sets = query_sets_sort(request, query_sets, data_type="info_list")[0]
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
    else:
        return HttpResponse("渠道名称有误或者不存在！")


@login_decorator
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
