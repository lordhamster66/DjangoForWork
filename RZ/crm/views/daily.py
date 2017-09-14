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
        daily_page8 = {}  # 存放第八页数据
        daily_page9 = {}  # 存放第九页数据
        daily_page10 = {}  # 存放第十页数据
        daily_page11 = {}  # 存放第十一页数据
        operate_dict = {}  # 存放运营概况
        invite_dict = {}  # 存放邀请概况
        asset_dict = {}  # 存放项目概况
        geduan_dict = {}  # 存放各端概况
        kefu_dict = {}  # 存放客服概况
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

            # 获取各时间段投资信息
            daily_page6["timeslot_tz_r_list"] = []  # 各时间段投资人数
            timeslot_info = models.TimeSlot.objects.using("default").filter(qdate=qdate).all()
            for obj in timeslot_info:
                daily_page6["timeslot_tz_r_list"].append(obj.tz_r)
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

            daily_page8["tg_xztz_j_list"] = []  # 近八天推广新增金额
            daily_page8["tg_xztz_r_list"] = []  # 近八天推广新增人数

            daily_page9["tg_zhu_sm_lv_list"] = []  # 注册-实名转化率
            daily_page9["tg_sm_sc_lv_list"] = []  # 实名-首充转化率
            daily_page9["tg_zhu_xztz_lv_list"] = []  # 注册-首投转化率

            daily_page10["tg_zhu_cost_list"] = []  # 注册成本
            daily_page10["tg_sm_cost_list"] = []  # 实名成本
            daily_page10["tg_xztz_cost_list"] = []  # 首投成本

            daily_page11["tg_cost_list"] = []  # 推广花费
            daily_page11["tg_roi_list"] = []  # 推广ROT
            for obj in tg_info_8:
                daily_page7["tg_zhu_r_list"].append(int(obj.tg_zhu_r))  # 推广注册人数
                daily_page7["tg_sm_r_list"].append(int(obj.tg_sm_r))  # 推广实名人数
                daily_page7["tg_sc_r_list"].append(int(obj.tg_sc_r))  # 推广首充人数

                daily_page8["tg_xztz_j_list"].append(round(int(obj.tg_xztz_j) / 10000, 2))  # 推广新增金额
                daily_page8["tg_xztz_r_list"].append(int(obj.tg_xztz_r))  # 推广新增人数

                daily_page9["tg_zhu_sm_lv_list"].append(
                    round(int(obj.tg_sm_r) / int(obj.tg_zhu_r) * 100, 2)
                )
                daily_page9["tg_sm_sc_lv_list"].append(
                    round(int(obj.tg_sc_r) / int(obj.tg_sm_r) * 100, 2)
                )
                daily_page9["tg_zhu_xztz_lv_list"].append(
                    round(int(obj.tg_xztz_r) / int(obj.tg_zhu_r) * 100, 2)
                )

                daily_page10["tg_zhu_cost_list"].append(
                    round(int(obj.tg_cost if obj.tg_cost is not None else 0) / int(obj.tg_zhu_r), 2)
                )
                daily_page10["tg_sm_cost_list"].append(
                    round(int(obj.tg_cost if obj.tg_cost is not None else 0) / int(obj.tg_sm_r), 2)
                )
                daily_page10["tg_xztz_cost_list"].append(
                    round(int(obj.tg_cost if obj.tg_cost is not None else 0) / int(obj.tg_xztz_r), 2)
                )

                daily_page11["tg_cost_list"].append(round(float(obj.tg_cost), 2) if obj.tg_cost is not None else 0)
                daily_page11["tg_roi_list"].append(
                    round(int(obj.tg_xztz_j) / int(obj.tg_cost), 2) if obj.tg_cost is not None else 0
                )

            # 获取最近8天的运营数据
            operate_info_8 = models.OperateInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-7),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all()

            operate_dict["qdate_list"] = []  # 日期列表
            operate_dict["xz_cz_list"] = []  # 新增充值
            operate_dict["hk_cz_list"] = []  # 回款并充值
            operate_dict["unhk_cz_list"] = []  # 非回款充值

            for obj in operate_info_8:
                operate_dict["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
                operate_dict["xz_cz_list"].append(round(int(obj.xz_cz) / 10000, 2))
                operate_dict["hk_cz_list"].append(round(int(obj.hk_cz) / 10000, 2))
                operate_dict["unhk_cz_list"].append(round(int(obj.unhk_cz) / 10000, 2))

            # 获取最近8天邀请数据
            invite_info_8 = models.InviteInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-7),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all()

            invite_dict["qdate_list"] = []  # 日期列表
            invite_dict["invite_r_list"] = []  # 邀请人数
            invite_dict["invited_r_list"] = []  # 被邀请人数
            invite_dict["invited_st_r_list"] = []  # 被邀请首投人数
            invite_dict["acquisition_cost_list"] = []  # 获客成本
            invite_dict["invited_st_roi_list"] = []  # 首投ROI
            invite_dict["cash_f_list"] = []  # 现金发放金额
            for obj in invite_info_8:
                invite_dict["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
                invite_dict["invite_r_list"].append(obj.invite_r)
                invite_dict["invited_r_list"].append(obj.invited_r)
                invite_dict["invited_st_r_list"].append(obj.invited_st_r)
                invite_dict["acquisition_cost_list"].append(
                    round(int(obj.cash_f if obj.cash_f is not None else 0) / int(obj.invited_st_r), 2)
                )
                invite_dict["invited_st_roi_list"].append(
                    round(int(obj.invited_st_j) / int(obj.cash_f if obj.cash_f is not None else 0), 2)
                )
                invite_dict["cash_f_list"].append(int(obj.cash_f))

            # 获取最近8天项目数据
            asset_info_8 = models.AssetInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-7),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all()

            asset_dict["qdate_list"] = []  # 日期列表
            asset_dict["A_tz_r_list"] = []  # 短标投资人数
            asset_dict["B_tz_r_list"] = []  # 1月标投资人数
            asset_dict["C_tz_r_list"] = []  # 2月标投资人数
            asset_dict["D_tz_r_list"] = []  # 3月标投资人数
            asset_dict["E_tz_r_list"] = []  # 6月标投资人数
            asset_dict["F_tz_r_list"] = []  # 10月标及以上投资人数
            asset_dict["A_tz_j_list"] = []  # 短标投资金额
            asset_dict["B_tz_j_list"] = []  # 1月标投资金额
            asset_dict["C_tz_j_list"] = []  # 2月标投资金额
            asset_dict["D_tz_j_list"] = []  # 3月标投资金额
            asset_dict["E_tz_j_list"] = []  # 6月标投资金额
            asset_dict["F_tz_j_list"] = []  # 10月标及以上投资金额
            asset_dict["A_mb_ys_list"] = []  # 短标满标用时
            asset_dict["B_mb_ys_list"] = []  # 1月标满标用时
            asset_dict["C_mb_ys_list"] = []  # 2月标满标用时
            asset_dict["D_mb_ys_list"] = []  # 3月标满标用时
            asset_dict["E_mb_ys_list"] = []  # 6月标满标用时
            asset_dict["F_mb_ys_list"] = []  # 10月标及以上满标用时
            for obj in asset_info_8:
                if obj.term == "A:短标":
                    asset_dict["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
                    asset_dict["A_tz_r_list"].append(obj.tz_r)
                    asset_dict["A_tz_j_list"].append(round(int(obj.tz_j) / 10000, 2))
                    asset_dict["A_mb_ys_list"].append(float(obj.mb_ys))
                elif obj.term == "B:1月标":
                    asset_dict["B_tz_r_list"].append(obj.tz_r)
                    asset_dict["B_tz_j_list"].append(round(int(obj.tz_j) / 10000, 2))
                    asset_dict["B_mb_ys_list"].append(float(obj.mb_ys))
                elif obj.term == "C:2月标":
                    asset_dict["C_tz_r_list"].append(obj.tz_r)
                    asset_dict["C_tz_j_list"].append(round(int(obj.tz_j) / 10000, 2))
                    asset_dict["C_mb_ys_list"].append(float(obj.mb_ys))
                elif obj.term == "D:3月标":
                    asset_dict["D_tz_r_list"].append(obj.tz_r)
                    asset_dict["D_tz_j_list"].append(round(int(obj.tz_j) / 10000, 2))
                    asset_dict["D_mb_ys_list"].append(float(obj.mb_ys))
                elif obj.term == "E:6月标":
                    asset_dict["E_tz_r_list"].append(obj.tz_r)
                    asset_dict["E_tz_j_list"].append(round(int(obj.tz_j) / 10000, 2))
                    asset_dict["E_mb_ys_list"].append(float(obj.mb_ys))
                elif obj.term == "F:10月标":
                    asset_dict["F_tz_r_list"].append(obj.tz_r)
                    asset_dict["F_tz_j_list"].append(round(int(obj.tz_j) / 10000, 2))
                    asset_dict["F_mb_ys_list"].append(float(obj.mb_ys))

            # 获取最近8天其他数据
            other_info_8 = models.OtherInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-7),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all()

            asset_dict["short_qdate_list"] = []  # 短标日期列表
            asset_dict["short_tz_j_list"] = []  # 短标交易金额
            asset_dict["short_zd_j_list"] = []  # 短标在贷金额
            asset_dict["short_tz_r_list"] = []  # 短标交易人数
            for obj in other_info_8:
                asset_dict["short_qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
                asset_dict["short_tz_j_list"].append(round(int(obj.short_tz_j) / 10000, 2))
                asset_dict["short_zd_j_list"].append(round(int(obj.short_zd_j) / 10000, 2))
                asset_dict["short_tz_r_list"].append(obj.short_tz_r)

            geduan_info = models.GeDuanInfo.objects.using("default").filter(qdate=qdate).all()  # 获取各端数据
            # 获取最近8天各端数据
            geduan_info_8 = models.GeDuanInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-7),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all()

            geduan_dict["qdate_list"] = []  # 日期
            geduan_dict["APP_account_list"] = []  # app投资
            geduan_dict["PC_account_list"] = []  # PC投资
            geduan_dict["WAP_account_list"] = []  # WAP投资
            geduan_dict["APP_xztz_j_list"] = []  # app新增投资
            geduan_dict["PC_xztz_j_list"] = []  # PC新增投资
            geduan_dict["WAP_xztz_j_list"] = []  # WAP新增投资
            geduan_dict["APP_ft_j_list"] = []  # app复投金额
            geduan_dict["PC_ft_j_list"] = []  # PC复投金额
            geduan_dict["WAP_ft_j_list"] = []  # WAP复投金额
            geduan_dict["APP_withdraw_list"] = []  # app提现金额
            geduan_dict["PC_withdraw_list"] = []  # PC提现金额
            geduan_dict["WAP_withdraw_list"] = []  # WAP提现金额
            for obj in geduan_info_8:
                if obj.geduan == "APP":
                    geduan_dict["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
                    geduan_dict["APP_account_list"].append(round(int(obj.account) / 10000, 2))
                    geduan_dict["APP_xztz_j_list"].append(round(int(obj.xztz_j) / 10000, 2))
                    geduan_dict["APP_ft_j_list"].append(round((int(obj.account) - int(obj.xztz_j)) / 10000, 2))
                    geduan_dict["APP_withdraw_list"].append(round(int(obj.withdraw) / 10000, 2))
                elif obj.geduan == "PC":
                    geduan_dict["PC_account_list"].append(round(int(obj.account) / 10000, 2))
                    geduan_dict["PC_xztz_j_list"].append(round(int(obj.xztz_j) / 10000, 2))
                    geduan_dict["PC_ft_j_list"].append(round((int(obj.account) - int(obj.xztz_j)) / 10000, 2))
                    geduan_dict["PC_withdraw_list"].append(round(int(obj.withdraw) / 10000, 2))
                elif obj.geduan == "WAP":
                    geduan_dict["WAP_account_list"].append(round(int(obj.account) / 10000, 2))
                    geduan_dict["WAP_xztz_j_list"].append(round(int(obj.xztz_j) / 10000, 2))
                    geduan_dict["WAP_ft_j_list"].append(round((int(obj.account) - int(obj.xztz_j)) / 10000, 2))
                    geduan_dict["WAP_withdraw_list"].append(round(int(obj.withdraw) / 10000, 2))

            geduan_dict["geduan_name_list"] = []  # 各端名称
            geduan_dict["geduan_recover_list"] = []  # 各端回款
            geduan_dict["geduan_recover_withdraw_list"] = []  # 各端回款并提现
            geduan_dict["geduan_proportion_list"] = []  # 各端提现占回款比重
            for obj in geduan_info:
                geduan_dict["geduan_name_list"].append(obj.geduan)
                geduan_dict["geduan_recover_list"].append(round(int(obj.recover) / 10000, 2))
                geduan_dict["geduan_recover_withdraw_list"].append(round(int(obj.recover_withdraw) / 10000, 2))
                geduan_dict["geduan_proportion_list"].append(
                    round(int(obj.recover_withdraw) / int(obj.recover) * 100, 2)
                )

            # 获取最近8天客服数据
            kefu_info_8 = models.KeFuInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-7),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all()

            kefu_dict["qdate_list"] = []  # 日期列表
            kefu_dict["st_ft_r_list"] = []  # 首投后复投人数
            kefu_dict["st_r_list"] = []  # 首投人数
            kefu_dict["ft_lv_list"] = []  # 复投率
            kefu_dict["ls_r_list"] = []  # 流失用户
            kefu_dict["zt_r_list"] = []  # 在投用户
            kefu_dict["Wastage_rate_list"] = []  # 流失率

            for obj in kefu_info_8:
                kefu_dict["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
                kefu_dict["st_ft_r_list"].append(obj.st_ft_r)
                kefu_dict["st_r_list"].append(obj.st_r)
                kefu_dict["ft_lv_list"].append(
                    round(int(obj.st_ft_r) / int(obj.st_r) * 100, 2)
                )
                kefu_dict["ls_r_list"].append(obj.ls_r)
                kefu_dict["zt_r_list"].append(obj.zt_r)
                kefu_dict["Wastage_rate_list"].append(
                    round(int(obj.ls_r) / (int(obj.ls_r) + int(obj.zt_r)) * 100, 2)
                )

        else:
            alert_message = "没有该日期的数据!"
        return (
            alert_message, daily_page1, daily_page2, daily_page3, daily_page4,
            daily_page5, daily_page6, daily_page7, daily_page8, daily_page9,
            daily_page10, daily_page11, operate_dict, invite_dict, asset_dict,
            geduan_dict, kefu_dict
        )

    def get(self, request, *args, **kwargs):
        """获取日报"""
        today = datetime.strftime(datetime.now() + timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        (
            alert_message, daily_page1, daily_page2, daily_page3, daily_page4,
            daily_page5, daily_page6, daily_page7, daily_page8, daily_page9,
            daily_page10, daily_page11, operate_dict, invite_dict, asset_dict,
            geduan_dict, kefu_dict
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
                "daily_page8": daily_page8,
                "daily_page9": daily_page9,
                "daily_page10": daily_page10,
                "daily_page11": daily_page11,
                "operate_dict": operate_dict,
                "invite_dict": invite_dict,
                "geduan_dict": geduan_dict,
                "asset_dict": asset_dict,
                "kefu_dict": kefu_dict,
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
                daily_page5, daily_page6, daily_page7, daily_page8, daily_page9,
                daily_page10, daily_page11, operate_dict, invite_dict, asset_dict,
                geduan_dict, kefu_dict
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
                    "daily_page8": daily_page8,
                    "daily_page9": daily_page9,
                    "daily_page10": daily_page10,
                    "daily_page11": daily_page11,
                    "operate_dict": operate_dict,
                    "invite_dict": invite_dict,
                    "asset_dict": asset_dict,
                    "geduan_dict": geduan_dict,
                    "kefu_dict": kefu_dict,
                    "daily_form": daily_form,
                    "alert_message": alert_message
                }
            )
        else:
            return render(request, "daily.html", {"daily_form": daily_form})
