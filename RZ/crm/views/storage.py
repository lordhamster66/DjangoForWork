#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/14
"""
用户存储数据至数据库
"""
import os
import random
import re  # 正则模块
from RZ import settings
from django.views import View
from django.shortcuts import HttpResponse
from django.db import connections, transaction
from django.utils.timezone import datetime, now, timedelta
from crm import utils  # 常用功能及一些工具或一些常用变量
from crm import models
import datetime
import requests  # 爬虫专用
from utils import db_connect
from django.views.decorators.cache import cache_page


class DataStorage(View):
    """用于取出公司数据库信息导入本地数据库"""

    def dispatch(self, request, *args, **kwargs):
        result = super(DataStorage, self).dispatch(request, *args, **kwargs)
        return result

    def get_info_list(self, catalog, file_name):
        """
        执行sql语句并以列表的形式返回单行结果
        :param catalog: sql语句目录名
        :param file_name: sql文件名
        :return: 返回查询结果(列表形式)
        """
        file_path = os.path.join(settings.BASE_DIR, "crm", "RzSql", catalog, file_name)
        f = open(file_path, "r", encoding="utf-8")
        sql = f.read()
        f.close()
        cursor = connections['rz'].cursor()
        cursor.execute(sql.format(qdate=datetime.datetime.strftime(now() - timedelta(days=1), "%Y-%m-%d")))
        data = cursor.fetchall()
        col_names = [i[0] for i in cursor.description]
        if not data:  # 如果获取不到数据，则全部置为空
            data = [["" for i in col_names]]
        info_list = [dict(zip(col_names, row)) for row in data]
        return info_list

    def daily_storage(self):
        """
        日报数据存储
        :return: 无返回值
        """
        ignore_sql_file = [
            "rzjf_asset_info.sql", "rzjf_g_asset_info.sql", "rzjf_r_asset_info.sql",
            "rzjf_s_asset_info.sql", "rzjf_x_asset_info.sql"
        ]
        daily_sql_path = os.path.join(settings.BASE_DIR, "crm", "RzSql", "daily")
        qdate = datetime.datetime.strftime(now() - timedelta(days=1), "%Y-%m-%d")  # 获取昨天日期

        def set_sql_file_name_attr(self, sql_file):
            """
            用来将一些查询的数据存储至DataStorage对象中
            :param self: DataStorage对象
            :param sql_file: sql文件名
            :return:
            """
            try:
                ret = self.get_info_list("daily", sql_file)
                setattr(self, sql_file.replace(".sql", ""), ret)
            except Exception as e:
                settings.action_logger.warning("%s信息查询出错!出错信息如下\n%s" % (sql_file.replace(".sql", ""), e))
            settings.action_logger.info("%s信息查询完毕!" % (sql_file.replace(".sql", ""),))

        for sql_file in os.listdir(daily_sql_path):
            if sql_file in ignore_sql_file:
                continue
            set_sql_file_name_attr(self, sql_file)
        with transaction.atomic():
            # 增加基础数据信息
            models.BaseInfo.objects.using("default").create(
                qdate=qdate,  # 日期
                zhu_r=getattr(self, "zhu_info")[0].get("zhu_r") or None,  # 注册人数
                sm_r=getattr(self, "sm_info")[0].get("sm_r") or None,  # 实名人数
                sc_r=getattr(self, "sc_info")[0].get("sc_r") or None,  # 首充人数
                xztz_r=getattr(self, "xztz_info")[0].get("xztz_r") or None,  # 新增投资人数
                xztz_j=getattr(self, "xztz_info")[0].get("xztz_j") or None,  # 新增投资金额
                cz_r=getattr(self, "cz_info")[0].get("cz_r") or None,  # 充值人数
                cz_j=getattr(self, "cz_info")[0].get("cz_j") or None,  # 充值金额
                tx_r=getattr(self, "tx_info")[0].get("tx_r") or None,  # 提现人数
                tx_j=getattr(self, "tx_info")[0].get("tx_j") or None,  # 提现金额
                tz_r=getattr(self, "tz_info")[0].get("tz_r") or None,  # 投资人数
                tz_j=getattr(self, "tz_info")[0].get("tz_j") or None,  # 投资金额
                tz_b=getattr(self, "tz_info")[0].get("tz_b") or None,  # 投资笔数
                tz_dl_r=getattr(self, "tz_dl_info")[0].get("tz_dl_r") or None,  # 投资登录人数
                hk_r=getattr(self, "hk_info")[0].get("hk_r") or None,  # 回款人数
                hk_j=getattr(self, "hk_info")[0].get("hk_j") or None,  # 回款金额
                zg_j=getattr(self, "balance_info")[0].get("zg_j") or None,  # 站岗金额
                zg_r=getattr(self, "balance_info")[0].get("zg_r") or None,  # 站岗人数
                zd_r=getattr(self, "zaidai_info")[0].get("zd_r") or None,  # 在贷人数
                zd_j=getattr(self, "zaidai_info")[0].get("zd_j") or None,  # 在贷金额
                xt_j=getattr(self, "xt_info")[0].get("xt_j") or None,  # 续投金额
                cz_tz=getattr(self, "cz_tz_info")[0].get("cz_tz") or None,  # 充值并投资金额
            )
            settings.action_logger.info("%s基础数据信息增加完毕!" % qdate)
            # 增加昨日推广数据信息
            models.TgInfo.objects.using("default").create(
                qdate=qdate,  # 日期
                tg_zhu_r=getattr(self, "tg_info")[0].get("tg_zhu_r") or None,  # 推广注册人数
                tg_sm_r=getattr(self, "tg_info")[0].get("tg_sm_r") or None,  # 推广实名人数
                tg_sc_r=getattr(self, "tg_info")[0].get("tg_sc_r") or None,  # 推广首充人数
                tg_xztz_r=getattr(self, "tg_info")[0].get("tg_xztz_r") or None,  # 推广新增人数
                tg_xztz_j=getattr(self, "tg_info")[0].get("tg_xztz_j") or None  # 推广新增金额
            )
            settings.action_logger.info("%s推广数据信息增加完毕!" % qdate)
            # 增加运营数据信息
            models.OperateInfo.objects.using("default").create(
                qdate=qdate,  # 日期
                xz_cz=getattr(self, "xz_cz_info")[0].get("xz_cz") or None,  # 新增充值
                hk_cz=getattr(self, "hk_cz_info")[0].get("hk_cz") or None,  # 回款并充值
                unhk_cz=getattr(self, "unhk_cz_info")[0].get("unhk_cz") or None,  # 非回款充值
                zj_ft_lv=getattr(self, "zj_ft_lv_info")[0].get("zj_ft_lv") or None,  # 资金复投率
                rs_ft_lv=getattr(self, "rs_ft_lv_info")[0].get("rs_ft_lv") or None  # 人数复投率
            )
            settings.action_logger.info("%s运营数据信息增加完毕!" % qdate)
            # 增加邀请数据信息
            models.InviteInfo.objects.using("default").create(
                qdate=qdate,  # 日期
                invite_r=getattr(self, "invite_info")[0].get("invite_r") or None,  # 邀请人数
                invited_r=getattr(self, "invite_info")[0].get("invited_r") or None,  # 被邀请人数
                invited_st_r=getattr(self, "invite_info")[0].get("invited_st_r") or None,  # 被邀请首投人数
                invited_st_j=getattr(self, "invite_info")[0].get("invited_st_j") or None,  # 被邀请首投金额
                cash_f=getattr(self, "invite_info")[0].get("cash_f") or None,  # 现金发放金额
                # cash_l=invite_info.get("cash_l"),  # 现金领取金额
                # hb_f=invite_info.get("hb_f"),  # 红包发放金额
                # hb_s=invite_info.get("hb_s")  # 红包使用金额
            )
            settings.action_logger.info("%s邀请数据信息增加完毕!" % qdate)
            # 增加资产数据详情
            asset_info_obj_list = []
            for row in getattr(self, "qixian_info"):
                asset_info_obj_list.append(models.AssetInfo(
                    qdate=qdate,  # 日期
                    asset_type="所有",  # 资产类型
                    term=row.get("term") or None,  # 期限类型
                    tz_r=row.get("tz_r") or None,  # 投资人数
                    tz_j=row.get("tz_j") or None,  # 投资金额
                    mb_ys=row.get("mb_ys") or None  # 满标用时
                ))
            for row in getattr(self, "s_qixian_info"):
                asset_info_obj_list.append(models.AssetInfo(
                    qdate=qdate,  # 日期
                    asset_type="散标",  # 资产类型
                    term=row.get("term") or None,  # 期限类型
                    tz_r=row.get("tz_r") or None,  # 投资人数
                    tz_j=row.get("tz_j") or None,  # 投资金额
                    mb_ys=row.get("mb_ys") or None  # 满标用时
                ))
            for row in getattr(self, "r_qixian_info"):
                asset_info_obj_list.append(models.AssetInfo(
                    qdate=qdate,  # 日期
                    asset_type="R计划",  # 资产类型
                    term=row.get("term") or None,  # 期限类型
                    tz_r=row.get("tz_r") or None,  # 投资人数
                    tz_j=row.get("tz_j") or None,  # 投资金额
                    mb_ys=row.get("mb_ys") or None  # 满标用时
                ))
            models.AssetInfo.objects.using("default").bulk_create(asset_info_obj_list)
            settings.action_logger.info("%s资产数据详情增加完毕!" % qdate)
            # 增加各端数据详情
            geduan_rw = getattr(self, "geduan_rw")  # 获取各端回款并提现数据
            geduan_rw_dic = {}  # 定义一个各端回款并提现字典
            for i in geduan_rw:
                geduan_rw_dic[i.get("geduan")] = {"recover": i.get("recover"),
                                                  "recover_withdraw": i.get("recover_withdraw")}
            geduan_account = getattr(self, "geduan_account")  # 获取各端投资数据
            geduan_account_dic = {}
            for i in geduan_account:
                geduan_account_dic[i.get("geduan")] = {"account": i.get("account")}
            geduan_xztz = getattr(self, "geduan_xztz")  # 获取各端新增投资数据
            geduan_xztz_dic = {}
            for i in geduan_xztz:
                geduan_xztz_dic[i.get("geduan")] = {"xztz_j": i.get("xztz_j")}
            geduan_withdraw = getattr(self, "geduan_withdraw")  # 获取各端提现数据
            geduan_withdraw_dic = {}
            for i in geduan_withdraw:
                geduan_withdraw_dic[i.get("geduan")] = {"withdraw": i.get("withdraw")}
            geduan_list = ["APP", "PC", "WAP"]  # 各端列表
            geduan_info_obj_list = []
            for gd in geduan_list:
                geduan_info_obj_list.append(models.GeDuanInfo(
                    qdate=qdate,
                    geduan=gd,
                    recover=geduan_rw_dic.get(gd, {"recover": 0}).get("recover") or None,
                    recover_withdraw=geduan_rw_dic.get(gd, {"recover_withdraw": 0}).get("recover_withdraw") or None,
                    account=geduan_account_dic.get(gd, {"account": 0}).get("account") or None,
                    xztz_j=geduan_xztz_dic.get(gd, {"xztz_j": 0}).get("xztz_j") or None,
                    withdraw=geduan_withdraw_dic.get(gd, {"withdraw": 0}).get("withdraw") or None
                ))
            models.GeDuanInfo.objects.using("default").bulk_create(geduan_info_obj_list)
            settings.action_logger.info("%s各端数据详情增加完毕!" % qdate)

            # 增加时间段数据详情
            time_slot_obj_list = []
            for row in getattr(self, "timeslot_info"):
                time_slot_obj_list.append(models.TimeSlot(
                    qdate=qdate,  # 日期
                    timeslot=row.get("timeslot") or None,  # 时间段
                    tz_r=row.get("tz_r") or None  # 投资人数
                ))
            models.TimeSlot.objects.using("default").bulk_create(time_slot_obj_list)
            settings.action_logger.info("%s时间段数据详情增加完毕!" % qdate)
            # 增加其他数据详情
            models.OtherInfo.objects.using("default").create(
                qdate=qdate,
                short_tz_r=getattr(self, "short_tz_info")[0].get("short_tz_r") or None,
                short_tz_j=getattr(self, "short_tz_info")[0].get("short_tz_j") or None,
                short_zd_j=getattr(self, "short_zd_info")[0].get("short_zd_j") or None,
                Rplan_account=getattr(self, "Rplan_tz_info")[0].get("Rplan_account") or None,
                Rplan_recover_account=getattr(self, "Rplan_zd_info")[0].get("Rplan_recover_account") or None,
                g_tz_j=getattr(self, "g_tz_info")[0].get("g_tz_j") or None,
                x_tz_j=getattr(self, "x_tz_info")[0].get("x_tz_j") or None,
                Rplan_xt=getattr(self, "Rplan_xt_info")[0].get("Rplan_xt") or None,
                unRplan_xt_hk_j=getattr(self, "unRplan_xt_hk_info")[0].get("unRplan_xt_hk_j") or None,
            )
            settings.action_logger.info("%s其他数据详情增加完毕!" % qdate)

            # 增加每日每人在贷详情
            user_recover_info = getattr(self, "user_recover")  # 获取每人在贷详情
            cursor = connections['default'].cursor()  # 创建数据库游标
            for row in user_recover_info:
                sql = """INSERT INTO `rzjf_user_recover` (`qdate`, `uid`, `recover_account`)
                VALUES ('%s', '%s', '%s');""" % (qdate, row.get("uid"), row.get("recover_account"))
                cursor.execute(sql)  # 执行SQL
            cursor.close()  # 关闭游标
            settings.action_logger.info("%s每日每人在贷详情增加完毕!" % qdate)

            # 增加EXCEL日报资产数据详情
            daily_asset_info_obj_list = []
            for row in getattr(self, "daily_qixian_info"):
                daily_asset_info_obj_list.append(models.DailyAssetInfo(
                    qdate=qdate,  # 日期
                    asset_type="所有",  # 资产类型
                    term=row.get("term") or None,  # 期限类型
                    tz_r=row.get("tz_r") or None,  # 投资人数
                    tz_j=row.get("tz_j") or None,  # 投资金额
                    mb_ys=row.get("mb_ys") or None  # 满标用时
                ))
            for row in getattr(self, "daily_s_qixian_info"):
                daily_asset_info_obj_list.append(models.DailyAssetInfo(
                    qdate=qdate,  # 日期
                    asset_type="散标",  # 资产类型
                    term=row.get("term") or None,  # 期限类型
                    tz_r=row.get("tz_r") or None,  # 投资人数
                    tz_j=row.get("tz_j") or None,  # 投资金额
                ))
            for row in getattr(self, "daily_r_qixian_info"):
                daily_asset_info_obj_list.append(models.DailyAssetInfo(
                    qdate=qdate,  # 日期
                    asset_type="R计划",  # 资产类型
                    term=row.get("term") or None,  # 期限类型
                    tz_r=row.get("tz_r") or None,  # 投资人数
                    tz_j=row.get("tz_j") or None,  # 投资金额
                ))
            models.DailyAssetInfo.objects.using("default").bulk_create(daily_asset_info_obj_list)
            settings.action_logger.info("%sEXCEL日报资产数据详情增加完毕!" % qdate)

            # 增加EXCEL日报提现分类数据详情
            daily_withdraw_classify_obj_list = []
            for row in getattr(self, "daily_withdraw_section"):
                daily_withdraw_classify_obj_list.append(models.DailyWithdrawClassify(
                    qdate=qdate,  # 日期
                    withdraw_type="提现区间",  # 提现类型
                    term=row.get("term") or None,  # 提现分类
                    tx_r=row.get("tx_r") or None,  # 提现人数
                    tx_j=row.get("tx_j") or None,  # 提现金额
                ))
            # 获取累计提现投资时间间隔数据
            for row in getattr(self, "daily_withdraw_investment_interval"):
                daily_withdraw_classify_obj_list.append(models.DailyWithdrawClassify(
                    qdate=qdate,  # 日期
                    withdraw_type="投资时间间隔",  # 提现类型
                    term=row.get("term") or None,  # 提现分类
                    tx_r=row.get("tx_r") or None,  # 提现人数
                    tx_j=row.get("tx_j") or None,  # 提现金额
                ))
            # 获取累计提现投资次数数据
            for row in getattr(self, "daily_withdraw_investment_times"):
                daily_withdraw_classify_obj_list.append(models.DailyWithdrawClassify(
                    qdate=qdate,  # 日期
                    withdraw_type="投资次数",  # 提现类型
                    term=row.get("term") or None,  # 提现分类
                    tx_r=row.get("tx_r") or None,  # 提现人数
                    tx_j=row.get("tx_j") or None,  # 提现金额
                ))
            models.DailyWithdrawClassify.objects.using("default").bulk_create(daily_withdraw_classify_obj_list)
            settings.action_logger.info("%sEXCEL日报提现分类数据详情增加完毕!" % qdate)

            # 增加EXCEL日报待收分类数据详情
            daily_collect_classify_obj_list = []
            for row in getattr(self, "daily_collect_section"):
                daily_collect_classify_obj_list.append(models.DailyCollectClassify(
                    qdate=qdate,  # 日期
                    collect_type="待收区间",  # 待收类型
                    term=row.get("term") or None,  # 待收分类
                    collect_r=row.get("collect_r") or None,  # 待收人数
                    collect_j=row.get("collect_j") or None,  # 待收金额
                ))
            # 获取待收投资时间间隔数据
            for row in getattr(self, "daily_collect_investment_interval"):
                daily_collect_classify_obj_list.append(models.DailyCollectClassify(
                    qdate=qdate,  # 日期
                    collect_type="待收投资时间间隔",  # 待收类型
                    term=row.get("term") or None,  # 待收分类
                    collect_r=row.get("collect_r") or None,  # 待收人数
                    collect_j=row.get("collect_j") or None,  # 待收金额
                ))
            # 获取待收投资次数数据
            for row in getattr(self, "daily_collect_investment_times"):
                daily_collect_classify_obj_list.append(models.DailyCollectClassify(
                    qdate=qdate,  # 日期
                    collect_type="待收投资次数",  # 待收类型
                    term=row.get("term") or None,  # 待收分类
                    collect_r=row.get("collect_r") or None,  # 待收人数
                    collect_j=row.get("collect_j") or None,  # 待收金额
                ))
            models.DailyCollectClassify.objects.using("default").bulk_create(daily_collect_classify_obj_list)
            settings.action_logger.info("%sEXCEL日报待收分类数据详情增加完毕!" % qdate)

            # 增加日报专属客服复投数据
            re_casting_obj_list = []
            # 获取专属客服复投数据
            for row in getattr(self, "re_casting_info"):
                re_casting_obj_list.append(models.ReCasting(
                    qdate=qdate,  # 日期
                    kefuname=row.get("kefuname") or None,  # 客服姓名
                    ft_r=row.get("ft_r") or None,  # 首投后复投人数
                    st_r=row.get("st_r") or None,  # 首投人数
                    ft_lv=row.get("ft_lv") or None,  # 复投率
                    ft_j=row.get("ft_j") or None,  # 复投金额
                    day_t_j=row.get("day_t_j") or None,  # 当日投资金额
                    month_t_j=row.get("month_t_j") or None,  # 当月投资金额
                ))
            models.ReCasting.objects.using("default").bulk_create(re_casting_obj_list)
            settings.action_logger.info("%sEXCEL日报专属客服复投数据详情增加完毕!" % qdate)

            # 增加日报VIP客服流失数据
            loss_rate_obj_list = []
            # 获取VIP客服流失数据
            for row in getattr(self, "daily_loss_rate_info"):
                loss_rate_obj_list.append(models.LossRate(
                    qdate=qdate,  # 日期
                    kefuname=row.get("kefuname") or None,  # 客服姓名
                    loss_num=row.get("loss_num") or None,  # 流失用户
                    exist_num=row.get("exist_num") or None,  # 在投用户
                    day_invest=row.get("day_invest") or None,  # 当日投资金额
                    month_withdraw=row.get("month_withdraw") or None,  # 当月提现金额
                    month_invest=row.get("month_invest") or None,  # 当月投资金额
                    recall_num=row.get("recall_num") or None,  # 当月召回人数
                ))
            models.LossRate.objects.using("default").bulk_create(loss_rate_obj_list)
            settings.action_logger.info("%sEXCEL日报VIP客服流失数据详情增加完毕!" % qdate)

            settings.action_logger.info("%s日报所需数据已经更新!" % (qdate,))

    def get(self, request, *args, **kwargs):
        """
        通过get请求可以将公司数据库的信息存入BI专用数据库
        :param request:
        :param args:
        :param kwargs:
        :return:
        """
        self.daily_storage()  # 存储日报所需数据
        return HttpResponse("ok!")

    def post(self, request, *args, **kwargs):
        pass


