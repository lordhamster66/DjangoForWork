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
from django.db import connections
from crm import utils  # 常用功能及一些工具或一些常用变量
from crm import models
import datetime
import requests  # 爬虫专用
from utils import db_connect


class DataStorage(View):
    """用于取出公司数据库信息导入本地数据库"""

    def dispatch(self, request, *args, **kwargs):
        result = super(DataStorage, self).dispatch(request, *args, **kwargs)
        return result

    def get_info_dict(self, catalog, file_name):
        """
        执行sql语句并以字典的形式返回单行结果
        :param catalog: sql语句目录名
        :param file_name: sql文件名
        :return: 返回查询结果(字典形式)
        """
        file_path = os.path.join(settings.BASE_DIR, "crm", "RzSql", catalog, file_name)
        f = open(file_path, "r", encoding="utf-8")
        sql = f.read()
        f.close()
        cursor = connections['rz'].cursor()
        cursor.execute(sql)
        row = cursor.fetchone()
        col_names = [desc[0] for desc in cursor.description]
        info_dict = dict(zip(col_names, row))
        return info_dict

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
        cursor.execute(sql)
        data = cursor.fetchall()
        col_names = [i[0] for i in cursor.description]
        info_list = [dict(zip(col_names, row)) for row in data]
        return info_list

    def daily_storage(self):
        """
        日报数据存储
        :return: 无返回值
        """
        qdate = datetime.datetime.strftime(datetime.datetime.now() + datetime.timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        zhu_info = self.get_info_dict("daily", "zhu_info.sql")  # 注册信息
        sm_info = self.get_info_dict("daily", "sm_info.sql")  # 实名信息
        sc_info = self.get_info_dict("daily", "sc_info.sql")  # 首充信息
        xztz_info = self.get_info_dict("daily", "xztz_info.sql")  # 新增投资信息
        cz_info = self.get_info_dict("daily", "cz_info.sql")  # 充值信息
        tx_info = self.get_info_dict("daily", "tx_info.sql")  # 提现信息
        tz_info = self.get_info_dict("daily", "tz_info.sql")  # 投资信息
        hk_info = self.get_info_dict("daily", "hk_info.sql")  # 回款信息
        tz_dl_info = self.get_info_dict("daily", "tz_dl_info.sql")  # 投资登录人数信息
        balance_info = self.get_info_dict("daily", "zhangang.sql")  # 站岗信息
        zaidai_info = self.get_info_dict("daily", "zaidai.sql")  # 在贷信息
        # 增加基础数据信息
        models.BaseInfo.objects.using("default").create(
            qdate=qdate,  # 日期
            zhu_r=zhu_info.get("zhu_r"),  # 注册人数
            sm_r=sm_info.get("sm_r"),  # 实名人数
            sc_r=sc_info.get("sc_r"),  # 首充人数
            xztz_r=xztz_info.get("xztz_r"),  # 新增投资人数
            xztz_j=xztz_info.get("xztz_j"),  # 新增投资金额
            cz_r=cz_info.get("cz_r"),  # 充值人数
            cz_j=cz_info.get("cz_j"),  # 充值金额
            tx_r=tx_info.get("tx_r"),  # 提现人数
            tx_j=tx_info.get("tx_j"),  # 提现金额
            tz_r=tz_info.get("tz_r"),  # 投资人数
            tz_j=tz_info.get("tz_j"),  # 投资金额
            tz_b=tz_info.get("tz_b"),  # 投资笔数
            tz_dl_r=tz_dl_info.get("tz_dl_r"),  # 投资登录人数
            hk_r=hk_info.get("hk_r"),  # 回款人数
            hk_j=hk_info.get("hk_j"),  # 回款金额
            zg_j=balance_info.get("zg_j"),  # 站岗金额
            zg_r=balance_info.get("zg_r"),  # 站岗人数
            zd_r=zaidai_info.get("zd_r"),  # 在贷人数
            zd_j=zaidai_info.get("zd_j"),  # 在贷金额
        )
        tg_info = self.get_info_dict("daily", "tg.sql")  # 获取昨日推广数据
        # 增加昨日推广数据信息
        models.TgInfo.objects.using("default").create(
            qdate=tg_info.get("qdate"),  # 日期
            tg_zhu_r=tg_info.get("tg_zhu_r"),  # 推广注册人数
            tg_sm_r=tg_info.get("tg_sm_r"),  # 推广实名人数
            tg_sc_r=tg_info.get("tg_sc_r"),  # 推广首充人数
            tg_xztz_r=tg_info.get("tg_xztz_r"),  # 推广新增人数
            tg_xztz_j=tg_info.get("tg_xztz_j")  # 推广新增金额
        )
        xz_cz_info = self.get_info_dict("daily", "xz_cz.sql")  # 获取新增充值数据
        hk_cz_info = self.get_info_dict("daily", "hk_cz.sql")  # 获取回款并充值数据
        unhk_cz_info = self.get_info_dict("daily", "unhk_cz.sql")  # 获取非回款充值数据
        zj_ft_lv_info = self.get_info_dict("daily", "zj_ft_lv.sql")  # 获取资金复投率数据
        rs_ft_lv_info = self.get_info_dict("daily", "rs_ft_lv.sql")  # 获取人数复投率数据
        # 增加运营数据信息
        models.OperateInfo.objects.using("default").create(
            qdate=xz_cz_info.get("qdate"),  # 日期
            xz_cz=xz_cz_info.get("xz_cz"),  # 新增充值
            hk_cz=hk_cz_info.get("hk_cz"),  # 回款并充值
            unhk_cz=unhk_cz_info.get("unhk_cz"),  # 非回款充值
            zj_ft_lv=zj_ft_lv_info.get("zj_ft_lv"),  # 资金复投率
            rs_ft_lv=rs_ft_lv_info.get("rs_ft_lv")  # 人数复投率
        )
        invite_info = self.get_info_dict("daily", "invite_info.sql")  # 获取邀请数据
        # 增加邀请数据信息
        models.InviteInfo.objects.using("default").create(
            qdate=qdate,  # 日期
            invite_r=invite_info.get("invite_r"),  # 邀请人数
            invited_r=invite_info.get("invited_r"),  # 被邀请人数
            invited_st_r=invite_info.get("invited_st_r"),  # 被邀请首投人数
            invited_st_j=invite_info.get("invited_st_j"),  # 被邀请首投金额
            cash_f=invite_info.get("cash_f"),  # 现金发放金额
            # cash_l=invite_info.get("cash_l"),  # 现金领取金额
            # hb_f=invite_info.get("hb_f"),  # 红包发放金额
            # hb_s=invite_info.get("hb_s")  # 红包使用金额
        )
        # 增加资产数据详情
        qixian_info = self.get_info_list("daily", "qixian_info.sql")  # 获取所有资产期限数据
        for row in qixian_info:
            models.AssetInfo.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                asset_type="所有",  # 资产类型
                term=row.get("term"),  # 期限类型
                tz_r=row.get("tz_r"),  # 投资人数
                tz_j=row.get("tz_j"),  # 投资金额
                mb_ys=row.get("mb_ys")  # 满标用时
            )
        s_qixian_info = self.get_info_list("daily", "s_qixian_info.sql")  # 获取散标资产期限数据
        for row in s_qixian_info:
            models.AssetInfo.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                asset_type="散标",  # 资产类型
                term=row.get("term"),  # 期限类型
                tz_r=row.get("tz_r"),  # 投资人数
                tz_j=row.get("tz_j"),  # 投资金额
                mb_ys=row.get("mb_ys")  # 满标用时
            )
        r_qixian_info = self.get_info_list("daily", "r_qixian_info.sql")  # 获取R计划资产期限数据
        for row in r_qixian_info:
            models.AssetInfo.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                asset_type="R计划",  # 资产类型
                term=row.get("term"),  # 期限类型
                tz_r=row.get("tz_r"),  # 投资人数
                tz_j=row.get("tz_j"),  # 投资金额
                mb_ys=row.get("mb_ys")  # 满标用时
            )
        # 增加各端数据详情
        geduan_rw = self.get_info_list("daily", "geduan_rw.sql")  # 获取各端回款并提现数据
        geduan_rw_dic = {}  # 定义一个各端回款并提现字典
        for i in geduan_rw:
            geduan_rw_dic[i.get("geduan")] = {"recover": i.get("recover"),
                                              "recover_withdraw": i.get("recover_withdraw")}
        geduan_account = self.get_info_list("daily", "geduan_account.sql")  # 获取各端投资数据
        geduan_account_dic = {}
        for i in geduan_account:
            geduan_account_dic[i.get("geduan")] = {"account": i.get("account")}
        geduan_xztz = self.get_info_list("daily", "geduan_xztz.sql")  # 获取各端新增投资数据
        geduan_xztz_dic = {}
        for i in geduan_xztz:
            geduan_xztz_dic[i.get("geduan")] = {"xztz_j": i.get("xztz_j")}
        geduan_withdraw = self.get_info_list("daily", "geduan_withdraw.sql")  # 获取各端提现数据
        geduan_withdraw_dic = {}
        for i in geduan_withdraw:
            geduan_withdraw_dic[i.get("geduan")] = {"withdraw": i.get("withdraw")}
        geduan_list = ["APP", "PC", "WAP"]  # 各端列表
        for gd in geduan_list:
            models.GeDuanInfo.objects.using("default").create(
                qdate=qdate,
                geduan=gd,
                recover=geduan_rw_dic.get(gd, {"recover": 0}).get("recover"),
                recover_withdraw=geduan_rw_dic.get(gd, {"recover_withdraw": 0}).get("recover_withdraw"),
                account=geduan_account_dic.get(gd, {"account": 0}).get("account"),
                xztz_j=geduan_xztz_dic.get(gd, {"xztz_j": 0}).get("xztz_j"),
                withdraw=geduan_withdraw_dic.get(gd, {"withdraw": 0}).get("withdraw")
            )

        # 增加时间段数据详情
        timeslot_info = self.get_info_list("daily", "timeslot.sql")  # 获取各时间段投资详情
        for row in timeslot_info:
            models.TimeSlot.objects.using("default").create(
                qdate=qdate,  # 日期
                timeslot=row.get("timeslot"),  # 时间段
                tz_r=row.get("tz_r")  # 投资人数
            )

        # 增加其他数据详情
        short_tz_info = self.get_info_dict("daily", "short_tz.sql")  # 获取短标投资信息
        short_zd_info = self.get_info_dict("daily", "short_zd.sql")  # 获取短标在贷信息
        Rplan_tz_info = self.get_info_dict("daily", "Rplan_tz.sql")  # 获取R计划投资信息
        Rplan_zd_info = self.get_info_dict("daily", "Rplan_zd.sql")  # 获取R计划在贷信息
        Rplan_xt_info = self.get_info_dict("daily", "Rplan_xt.sql")  # 获取R计划续投信息
        unRplan_xt_hk_j = self.get_info_dict("daily", "unRplan_xt_hk_info.sql")  # 获取非R计划自动续投回款
        g_tz_info = self.get_info_dict("daily", "g_tz_info.sql")  # 获取供应链金融投资信息
        x_tz_info = self.get_info_dict("daily", "x_tz_info.sql")  # 获取消费金融投资信息
        models.OtherInfo.objects.using("default").create(
            qdate=short_tz_info.get("qdate"),
            short_tz_r=short_tz_info.get("short_tz_r"),
            short_tz_j=short_tz_info.get("short_tz_j"),
            short_zd_j=short_zd_info.get("short_zd_j"),
            Rplan_account=Rplan_tz_info.get("Rplan_account"),
            Rplan_recover_account=Rplan_zd_info.get("Rplan_recover_account"),
            g_tz_j=g_tz_info.get("g_tz_j"),
            x_tz_j=x_tz_info.get("x_tz_j"),
            Rplan_xt=Rplan_xt_info.get("Rplan_xt"),
            unRplan_xt_hk_j=unRplan_xt_hk_j.get("unRplan_xt_hk_j"),
        )
        # 增加每日每人在贷详情
        user_recover_info = self.get_info_list("daily", "user_recover.sql")  # 获取每人在贷详情
        cursor = connections['default'].cursor()  # 创建数据库游标
        for row in user_recover_info:
            sql = """INSERT INTO `rzjf_user_recover` (`qdate`, `uid`, `recover_account`)
            VALUES ('%s', '%s', '%s');""" % (row.get("qdate"), row.get("uid"), row.get("recover_account"))
            cursor.execute(sql)  # 执行SQL
        cursor.close()  # 关闭游标

        # 增加EXCEL日报资产数据详情
        daily_qixian_info = self.get_info_list("daily", "daily_qixian_info.sql")  # 获取所有资产期限数据
        for row in daily_qixian_info:
            models.DailyAssetInfo.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                asset_type="所有",  # 资产类型
                term=row.get("term"),  # 期限类型
                tz_r=row.get("tz_r"),  # 投资人数
                tz_j=row.get("tz_j"),  # 投资金额
                mb_ys=row.get("mb_ys")  # 满标用时
            )
        daily_s_qixian_info = self.get_info_list("daily", "daily_s_qixian_info.sql")  # 获取散标资产期限数据
        for row in daily_s_qixian_info:
            models.DailyAssetInfo.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                asset_type="散标",  # 资产类型
                term=row.get("term"),  # 期限类型
                tz_r=row.get("tz_r"),  # 投资人数
                tz_j=row.get("tz_j"),  # 投资金额
            )
        daily_r_qixian_info = self.get_info_list("daily", "daily_r_qixian_info.sql")  # 获取R计划资产期限数据
        for row in daily_r_qixian_info:
            models.DailyAssetInfo.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                asset_type="R计划",  # 资产类型
                term=row.get("term"),  # 期限类型
                tz_r=row.get("tz_r"),  # 投资人数
                tz_j=row.get("tz_j"),  # 投资金额
            )

        # 增加EXCEL日报提现分类数据详情
        daily_withdraw_section = self.get_info_list("daily", "daily_withdraw_section.sql")  # 获取累计提现区间数据
        for row in daily_withdraw_section:
            models.DailyWithdrawClassify.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                withdraw_type="提现区间",  # 提现类型
                term=row.get("term"),  # 提现分类
                tx_r=row.get("tx_r"),  # 提现人数
                tx_j=row.get("tx_j"),  # 提现金额
            )
        # 获取累计提现投资时间间隔数据
        daily_withdraw_investment_interval = self.get_info_list("daily", "daily_withdraw_investment_interval.sql")
        for row in daily_withdraw_investment_interval:
            models.DailyWithdrawClassify.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                withdraw_type="投资时间间隔",  # 提现类型
                term=row.get("term"),  # 提现分类
                tx_r=row.get("tx_r"),  # 提现人数
                tx_j=row.get("tx_j"),  # 提现金额
            )
        # 获取累计提现投资次数数据
        daily_withdraw_investment_times = self.get_info_list("daily", "daily_withdraw_investment_times.sql")
        for row in daily_withdraw_investment_times:
            models.DailyWithdrawClassify.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                withdraw_type="投资次数",  # 提现类型
                term=row.get("term"),  # 提现分类
                tx_r=row.get("tx_r"),  # 提现人数
                tx_j=row.get("tx_j"),  # 提现金额
            )

        # 增加EXCEL日报待收分类数据详情
        daily_collect_section = self.get_info_list("daily", "daily_collect_section.sql")  # 获取待收区间数据
        for row in daily_collect_section:
            models.DailyCollectClassify.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                collect_type="待收区间",  # 待收类型
                term=row.get("term"),  # 待收分类
                collect_r=row.get("collect_r"),  # 待收人数
                collect_j=row.get("collect_j"),  # 待收金额
            )
        # 获取待收投资时间间隔数据
        daily_collect_investment_interval = self.get_info_list("daily", "daily_collect_investment_interval.sql")
        for row in daily_collect_investment_interval:
            models.DailyCollectClassify.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                collect_type="待收投资时间间隔",  # 待收类型
                term=row.get("term"),  # 待收分类
                collect_r=row.get("collect_r"),  # 待收人数
                collect_j=row.get("collect_j"),  # 待收金额
            )
        # 获取待收投资次数数据
        daily_collect_investment_times = self.get_info_list("daily", "daily_collect_investment_times.sql")
        for row in daily_collect_investment_times:
            models.DailyCollectClassify.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                collect_type="待收投资次数",  # 待收类型
                term=row.get("term"),  # 待收分类
                collect_r=row.get("collect_r"),  # 待收人数
                collect_j=row.get("collect_j"),  # 待收金额
            )
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


def rzjf_recorde(request):
    """用于定时存储人众金服业务所产生的一些记录"""
    # 获取更新用SQL
    rzjf_first_invest_recorde_sql = db_connect.get_sql("crm", "RzSql", "storage", "rzjf_first_invest_recorde.sql")
    # 连接数据库并执行SQL
    cursor = connections['rz_bi'].cursor()
    cursor.execute(rzjf_first_invest_recorde_sql)
    return HttpResponse("ok!")
