#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/16
import json
from datetime import datetime, timedelta
from django.shortcuts import render
from django.shortcuts import HttpResponse
from dm.forms.check_detail_form import CheckDetailForm
from dm.utils import get_sql_content, get_info_list, get_qudao_sign, get_query_sets, query_sets_sort


def check_detail(request):
    """查看一些明细专用"""
    if request.method == "GET":
        yesterday = datetime.strftime(datetime.now() - timedelta(1), "%Y-%m-%d")  # 获取昨天的日期
        query_sets = []  # 要返回的数据
        order_by_dict = {}
        qudao_name = request.GET.get("qudao_name", "")  # 渠道名称
        data_type = request.GET.get("data_type", 23)  # 要查询的类型
        start_time = request.GET.get("start_time", yesterday)  # 起始日期
        end_time = request.GET.get("end_time", yesterday)  # 终止日期
        # 定义查询条件
        condition_dict = {
            "data_type": data_type,
            "start_time": start_time,
            "end_time": end_time,
            "qudao_name": qudao_name,
        }
        check_detail_form = CheckDetailForm(initial=condition_dict)  # 实例化CheckDetailForm
        if data_type and start_time and end_time:
            ret = get_qudao_sign(qudao_name)  # 获取渠道名称对应的渠道标识
            if ret["status"]:
                qudao_sign = ret["data"]  # 制造渠道名称查询条件
                sql_content = get_sql_content(data_type)  # 动态获取SQL内容
                sql_content = sql_content.format(
                    start_date=start_time,
                    end_date=end_time,
                    q_name_query=qudao_sign
                )
                query_sets = get_info_list("rz", sql_content)
                # 进行排序并获取排序相关的字典
                query_sets, order_by_dict = query_sets_sort(request, query_sets, data_type="info_list")
            else:
                check_detail_form.add_error("qudao_name", "该渠道不存在，或者未添加！")  # 添加错误信息
        query_sets = get_query_sets(request, query_sets, 10)
        return render(request, "check_detail.html", {
            "check_detail_form": check_detail_form,
            "query_sets": query_sets,
            "condition_dict": condition_dict,
            "order_by_dict": order_by_dict,
        })


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