def get_wdzj_info(request):
    """获取网贷之家数据信息并存入数据库"""
    if request.method == "GET":
        headers = {"User-Agent": random.choice(utils.user_agent)}
        # 访问网贷之家数据接口，获取昨天各平台数据信息
        response = requests.post("http://shuju.wdzj.com/plat-data-custom.html", headers=headers)
        data = response.json()  # 用json解析数据
        qdate = datetime.datetime.strftime(datetime.datetime.now() + datetime.timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        # 循环在数据库创建每个平台信息
        for msg_dic in data:
            models.WDZJ_Info.objects.using("default").create(
                qdate=qdate,  # 日期
                platName=msg_dic.get("platName"),  # 平台名称
                amount=msg_dic.get("amount"),  # 成交量(万元)
                incomeRate=msg_dic.get("incomeRate"),  # 平均预期收益率(%)
                loanPeriod=msg_dic.get("loanPeriod"),  # 平均借款期限(月)
                regCapital=msg_dic.get("regCapital"),  # 注册资本(万元)
                fullloanTime=msg_dic.get("fullloanTime"),  # 满标用时(分)
                stayStillOfTotal=msg_dic.get("stayStillOfTotal"),  # 待还余额(万元)
                netInflowOfThirty=msg_dic.get("netInflowOfThirty"),  # 资金净流入(万元)
                timeOperation=msg_dic.get("timeOperation"),  # 运营时间(月)
                bidderNum=msg_dic.get("bidderNum"),  # 投资人数(人)
                borrowerNum=msg_dic.get("borrowerNum"),  # 借款人数(人)
                totalLoanNum=msg_dic.get("totalLoanNum"),  # 借款标数(个)
                top10DueInProportion=msg_dic.get("top10DueInProportion"),  # 前十大土豪待收金额占比(%)
                avgBidMoney=msg_dic.get("avgBidMoney"),  # 人均投资金额(万元)
                top10StayStillProportion=msg_dic.get("top10StayStillProportion"),  # 前十大借款人待还金额占比(%)
                avgBorrowMoney=msg_dic.get("avgBorrowMoney"),  # 人均借款金额(万元)
                developZhishu=msg_dic.get("developZhishu")  # 发展指数排名
            )
        settings.action_logger.info("%s网贷之家数据已经更新!" % (qdate,))
        return HttpResponse("网贷之家数据填入完毕!")


def get_wdty_info(request):
    """获取网贷天眼数据信息并存入数据库"""
    if request.method == "GET":
        headers = {"User-Agent": random.choice(utils.user_agent)}
        response = requests.get("http://www.p2peye.com/shuju/ptsj/", headers=headers)
        ret = response.content.decode("GBK")
        tbody = re.findall('<tbody[\s\S]*</tbody>', ret, re.S)  # 获取tbody内容
        name = re.findall('>(.{2,10})<\/a', tbody[0], re.S)  # 获取平台名称
        name = [i for i in name if i != "添加关注"]
        total = re.findall('<td class="total">(\d*.\d*)万</td>', tbody[0], re.S)  # 获取平台成交额(万)
        rate = re.findall('<td class="rate">(\d*.\d*)%</td>', tbody[0], re.S)  # 获取平台综合利率(%)
        pnum = re.findall('<td class="pnum">(\d*)人</td>', tbody[0], re.S)  # 获取平台投资人数(人)
        cycle = re.findall('<td class="cycle">(\d*.\d*)月</td>', tbody[0], re.S)  # 获取平台借款周期(月)
        p1num = re.findall('<td class="p1num">(\d*)人</td>', tbody[0], re.S)  # 获取平台借款人(人)
        fuload = re.findall('<td class="fuload">(\d*.\d*)分钟</td>', tbody[0], re.S)  # 获取平台满标速度(分钟)
        alltotal = re.findall('<td class="alltotal">(-?\d*.\d*)万</td>', tbody[0], re.S)  # 获取平台累计贷款余额(万)
        capital = re.findall('<td class="capital">(-?\d*.\d*)万</td>', tbody[0], re.S)  # 获取平台资金净流入(万)
        data_list = []  # 存放500万及以上平台数据信息包括人众金服
        for index, temp_name in enumerate(name):
            if float(total[index]) >= 500 or temp_name == "人众金服":
                # 存放每一个平台的信息
                temp_dict = {}
                temp_dict["name"] = temp_name  # 平台名称
                temp_dict["total"] = float(total[index])  # 平台成交额(万)
                temp_dict["rate"] = float(rate[index])  # 平台综合利率(%)
                temp_dict["pnum"] = int(pnum[index])  # 平台投资人数(人)
                temp_dict["cycle"] = float(cycle[index])  # 平台借款周期(月)
                temp_dict["p1num"] = int(p1num[index])  # 平台借款人(人)
                temp_dict["fuload"] = float(fuload[index])  # 平台满标速度(分钟)
                temp_dict["alltotal"] = float(alltotal[index])  # 平台累计贷款余额(万)
                temp_dict["capital"] = float(capital[index])  # 平台资金净流入(万)
                data_list.append(temp_dict)
        # 循环存入每个平台的信息
        qdate = datetime.datetime.strftime(datetime.datetime.now() + datetime.timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        for msg_dict in data_list:
            models.WDTY_Info.objects.using("default").create(
                qdate=qdate,  # 日期
                name=msg_dict.get("name"),  # 平台名称
                total=msg_dict.get("total"),  # 平台成交额(万)
                rate=msg_dict.get("rate"),  # 平台综合利率(%)
                pnum=msg_dict.get("pnum"),  # 平台投资人数(人)
                cycle=msg_dict.get("cycle"),  # 平台借款周期(月)
                p1num=msg_dict.get("p1num"),  # 平台借款人(人)
                fuload=msg_dict.get("fuload"),  # 平台满标速度(分钟)
                alltotal=msg_dict.get("alltotal"),  # 平台累计贷款余额(万)
                capital=msg_dict.get("capital")  # 平台资金净流入(万)
            )
        settings.action_logger.info("%s网贷天眼数据已经更新!" % (qdate,))
        return HttpResponse("网贷天眼数据填入完毕!")


@cache_page(10 * 60)
def rzjf_recorde(request):
    """用于定时存储人众金服业务所产生的一些记录"""
    # 获取更新用SQL
    rzjf_first_invest_recorde_sql = db_connect.get_sql("crm", "RzSql", "storage", "rzjf_first_invest_recorde.sql")
    rzjf_user_memo_sql = db_connect.get_sql("crm", "RzSql", "storage", "rzjf_user_memo.sql")
    # 连接数据库并执行SQL
    cursor = connections['rz_bi'].cursor()
    rzjf_first_invest_recorde_sql_list = db_connect.get_info_list("rz_bi", rzjf_first_invest_recorde_sql)
    rzjf_user_memo_list = db_connect.get_info_list("rz_bi", rzjf_user_memo_sql)
    with transaction.atomic():
        # 插入首投记录
        for info in rzjf_first_invest_recorde_sql_list:
            cursor.execute(
                """INSERT INTO `rzjf_bi`.`rzjf_first_invest_recorde` 
                (`uid`,`first_time`,`first_account`,`bid`,`name`,`time_limit`,`apr`,`db`) 
                VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');""" % (
                    info.get("uid"), info.get("first_time"), info.get("first_account"),
                    info.get("bid"), info.get("name"), info.get("time_limit"),
                    info.get("apr"), info.get("db")
                )
            )

        # 插入用户注册标识
        for info in rzjf_user_memo_list:
            cursor.execute(
                "INSERT INTO `rzjf_bi`.`rzjf_user_memo` (`uid`, `memo`) VALUES ('%s', '%s');" % (
                    info.get("uid"), info.get("memo")
                )
            )
    return HttpResponse("ok!")


def rzjf_invest_rank(request):
    """存储投资次数，用于获取第几次投资"""
    # 获取昨天的所有投资用户uid对应sql
    yesterday_invest_uid_sql = db_connect.get_sql("crm", "RzSql", "storage", "yesterday_invest_uid.sql")
    # 获取存储投资次数的sql
    rzjf_invest_rank_sql = db_connect.get_sql("crm", "RzSql", "storage", "rzjf_invest_rank.sql")
    # 获取昨天的所有投资用户uid
    yesterday_invest_uid = db_connect.get_info_list("rz", yesterday_invest_uid_sql)
    yesterday_invest_uid_list = []
    if yesterday_invest_uid:
        for item in yesterday_invest_uid:
            yesterday_invest_uid_list.append(str(item.get("uid")))
    with transaction.atomic():
        # 更新存储投资次数的sql
        rzjf_invest_rank_sql = rzjf_invest_rank_sql.format(uid=",".join(yesterday_invest_uid_list))
        cursor = connections['rz_bi'].cursor()
        cursor.execute(rzjf_invest_rank_sql)  # 执行存储投资次数的sql语句
    return HttpResponse("ok!")
