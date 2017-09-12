#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/11
from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.shortcuts import redirect
from django.views import View
from crm import models
from datetime import datetime, timedelta, date
from crm import forms


class Daily(View):
    """用于日报展示"""

    def dispatch(self, request, *args, **kwargs):
        result = super(Daily, self).dispatch(request, *args, **kwargs)
        return result

    def get_info(self, qdate):
        alert_message = ""  # 定义错误提示信息
        daily_page1 = {}  # 存放第一页数据
        base_info = models.BaseInfo.objects.using("default").filter(qdate=qdate).first()  # 获取基础信息
        invite_info = models.InviteInfo.objects.using("default").filter(qdate=qdate).first()  # 获取邀请信息
        if base_info:
            daily_page1["qdate"] = qdate  # 当前日期
            daily_page1["tz_zh"] = round(int(base_info.xztz_r) / int(base_info.zhu_r) * 100, 2)  # 当日投资转化率
            daily_page1["tz_j"] = round(int(base_info.tz_j) / 10000, 2)  # 投资金额
            daily_page1["xztz_j"] = round(int(base_info.xztz_j) / 10000, 2)  # 新增投资金额
            daily_page1["xztz_j_zb"] = round(int(base_info.xztz_j) / int(base_info.tz_j) * 100, 0)  # 新增投资金额占比
            daily_page1["sm_r"] = int(base_info.sm_r)  # 实名人数
            daily_page1["zhu_r"] = int(base_info.zhu_r)  # 注册人数
            daily_page1["tz_r"] = int(base_info.tz_r)  # 投资人数
            daily_page1["xztz_r"] = int(base_info.xztz_r)  # 新增投资人数
            daily_page1["pg_tz_j"] = round(int(base_info.tz_j) / int(base_info.tz_r) / 10000, 1)  # 平均每人投资
            if invite_info:
                daily_page1["tj_r"] = int(invite_info.invited_st_r)
        else:
            alert_message = "没有该日期的数据!"
        # tg_info = models.TgInfo.objects.using("default").filter(qdate=qdate).first()  # 获取推广信息
        # operate_info = models.OperateInfo.objects.using("default").filter(qdate=qdate).first()  # 获取运营信息
        # asset_info = models.AssetInfo.objects.using("default").filter(qdate=qdate).first()  # 获取项目信息
        # kefu_info = models.KeFuInfo.objects.using("default").filter(qdate=qdate).first()  # 获取客服信息
        # 存放第一页数据
        return daily_page1, alert_message

    def get(self, request, *args, **kwargs):
        """获取日报"""
        today = datetime.strftime(datetime.now() + timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        daily_page1, alert_message = self.get_info(today)
        daily_form = forms.DailyForm(initial={"qdate": today})
        obj_list = models.BaseInfo.objects.using("default").filter(
            qdate__range=(date.today() + timedelta(days=-8), date.today() + timedelta(days=-1))).all()
        zhu_r_list = []
        for obj in obj_list:
            zhu_r_list.append(obj.zhu_r)
        return render(
            request, "daily.html",
            {"daily_page1": daily_page1,
             "daily_form": daily_form,
             "zhu_r_list": zhu_r_list,
             "alert_message": alert_message
             }
        )

    def post(self, request, *args, **kwargs):
        """查询其他日期的日报"""
        qdate = request.POST.get("qdate")
        daily_page1, alert_message = self.get_info(qdate)
        daily_form = forms.DailyForm(request.POST, initial={"qdate": qdate})
        return render(
            request, "daily.html",
            {"daily_page1": daily_page1,
             "daily_form": daily_form,
             "alert_message": alert_message
             }
        )
