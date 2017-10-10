#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/11
"""
日报功能实现模块
"""
import os
from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.shortcuts import redirect
from django.views import View
from crm import models
from datetime import datetime, timedelta, date
from crm import forms
from django.db import connections
from RZ import settings
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
        except Exception:
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

    def get_sql(self, catalog, file_name):
        """获取SQL信息"""
        file_path = os.path.join(settings.BASE_DIR, "crm", "RzSql", catalog, file_name)
        f = open(file_path, "r", encoding="utf-8")
        sql = f.read()
        f.close()
        return sql

    def get_info_list(self, sql, db="default"):
        """获取SQL执行结果"""
        cursor = connections[db].cursor()
        cursor.execute(sql)
        data = cursor.fetchall()
        col_names = [i[0] for i in cursor.description]
        info_list = [dict(zip(col_names, row)) for row in data]
        return info_list

    def get_info(self, qdate, section=8):
        """获取日报所需数据"""
        alert_message = ""  # 定义错误提示信息
        base_dict = {}  # 存放平台概况
        tg_dict = {}  # 存放推广概况
        operate_dict = {}  # 存放运营概况
        invite_dict = {}  # 存放邀请概况
        asset_dict = {}  # 存放项目概况
        geduan_dict = {}  # 存放各端概况
        kefu_dict = {}  # 存放客服概况
        base_info = models.BaseInfo.objects.using("default").filter(qdate=qdate).first()  # 获取基础信息
        timeslot_info = models.TimeSlot.objects.using("default").filter(qdate=qdate).all()  # 获取各时间段投资信息
        invite_info = models.InviteInfo.objects.using("default").filter(qdate=qdate).first()  # 获取邀请信息
        operate_info = models.OperateInfo.objects.using("default").filter(qdate=qdate).first()  # 获取运营信息
        tg_info = models.TgInfo.objects.using("default").filter(qdate=qdate).first()  # 获取推广信息
        geduan_info = models.GeDuanInfo.objects.using("default").filter(qdate=qdate).all()  # 获取各端数据
        if base_info and timeslot_info and invite_info and operate_info and tg_info and geduan_info:
            base_dict["qdate"] = qdate  # 当前日期
            base_dict["tz_zh"] = round(int(base_info.xztz_r) / int(base_info.zhu_r) * 100, 2)  # 当日投资转化率
            base_dict["tz_j"] = round(int(base_info.tz_j) / 10000, 2)  # 投资金额
            base_dict["xztz_j"] = round(int(base_info.xztz_j) / 10000, 2)  # 新增投资金额
            base_dict["xztz_j_zb"] = round(int(base_info.xztz_j) / int(base_info.tz_j) * 100, 0)  # 新增投资金额占比
            base_dict["sm_r"] = int(base_info.sm_r)  # 实名人数
            base_dict["zhu_r"] = int(base_info.zhu_r)  # 注册人数
            base_dict["tz_r"] = int(base_info.tz_r)  # 投资人数
            base_dict["xztz_r"] = int(base_info.xztz_r)  # 新增投资人数
            base_dict["pg_tz_j"] = round(int(base_info.tz_j) / int(base_info.tz_r) / 10000, 1)  # 平均每人投资
            if invite_info:
                base_dict["tj_r"] = int(invite_info.invited_st_r)

            # 第二三页数据
            # 获取最近8天的基础数据
            base_info_8 = models.BaseInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-(section - 1)),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all().order_by("qdate")
            base_dict["zhu_r_list"] = []  # 近八天注册人数
            base_dict["xztz_r_list"] = []  # 近八天新增投资人数
            base_dict["xztz_lv_list"] = []  # 近八天新增投资转化率
            base_dict["qdate_list"] = []  # 近八天日期列表
            base_dict["zhu_r_huanbi"] = ""  # 注册人数环比
            base_dict["zhu_r_ud"] = ""  # 注册人数上升或者下降
            base_dict["xztz_r_huanbi"] = ""  # 新增投资人数环比
            base_dict["xztz_r_ud"] = ""  # 新增投资人数上升或者下降

            base_dict["hk_j"] = round(int(base_info.hk_j) / 10000, 2)  # 回款金额
            base_dict["zg_j"] = round(int(base_info.zg_j) / 10000, 2)  # 站岗资金
            base_dict["tz_j_list"] = []  # 近八天投资金额
            base_dict["hk_j_list"] = []  # 近八天回款金额
            base_dict["zg_j_list"] = []  # 近八天站岗资金
            base_dict["tz_j_huanbi"] = ""
            base_dict["tz_j_ud"] = ""
            base_dict["hk_j_huanbi"] = ""
            base_dict["hk_j_ud"] = ""
            base_dict["zg_j_huanbi"] = ""
            base_dict["zg_j_ud"] = ""
            base_dict["zj_ft_lv"] = round(float(operate_info.zj_ft_lv) * 100, 2)  # 资金复投率
            base_dict["rs_ft_lv"] = round(float(operate_info.rs_ft_lv) * 100, 2)  # 人数复投率

            base_dict["cz_j"] = round(int(base_info.cz_j) / 10000, 2)  # 充值金额
            base_dict["tx_j"] = round(int(base_info.tx_j) / 10000, 2)  # 提现金额
            base_dict["income"] = round((int(base_info.cz_j) - int(base_info.tx_j)) / 10000, 2)  # 净流入
            base_dict["cz_j_list"] = []  # 近八天充值金额
            base_dict["tx_j_list"] = []  # 近八天提现金额
            base_dict["income_list"] = []  # 近八天净流入
            base_dict["cz_j_huanbi"] = ""
            base_dict["cz_j_ud"] = ""
            base_dict["tx_j_huanbi"] = ""
            base_dict["tx_j_ud"] = ""

            base_dict["tz_r_list"] = []  # 近八天投资人数
            base_dict["tz_b_list"] = []  # 近八天投资笔数
            base_dict["tz_dl_r_list"] = []  # 近八天投资用户登录数

            for obj in base_info_8:
                base_dict["zhu_r_list"].append(obj.zhu_r)
                base_dict["xztz_r_list"].append(obj.xztz_r)
                xztz_lv = round(int(obj.xztz_r) / int(obj.zhu_r) * 100, 2)  # 新增投资转化率
                base_dict["xztz_lv_list"].append(xztz_lv)
                base_dict["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))

                base_dict["tz_j_list"].append(round(int(obj.tz_j) / 10000, 2))  # 投资金额
                base_dict["hk_j_list"].append(round(int(obj.hk_j) / 10000, 2))  # 回款金额
                base_dict["zg_j_list"].append(round(int(obj.zg_j) / 10000, 2))  # 站岗资金

                base_dict["cz_j_list"].append(round(int(obj.cz_j) / 10000, 2))  # 充值金额
                base_dict["tx_j_list"].append(round(int(obj.tx_j) / 10000, 2))  # 提现金额
                base_dict["income_list"].append(round((int(obj.cz_j) - int(obj.tx_j)) / 10000, 2))  # 净流入

                base_dict["tz_r_list"].append(int(obj.tz_r))  # 投资人数
                base_dict["tz_b_list"].append(int(obj.tz_b))  # 投资笔数
                base_dict["tz_dl_r_list"].append(obj.tz_dl_r if obj.tz_dl_r is not None else 0)  # 投资用户登录数

                this = datetime.strftime(obj.qdate, "%Y-%m-%d")
                previous = datetime.strftime(datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-1), "%Y-%m-%d")
                if this == previous:  # 判断是否为当前日期的前一天
                    zhu_r_huanbi = self.mom(base_dict["zhu_r"], obj.zhu_r)
                    base_dict["zhu_r_ud"] = self.up_or_down(zhu_r_huanbi)
                    base_dict["zhu_r_huanbi"] = abs(zhu_r_huanbi)
                    xztz_r_huanbi = self.mom(base_dict["xztz_r"], obj.xztz_r)
                    base_dict["xztz_r_ud"] = self.up_or_down(xztz_r_huanbi)
                    base_dict["xztz_r_huanbi"] = abs(xztz_r_huanbi)

                    tz_j_huanbi = self.mom(base_dict["tz_j"], obj.tz_j)
                    base_dict["tz_j_ud"] = self.up_or_down(tz_j_huanbi)
                    base_dict["tz_j_huanbi"] = abs(tz_j_huanbi)

                    hk_j_huanbi = self.mom(base_info.hk_j, obj.hk_j)
                    base_dict["hk_j_ud"] = self.up_or_down(hk_j_huanbi)
                    base_dict["hk_j_huanbi"] = abs(hk_j_huanbi)

                    zg_j_huanbi = self.mom(base_info.zg_j, obj.zg_j)
                    base_dict["zg_j_ud"] = self.up_or_down(zg_j_huanbi)
                    base_dict["zg_j_huanbi"] = abs(zg_j_huanbi)

                    cz_j_huanbi = self.mom(base_info.cz_j, obj.cz_j)
                    base_dict["cz_j_ud"] = self.up_or_down(cz_j_huanbi)
                    base_dict["cz_j_huanbi"] = abs(cz_j_huanbi)

                    tx_j_huanbi = self.mom(base_info.tx_j, obj.tx_j)
                    base_dict["tx_j_ud"] = self.up_or_down(tx_j_huanbi)
                    base_dict["tx_j_huanbi"] = abs(tx_j_huanbi)

            # 获取各时间段投资信息
            base_dict["timeslot_tz_r_list"] = []  # 各时间段投资人数
            for obj in timeslot_info:
                base_dict["timeslot_tz_r_list"].append(obj.tz_r)

            # 获取最近8天的推广数据
            tg_info_8 = models.TgInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-(section - 1)),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all().order_by("qdate")

            tg_dict["qdate_list"] = []  # 近八天日期列表
            tg_dict["tg_zhu_r_list"] = []  # 近八天推广注册人数
            tg_dict["tg_sm_r_list"] = []  # 近八天推广实名人数
            tg_dict["tg_sc_r_list"] = []  # 近八天推广首充人数

            tg_dict["tg_xztz_j_list"] = []  # 近八天推广新增金额
            tg_dict["tg_xztz_r_list"] = []  # 近八天推广新增人数

            tg_dict["tg_zhu_sm_lv_list"] = []  # 注册-实名转化率
            tg_dict["tg_sm_sc_lv_list"] = []  # 实名-首充转化率
            tg_dict["tg_zhu_xztz_lv_list"] = []  # 注册-首投转化率

            tg_dict["tg_zhu_cost_list"] = []  # 注册成本
            tg_dict["tg_sm_cost_list"] = []  # 实名成本
            tg_dict["tg_xztz_cost_list"] = []  # 首投成本

            tg_dict["tg_cost_list"] = []  # 推广花费
            tg_dict["tg_roi_list"] = []  # 推广ROT
            for obj in tg_info_8:
                tg_dict["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
                tg_dict["tg_zhu_r_list"].append(int(obj.tg_zhu_r))  # 推广注册人数
                tg_dict["tg_sm_r_list"].append(int(obj.tg_sm_r))  # 推广实名人数
                tg_dict["tg_sc_r_list"].append(int(obj.tg_sc_r))  # 推广首充人数

                tg_dict["tg_xztz_j_list"].append(round(int(obj.tg_xztz_j) / 10000, 2))  # 推广新增金额
                tg_dict["tg_xztz_r_list"].append(int(obj.tg_xztz_r))  # 推广新增人数

                tg_dict["tg_zhu_sm_lv_list"].append(
                    round(int(obj.tg_sm_r) / int(obj.tg_zhu_r) * 100, 2)
                )
                tg_dict["tg_sm_sc_lv_list"].append(
                    round(int(obj.tg_sc_r) / int(obj.tg_sm_r) * 100, 2)
                )
                tg_dict["tg_zhu_xztz_lv_list"].append(
                    round(int(obj.tg_xztz_r) / int(obj.tg_zhu_r) * 100, 2)
                )

                tg_dict["tg_zhu_cost_list"].append(
                    round(int(obj.tg_cost if obj.tg_cost is not None else 0) / int(obj.tg_zhu_r), 2)
                )
                tg_dict["tg_sm_cost_list"].append(
                    round(int(obj.tg_cost if obj.tg_cost is not None else 0) / int(obj.tg_sm_r), 2)
                )
                tg_dict["tg_xztz_cost_list"].append(
                    round(int(obj.tg_cost if obj.tg_cost is not None else 0) / int(obj.tg_xztz_r), 2)
                )

                tg_dict["tg_cost_list"].append(round(float(obj.tg_cost), 2) if obj.tg_cost is not None else 0)
                tg_dict["tg_roi_list"].append(
                    round(int(obj.tg_xztz_j) / int(obj.tg_cost), 2) if obj.tg_cost is not None else 0
                )

            # 获取最近8天的运营数据
            operate_info_8 = models.OperateInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-(section - 1)),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all().order_by("qdate")

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
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-(section - 1)),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all().order_by("qdate")

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
            rzjf_asset_info_sql = self.get_sql("daily", "rzjf_asset_info.sql")  # 获取SQL
            rzjf_asset_info_sql = rzjf_asset_info_sql.format(qdate=qdate, section=section)  # 格式化SQL语句
            info_list = self.get_info_list(rzjf_asset_info_sql)  # 执行SQL并获取结果
            # 定义颜色取值范围
            color_list = ['#31859c', '#d99694', '#c3d69b', '#95b3d7', '#4bacc6', '#e67519', '#00b38c', '#00b0f0',
                          '#82abba']
            asset_dict["qdate_list"] = []  # 最终去重日期列表
            asset_dict["term_title_list"] = []  # 定义期限名称列表
            asset_dict["term_list"] = []  # 存放期限对应的数据

            for row in info_list:
                temp_term = row.get("term")  # 本次循环到的期限
                if temp_term not in asset_dict["term_title_list"]:  # 如果期限不在期限名称列表里面
                    asset_dict["term_title_list"].append(temp_term)  # 存放期限至期限名称列表
                    temp_index = asset_dict["term_title_list"].index(temp_term)  # 获取该期限名称在列表的索引
                    # 为该期限生成对应的字典
                    asset_dict["term_list"].append({
                        "term": temp_term,  # 期限名称
                        "tz_r": [],  # 投资人数列表
                        "tz_j": [],  # 投资金额列表
                        "mb_ys": [],  # 满标用时列表
                        "color": color_list[temp_index] if temp_index < len(color_list) else '#82abba'  # 定义该期限类型颜色
                    }
                    )

                # 存放期限对应的数据
                for term_dict in asset_dict["term_list"]:
                    if temp_term == term_dict["term"]:  # 期限名称
                        term_dict["tz_r"].append(int(row.get("tz_r")))
                        term_dict["tz_j"].append(round(int(row.get("tz_j")) / 10000, 2))
                        term_dict["mb_ys"].append(float(row.get("mb_ys")))

                # 获取本次循环渠道的日期
                temp_qdate = datetime.strftime(row.get("qdate"), "%m-%d")

                # 存放不重复的日期
                if temp_qdate not in asset_dict["qdate_list"]:
                    asset_dict["qdate_list"].append(temp_qdate)

            # 获取最近8天其他数据
            other_info_8 = models.OtherInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-(section - 1)),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all().order_by("qdate")

            asset_dict["short_qdate_list"] = []  # 短标日期列表
            asset_dict["short_tz_j_list"] = []  # 短标交易金额
            asset_dict["short_zd_j_list"] = []  # 短标在贷金额
            asset_dict["short_tz_r_list"] = []  # 短标交易人数
            asset_dict["Rplan_tz_j_list"] = []  # R计划交易人数
            asset_dict["Rplan_zd_j_list"] = []  # R计划在贷金额
            for obj in other_info_8:
                asset_dict["short_qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
                asset_dict["short_tz_j_list"].append(round(int(obj.short_tz_j) / 10000, 2))
                asset_dict["short_zd_j_list"].append(round(int(obj.short_zd_j) / 10000, 2))
                asset_dict["short_tz_r_list"].append(obj.short_tz_r)
                asset_dict["Rplan_tz_j_list"].append(
                    round(int(obj.Rplan_account if obj.Rplan_account is not None else 0) / 10000, 2)
                )
                asset_dict["Rplan_zd_j_list"].append(
                    round(int(obj.Rplan_recover_account if obj.Rplan_recover_account is not None else 0) / 10000, 2)
                )

            # 获取最近8天各端数据
            geduan_info_8 = models.GeDuanInfo.objects.using("default").filter(
                qdate__range=(
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-(section - 1)),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all().order_by("qdate")

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
                    datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-(section - 1)),
                    datetime.strptime(qdate, "%Y-%m-%d")
                )
            ).all().order_by("qdate")

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
            alert_message, base_dict, tg_dict, operate_dict,
            invite_dict, asset_dict, geduan_dict, kefu_dict
        )

    def get(self, request, *args, **kwargs):
        """获取日报"""
        today = datetime.strftime(datetime.now() + timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        daily_form = forms.DailyForm(initial={"qdate": today, "section": "8"})  # 生成DailyForm对象
        (
            alert_message, base_dict, tg_dict, operate_dict,
            invite_dict, asset_dict, geduan_dict, kefu_dict
        ) = self.get_info(today)  # 获取日报所需数据
        return render(
            request, "daily.html",
            {
                "base_dict": base_dict,
                "tg_dict": tg_dict,
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
        daily_form = forms.DailyForm(request.POST)  # 生成DailyForm对象
        if daily_form.is_valid():  # 对用户输入的日期格式进行检查
            section = daily_form.cleaned_data.get("section", 8)  # 获取检查过的区间，没有则默认为8
            section = int(section) if section != "" else 8  # 如果用户没有选择区间，则默认为8
            (
                alert_message, base_dict, tg_dict, operate_dict,
                invite_dict, asset_dict, geduan_dict, kefu_dict
            ) = self.get_info(qdate, section)  # 获取日报所需数据
            return render(
                request, "daily.html",
                {
                    "base_dict": base_dict,
                    "tg_dict": tg_dict,
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


def monthly(request):
    """月度数据"""

    def monthly_get_info(qdate, section=60):
        """获取月度数据"""
        alert_message = ""  # 定义错误提示信息
        monthly_base_dict = {}  # 存放平台概况
        # 获取最近60天的基础数据
        base_info = models.BaseInfo.objects.using("default").filter(
            qdate__range=(
                datetime.strptime(qdate, "%Y-%m-%d") + timedelta(days=-(section - 1)),
                datetime.strptime(qdate, "%Y-%m-%d")
            )
        ).all().order_by("qdate")
        monthly_base_dict["qdate_list"] = []  # 月度数据人数详情日期列表
        monthly_base_dict["zhu_r_list"] = []  # 月度数据注册人数列表
        monthly_base_dict["sm_r_list"] = []  # 月度数据实名人数列表
        monthly_base_dict["sc_r_list"] = []  # 月度数据首充人数列表
        monthly_base_dict["xz_tz_r_list"] = []  # 月度数据新增投资人数列表
        for obj in base_info:
            monthly_base_dict["qdate_list"].append(datetime.strftime(obj.qdate, "%m-%d"))
            monthly_base_dict["zhu_r_list"].append(obj.zhu_r)
            monthly_base_dict["sm_r_list"].append(obj.sm_r)
            monthly_base_dict["sc_r_list"].append(obj.sc_r)
            monthly_base_dict["xz_tz_r_list"].append(obj.xztz_r)
        return alert_message, monthly_base_dict

    if request.method == "GET":
        today = datetime.strftime(datetime.now() + timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        alert_message, monthly_base_dict = monthly_get_info(today)
        return render(request, "monthly.html", {
            "qdate": today,
            "alert_message": alert_message,
            "monthly_base_dict": monthly_base_dict
        })
    elif request.method == "POST":
        qdate = request.POST.get("qdate")  # 获取用户输入的日期
        return render(request, "monthly.html")
