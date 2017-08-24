import os
import time
import datetime
from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.views import View
from django.db import connections
from crm import models
from RZ import settings


# Create your views here.


def ceshi(request):
    file_path = os.path.join(settings.BASE_DIR, "crm", "RzSql", "daily", "qixian_tz.sql")
    f = open(file_path, "r", encoding="utf-8")
    sql = f.read()
    f.close()
    cursor = connections['rz'].cursor()
    cursor.execute(sql)
    data = cursor.fetchall()
    col_names = [i[0] for i in cursor.description]
    info = [dict(zip(col_names, row)) for row in data]
    print(info)
    return HttpResponse("ok!%s" % info)


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

    def get(self, request, *args, **kwargs):
        base_info = self.get_info_dict("daily", "base_info.sql")  # 基础信息
        balance_info = self.get_info_dict("daily", "zhangang.sql")  # 站岗信息
        # 增加基础数据信息
        models.BaseInfo.objects.using("default").create(
            qdate=base_info.get("qdate"),  # 日期
            zhu_r=base_info.get("zhu_r"),  # 注册人数
            sm_r=base_info.get("sm_r"),  # 实名人数
            sc_r=base_info.get("sc_r"),  # 首充人数
            xztz_r=base_info.get("xztz_r"),  # 新增投资人数
            xztz_j=base_info.get("xztz_j"),  # 新增投资金额
            cz_r=base_info.get("cz_r"),  # 充值人数
            cz_j=base_info.get("cz_j"),  # 充值金额
            tx_r=base_info.get("tx_r"),  # 提现人数
            tx_j=base_info.get("tx_j"),  # 提现金额
            tz_r=base_info.get("tz_r"),  # 投资人数
            tz_j=base_info.get("tz_j"),  # 投资金额
            tz_b=base_info.get("tz_b"),  # 投资笔数
            tz_dl_r=base_info.get("tz_dl_r"),  # 投资登录人数
            hk_r=base_info.get("hk_r"),  # 回款人数
            hk_j=base_info.get("hk_j"),  # 回款金额
            zg_j=balance_info.get("zg_j"),  # 站岗金额
            zg_r=balance_info.get("zg_r"),  # 站岗人数
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
            qdate=xz_cz_info.get("qdate"),  # 日期
            invite_r=invite_info.get("invite_r"),  # 邀请人数
            invited_r=invite_info.get("invited_r"),  # 被邀请人数
            invited_st_r=invite_info.get("invited_st_r"),  # 被邀请首投人数
            invited_st_j=invite_info.get("invited_st_j"),  # 被邀请首投金额
            cash_f=invite_info.get("cash_f"),  # 现金发放金额
            cash_l=invite_info.get("cash_l"),  # 现金领取金额
            hb_f=invite_info.get("hb_f"),  # 红包发放金额
            hb_s=invite_info.get("hb_s")  # 红包使用金额
        )
        qixian_mb_ys_info = self.get_info_list("daily", "qixian_mb_ys.sql")  # 获取期限满标用时数据
        qixian_tz_info = self.get_info_list("daily", "qixian_tz.sql")  # 获取期限投资数据
        # 增加资产数据详情
        for index, row in enumerate(qixian_mb_ys_info):
            models.AssetInfo.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                term=row.get("term"),  # 期限类型
                tz_r=qixian_tz_info[index].get("tz_r"),  # 投资人数
                tz_j=qixian_tz_info[index].get("tz_j"),  # 投资金额
                mb_ys=row.get("mb_ys")  # 满标用时
            )
        return HttpResponse("ok!")

    def post(self, request, *args, **kwargs):
        pass


class Daily(View):
    """用于日报展示"""

    def dispatch(self, request, *args, **kwargs):
        result = super(Daily, self).dispatch(request, *args, **kwargs)
        return result

    def get_info(self, qdate):
        base_info = models.BaseInfo.objects.using("default").filter(qdate=qdate).first()
        tg_info = models.TgInfo.objects.using("default").filter(qdate=qdate).first()
        operate_info = models.OperateInfo.objects.using("default").filter(qdate=qdate).first()
        invite_info = models.InviteInfo.objects.using("default").filter(qdate=qdate).first()
        asset_info = models.AssetInfo.objects.using("default").filter(qdate=qdate).first()
        kefu_info = models.KeFuInfo.objects.using("default").filter(qdate=qdate).first()
        # 存放第一页数据
        daily_page1 = {}
        daily_page1["tz_zh"] = round(int(base_info.xztz_r) / int(base_info.zhu_r) * 100, 2)  # 当日投资转化率
        daily_page1["tz_j"] = round(int(base_info.tz_j) / 10000, 2)  # 投资金额
        daily_page1["xztz_j"] = round(int(base_info.xztz_j) / 10000, 2)  # 新增投资金额
        daily_page1["xztz_j_zb"] = round(int(base_info.xztz_j) / int(base_info.tz_j) * 100, 0)  # 新增投资金额占比
        daily_page1["sm_r"] = int(base_info.sm_r)  # 实名人数
        daily_page1["zhu_r"] = int(base_info.zhu_r)  # 注册人数
        daily_page1["tz_r"] = int(base_info.tz_r)  # 投资人数
        daily_page1["xztz_r"] = int(base_info.xztz_r)  # 新增投资人数
        daily_page1["pg_tz_j"] = round(int(base_info.tz_j) / int(base_info.tz_r) / 10000, 1)  # 平均每人投资
        daily_page1["tj_r"] = int(invite_info.invited_st_r)
        return daily_page1

    def get(self, request, *args, **kwargs):
        today = datetime.datetime.strftime(datetime.datetime.now() + datetime.timedelta(-1), "%Y-%m-%d")
        daily_page1 = self.get_info(today)
        return render(request, "daily.html", {"daily_page1": daily_page1})

    def post(self, request, *args, **kwargs):
        qdate = request.POST.get("qdate")
        daily_page1 = self.get_info(qdate)
        return render(request, "daily.html", {"daily_page1": daily_page1})
