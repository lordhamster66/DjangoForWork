#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/2
from datetime import datetime, timedelta
from django.shortcuts import render
from crm.forms import SalesAchievementForm
from utils import db_connect
from utils.pagination import Page


def sales_achievement(request):
    """
    展示电销业绩
    :param request:
    :return:
    """
    if request.method == "GET":
        current_page = request.GET.get("p")  # 获取用户想看的页数，默认是第一页
        # 获取客服ID
        kefu_id = request.session.get(
            "sales_achievement_kefu_id",
            "1285094,1285095,1285099,1285100,1296124,1455368,1455369,1455375"
        )
        if current_page:
            current_page = int(current_page)
            # 获取起始日期，默认为本月第一天
            start_time = request.session.get(
                "sales_achievement_start_time",
                datetime.date(datetime.now()).replace(day=1)
            )
            # 获取终止日期，默认为昨天
            end_time = request.session.get(
                "sales_achievement_end_time", datetime.date(datetime.now()) - timedelta(1)
            )
        else:  # 相当于用户第一次访问
            current_page = 1
            start_time = datetime.date(datetime.now()).replace(day=1)
            end_time = datetime.date(datetime.now()) - timedelta(1)
        sales_achievement_obj = SalesAchievementForm(initial={
            "kefu_id": kefu_id,
            "start_time": start_time,
            "end_time": end_time
        })  # 获取电销业绩展示form
        # 获取电销业绩展示SQL
        sales_achievement_sql = db_connect.get_sql("crm", "RzSql", "exhibition", "sales_achievement.sql")
        # 获取电销业绩详情列表
        sales_achievement_info_list = db_connect.get_info_list("rz", sales_achievement_sql.format(
            kefu_id=kefu_id,
            start_time=start_time,
            end_time=end_time,
        ))
        sales_achievement_chart_display_info_list = sales_achievement_info_list[:-1]  # 剔除总计
        chart_display_dict = {
            "kefu_list": [],  # 客服列表
            "tz_j_list": [],  # 投资金额列表
            "nianhua_list": [],  # 年化金额列表
            "recover_account_list": [],  # 待收金额列表
        }
        for item in sales_achievement_chart_display_info_list:
            chart_display_dict["kefu_list"].append(item["kefu"])
            chart_display_dict["tz_j_list"].append(float(item["tz_j"]))
            chart_display_dict["nianhua_list"].append(float(item["nianhua"]))
            chart_display_dict["recover_account_list"].append(float(item["recover_account"]))
        page_obj = Page(current_page, len(sales_achievement_info_list))  # 获取分页对象
        sales_achievement_info_list = sales_achievement_info_list[page_obj.start:page_obj.end]  # 对详情列表进行拆分
        page_str = page_obj.page_str("/crm/sales_achievement/")  # 获取分页HTML
        return render(request, "sales_achievement.html", {
            "sales_achievement_obj": sales_achievement_obj,
            "sales_achievement_info_list": sales_achievement_info_list,
            "page_str": page_str,
            "chart_display_dict": chart_display_dict
        })
    elif request.method == "POST":
        sales_achievement_obj = SalesAchievementForm(request.POST)  # 获取form对象
        if sales_achievement_obj.is_valid():
            kefu_id = sales_achievement_obj.cleaned_data.pop("kefu_id")
            # 格式化用户输入起始日期
            start_time = datetime.strftime(sales_achievement_obj.cleaned_data.pop("start_time"), "%Y-%m-%d")
            # 格式化用户输入终止日期
            end_time = datetime.strftime(sales_achievement_obj.cleaned_data.pop("end_time"), "%Y-%m-%d")
            request.session["sales_achievement_kefu_id"] = kefu_id  # 存储用户本次查询的客服ID
            request.session["sales_achievement_start_time"] = start_time  # 存储用户本次查询的起始日期
            request.session["sales_achievement_end_time"] = end_time  # 存储用户本次查询的终止日期
            # 获取电销业绩展示SQL
            sales_achievement_sql = db_connect.get_sql("crm", "RzSql", "exhibition", "sales_achievement.sql")
            # 获取电销业绩详情列表
            sales_achievement_info_list = db_connect.get_info_list("rz", sales_achievement_sql.format(
                kefu_id=kefu_id,
                start_time=start_time,
                end_time=end_time,
            ))
            sales_achievement_chart_display_info_list = sales_achievement_info_list[:-1]  # 剔除总计
            chart_display_dict = {
                "kefu_list": [],  # 客服列表
                "tz_j_list": [],  # 投资金额列表
                "nianhua_list": [],  # 年化金额列表
                "recover_account_list": [],  # 待收金额列表
            }
            for item in sales_achievement_chart_display_info_list:
                chart_display_dict["kefu_list"].append(item["kefu"])
                chart_display_dict["tz_j_list"].append(float(item["tz_j"]))
                chart_display_dict["nianhua_list"].append(float(item["nianhua"]))
                chart_display_dict["recover_account_list"].append(float(item["recover_account"]))
            page_obj = Page(1, len(sales_achievement_info_list))  # 获取分页对象
            sales_achievement_info_list = sales_achievement_info_list[page_obj.start:page_obj.end]  # 对详情列表进行拆分
            page_str = page_obj.page_str("/crm/sales_achievement/")  # 获取分页HTML
            return render(request, "sales_achievement.html", {
                "sales_achievement_obj": sales_achievement_obj,
                "sales_achievement_info_list": sales_achievement_info_list,
                "page_str": page_str,
                "chart_display_dict": chart_display_dict
            })
        else:
            return render(request, "sales_achievement.html", {
                "sales_achievement_obj": sales_achievement_obj
            })
