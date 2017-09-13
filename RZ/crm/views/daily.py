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
from crm import utils


class Daily(View):
    """用于日报展示"""

    def dispatch(self, request, *args, **kwargs):
        result = super(Daily, self).dispatch(request, *args, **kwargs)
        return result

    def mom(self, this, previous):
        """获取环比"""
        try:
            this = int(this)
            previous = int(previous)
            huanbi = round((this - previous) / previous * 100, 2)
        except Exception as e:
            huanbi = 0
        return huanbi

    def up_or_down(self, huanbi):
        """上升还是下降"""
        if huanbi:
            if huanbi == 0:
                return "持平"
            elif huanbi > 0:
                return "上升"
            else:
                return "下降"
        else:
            return "持平"

    def get_info(self, qdate):
        alert_message = ""  # 定义错误提示信息
        daily_page1 = {}  # 存放第一页数据
        daily_page2 = {}  # 存放第二页数据
        daily_page3 = {}  # 存放第三页数据
        daily_page4 = {}  # 存放第四页数据
        daily_page5 = {}  # 存放第五页数据
        daily_page6 = {}  # 存放第六页数据
        daily_page7 = {}  # 存放第七页数据
        base_info = models.BaseInfo.objects.using("default").filter(qdate=qdate).first()  # 获取基础信息
        invite_info = models.InviteInfo.objects.using("default").filter(qdate=qdate).first()  # 获取邀请信息
        operate_info = models.OperateInfo.objects.using("default").filter(qdate=qdate).first()  # 获取运营信息
        tg_info = models.TgInfo.objects.using("default").filter(qdate=qdate).first()  # 获取推广信息
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

            # 第二三页数据
            # 获取最近8天的基础数据
            base_info_8 = models.BaseInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-7),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all()
            daily_page2["zhu_r_list"] = []  # 近八天注册人数
            daily_page2["xztz_r_list"] = []  # 近八天新增投资人数
            daily_page2["xztz_lv_list"] = []  # 近八天新增投资转化率
            daily_page2["qdate_list"] = []  # 近八天日期列表
            daily_page2["zhu_r_huanbi"] = ""  # 注册人数环比
            daily_page2["zhu_r_ud"] = ""  # 注册人数上升或者下降
            daily_page2["xztz_r_huanbi"] = ""  # 新增投资人数环比
            daily_page2["xztz_r_ud"] = ""  # 新增投资人数上升或者下降

            daily_page3["hk_j"] = round(int(base_info.hk_j) / 10000, 2)  # 回款金额
            daily_page3["zg_j"] = round(int(base_info.zg_j) / 10000, 2)  # 站岗资金
            daily_page3["tz_j_list"] = []  # 近八天投资金额
            daily_page3["hk_j_list"] = []  # 近八天回款金额
            daily_page3["zg_j_list"] = []  # 近八天站岗资金
            daily_page3["tz_j_huanbi"] = ""
            daily_page3["tz_j_ud"] = ""
            daily_page3["hk_j_huanbi"] = ""
            daily_page3["hk_j_ud"] = ""
            daily_page3["zg_j_huanbi"] = ""
            daily_page3["zg_j_ud"] = ""
            daily_page3["zj_ft_lv"] = round(float(operate_info.zj_ft_lv) * 100, 2)  # 资金复投率
            daily_page3["rs_ft_lv"] = round(float(operate_info.rs_ft_lv) * 100, 2)  # 人数复投率

            daily_page4["cz_j"] = round(int(base_info.cz_j) / 10000, 2)  # 充值金额
            daily_page4["tx_j"] = round(int(base_info.tx_j) / 10000, 2)  # 提现金额
            daily_page4["income"] = round((int(base_info.cz_j) - int(base_info.tx_j)) / 10000, 2)  # 净流入
            daily_page4["cz_j_list"] = []  # 近八天充值金额
            daily_page4["tx_j_list"] = []  # 近八天提现金额
            daily_page4["income_list"] = []  # 近八天净流入
            daily_page4["cz_j_huanbi"] = ""
            daily_page4["cz_j_ud"] = ""
            daily_page4["tx_j_huanbi"] = ""
            daily_page4["tx_j_ud"] = ""

            daily_page5["tz_r_list"] = []  # 近八天投资人数
            daily_page5["tz_b_list"] = []  # 近八天投资笔数
            daily_page5["tz_dl_r_list"] = []  # 近八天投资用户登录数

            for obj in base_info_8:
                daily_page2["zhu_r_list"].append(obj.zhu_r)
                daily_page2["xztz_r_list"].append(obj.xztz_r)
                xztz_lv = round(int(obj.xztz_r) / int(obj.zhu_r) * 100, 2)  # 新增投资转化率
                daily_page2["xztz_lv_list"].append(xztz_lv)
                daily_page2["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))

                daily_page3["tz_j_list"].append(round(int(obj.tz_j) / 10000, 2))  # 投资金额
                daily_page3["hk_j_list"].append(round(int(obj.hk_j) / 10000, 2))  # 回款金额
                daily_page3["zg_j_list"].append(round(int(obj.zg_j) / 10000, 2))  # 站岗资金

                daily_page4["cz_j_list"].append(round(int(obj.cz_j) / 10000, 2))  # 充值金额
                daily_page4["tx_j_list"].append(round(int(obj.tx_j) / 10000, 2))  # 提现金额
                daily_page4["income_list"].append(round((int(obj.cz_j) - int(obj.tx_j)) / 10000, 2))  # 净流入

                daily_page5["tz_r_list"].append(int(obj.tz_r))  # 投资人数
                daily_page5["tz_b_list"].append(int(obj.tz_b))  # 投资笔数
                daily_page5["tz_dl_r_list"].append(int(obj.tz_dl_r))  # 投资用户登录数

                this = datetime.strftime(obj.qdate, "%Y-%m-%d")
                previous = datetime.strftime(datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-1), "%Y-%m-%d")
                if this == previous:  # 判断是否为当前日期的前一天
                    zhu_r_huanbi = self.mom(daily_page1["zhu_r"], obj.zhu_r)
                    daily_page2["zhu_r_ud"] = self.up_or_down(zhu_r_huanbi)
                    daily_page2["zhu_r_huanbi"] = abs(zhu_r_huanbi)
                    xztz_r_huanbi = self.mom(daily_page1["xztz_r"], obj.xztz_r)
                    daily_page2["xztz_r_ud"] = self.up_or_down(xztz_r_huanbi)
                    daily_page2["xztz_r_huanbi"] = abs(xztz_r_huanbi)

                    tz_j_huanbi = self.mom(daily_page1["tz_j"], obj.tz_j)
                    daily_page3["tz_j_ud"] = self.up_or_down(tz_j_huanbi)
                    daily_page3["tz_j_huanbi"] = abs(tz_j_huanbi)

                    hk_j_huanbi = self.mom(base_info.hk_j, obj.hk_j)
                    daily_page3["hk_j_ud"] = self.up_or_down(hk_j_huanbi)
                    daily_page3["hk_j_huanbi"] = abs(hk_j_huanbi)

                    zg_j_huanbi = self.mom(base_info.zg_j, obj.zg_j)
                    daily_page3["zg_j_ud"] = self.up_or_down(zg_j_huanbi)
                    daily_page3["zg_j_huanbi"] = abs(zg_j_huanbi)

                    cz_j_huanbi = self.mom(base_info.cz_j, obj.cz_j)
                    daily_page4["cz_j_ud"] = self.up_or_down(cz_j_huanbi)
                    daily_page4["cz_j_huanbi"] = abs(cz_j_huanbi)

                    tx_j_huanbi = self.mom(base_info.tx_j, obj.tx_j)
                    daily_page4["tx_j_ud"] = self.up_or_down(tx_j_huanbi)
                    daily_page4["tx_j_huanbi"] = abs(tx_j_huanbi)

            # 获取最近8天的推广数据
            tg_info_8 = models.TgInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-7),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all()
            daily_page7["tg_zhu_r_list"] = []  # 近八天推广注册人数
            daily_page7["tg_sm_r_list"] = []  # 近八天推广实名人数
            daily_page7["tg_sc_r_list"] = []  # 近八天推广首充人数
            for obj in tg_info_8:
                daily_page7["tg_zhu_r_list"].append(int(obj.tg_zhu_r))  # 推广注册人数
                daily_page7["tg_sm_r_list"].append(int(obj.tg_sm_r))  # 推广实名人数
                daily_page7["tg_sc_r_list"].append(int(obj.tg_sc_r))  # 推广首充人数

        else:
            alert_message = "没有该日期的数据!"
        # asset_info = models.AssetInfo.objects.using("default").filter(qdate=qdate).first()  # 获取项目信息
        # kefu_info = models.KeFuInfo.objects.using("default").filter(qdate=qdate).first()  # 获取客服信息
        # 存放第一页数据
        return (
            alert_message, daily_page1, daily_page2, daily_page3, daily_page4,
            daily_page5, daily_page6, daily_page7
        )

    def get(self, request, *args, **kwargs):
        """获取日报"""
        today = datetime.strftime(datetime.now() + timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        (
            alert_message, daily_page1, daily_page2, daily_page3, daily_page4,
            daily_page5, daily_page6, daily_page7
        ) = self.get_info(today)
        daily_form = forms.DailyForm(initial={"qdate": today})
        daily_form.is_valid()
        return render(
            request, "daily.html",
            {
                "daily_page1": daily_page1,
                "daily_page2": daily_page2,
                "daily_page3": daily_page3,
                "daily_page4": daily_page4,
                "daily_page5": daily_page5,
                "daily_page6": daily_page6,
                "daily_page7": daily_page7,
                "daily_form": daily_form,
                "alert_message": alert_message
            }
        )

    def post(self, request, *args, **kwargs):
        """查询其他日期的日报"""
        qdate = request.POST.get("qdate")  # 获取用户输入的日期
        daily_form = forms.DailyForm(request.POST, initial={"qdate": qdate})
        if daily_form.is_valid():
            (
                alert_message, daily_page1, daily_page2, daily_page3, daily_page4,
                daily_page5, daily_page6, daily_page7
            ) = self.get_info(qdate)
            return render(
                request, "daily.html",
                {
                    "daily_page1": daily_page1,
                    "daily_page2": daily_page2,
                    "daily_page3": daily_page3,
                    "daily_page4": daily_page4,
                    "daily_page5": daily_page5,
                    "daily_page6": daily_page6,
                    "daily_page7": daily_page7,
                    "daily_form": daily_form,
                    "alert_message": alert_message
                }
            )
        else:
            return render(request, "daily.html", {"daily_form": daily_form})
