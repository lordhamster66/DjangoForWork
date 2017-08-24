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
    return HttpResponse("ok")


class DataStorage(View):
    """用于取出公司数据库信息导入本地数据库"""
    def dispatch(self, request, *args, **kwargs):
        result = super(DataStorage, self).dispatch(request, *args, **kwargs)
        return result

    def get_sql(self, catalog, file_name):
        """获取sql内容"""
        file_path = os.path.join(settings.BASE_DIR, "crm", "RzSql", catalog, file_name)
        f = open(file_path, "r", encoding="utf-8")
        sql = f.read()
        f.close()
        return sql

    def excute_sql(self, sql):
        """执行sql并获取结果"""
        cursor = connections['rz'].cursor()
        cursor.execute(sql)
        row = cursor.fetchone()
        col_names = [desc[0] for desc in cursor.description]
        info = dict(zip(col_names, row))
        return info

    def get(self, request, *args, **kwargs):
        base_info_sql = self.get_sql("daily", "base_info.sql")
        base_info = self.excute_sql(base_info_sql)
        balance_sql = self.get_sql("daily", "balance.sql")
        balance_info = self.excute_sql(balance_sql)
        models.BaseInfo.objects.using("default").create(
            qdate=base_info.get("qdate"),
            zhu_r=base_info.get("zhu_r"),
            sm_r=base_info.get("sm_r"),
            sc_r=base_info.get("sc_r"),
            xztz_r=base_info.get("xztz_r"),
            xztz_j=base_info.get("xztz_j"),
            cz_r=base_info.get("cz_r"),
            cz_j=base_info.get("cz_j"),
            tx_r=base_info.get("tx_r"),
            tx_j=base_info.get("tx_j"),
            tz_r=base_info.get("tz_r"),
            tz_j=base_info.get("tz_j"),
            tz_b=base_info.get("tz_b"),
            tz_dl_r=base_info.get("tz_dl_r"),
            hk_r=base_info.get("hk_r"),
            hk_j=base_info.get("hk_j"),
            zg_j=balance_info.get("zg_j"),
            zg_r=balance_info.get("zg_r"),
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
        daily_page1 = {}
        daily_page1["tz_zh"] = round(int(base_info.xztz_r) / int(base_info.zhu_r) * 100, 2)
        daily_page1["tz_j"] = round(int(base_info.tz_j) / 10000, 2)
        daily_page1["xztz_j"] = round(int(base_info.xztz_j) / 10000, 2)
        daily_page1["xztz_j_zb"] = round(int(base_info.xztz_j) / int(base_info.tz_j) * 100, 0)
        daily_page1["sm_r"] = int(base_info.sm_r)
        daily_page1["zhu_r"] = int(base_info.zhu_r)
        daily_page1["tz_r"] = int(base_info.tz_r)
        daily_page1["xztz_r"] = int(base_info.xztz_r)
        daily_page1["pg_tz_j"] = round(int(base_info.tz_j) / int(base_info.tz_r) / 10000, 1)
        return daily_page1

    def get(self, request, *args, **kwargs):
        today = datetime.datetime.strftime(datetime.datetime.now() + datetime.timedelta(-1), "%Y-%m-%d")
        daily_page1 = self.get_info(today)
        return render(request, "daily.html", {"daily_page1": daily_page1})

    def post(self, request, *args, **kwargs):
        qdate = request.POST.get("qdate")
        daily_page1 = self.get_info(qdate)
        return render(request, "daily.html", {"daily_page1": daily_page1})
