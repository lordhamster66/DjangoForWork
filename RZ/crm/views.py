import os
import datetime
import requests  # 爬虫专用
import random
import json
import hashlib  # 加密模块
import re  # 正则模块
from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.shortcuts import redirect
from django.views import View
from django.db import connections
from crm import models
from RZ import settings
from crm import forms
from django.db.utils import InternalError
from crm import utils  # 常用功能及一些工具或一些常用变量


# Create your views here.


def backup(request):
    """备份数据库表"""
    if request.method == "GET":
        """
            01u_0info_compay 

            11_auth

            01u_0base
            05b_0base
            05b_0base_run
            05b_7dsbid
            05b_1tenderfinal
            rz_borrow
            rz_loan_open_data
            rz_borrow_tender
            rz_borrow_big
        """
        cursor = connections['default'].cursor()  # 获取一个游标
        base_sql = utils.sql_file_parser("backup", "05b_0base.sql")  # 获取更新05b_0base表的sql
        try:
            cursor.execute("create table 05b_0base like wd.05b_0base;")  # 在rzjf_bi创建05b_0base表
        except InternalError as e:  # 捕捉错误并继续
            print(e)
        base_ret = cursor.execute(base_sql)  # 更新05b_0base表内容
        settings.action_logger.info("05b_obase更新了%s条数据!" % (base_ret,))
        return HttpResponse("ok!")


def ceshi(request):
    # cursor = connections['default'].cursor()
    # cursor.execute("""create table 05b_0base like wd.05b_0base;""")
    # cursor.execute("""""")
    settings.action_logger.info("你好!")
    return HttpResponse("ok!")


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
        """
        通过get请求可以将公司数据库的信息存入BI专用数据库
        :param request:
        :param args:
        :param kwargs:
        :return:
        """
        base_info = self.get_info_dict("daily", "base_info.sql")  # 基础信息
        balance_info = self.get_info_dict("daily", "zhangang.sql")  # 站岗信息
        zaidai_info = self.get_info_dict("daily", "zaidai.sql")  # 在贷信息
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
        # 增加资产数据详情
        qixian_mb_ys_info = self.get_info_list("daily", "qixian_mb_ys.sql")  # 获取期限满标用时数据
        qixian_tz_info = self.get_info_list("daily", "qixian_tz.sql")  # 获取期限投资数据
        for index, row in enumerate(qixian_mb_ys_info):
            models.AssetInfo.objects.using("default").create(
                qdate=row.get("qdate"),  # 日期
                term=row.get("term"),  # 期限类型
                tz_r=qixian_tz_info[index].get("tz_r"),  # 投资人数
                tz_j=qixian_tz_info[index].get("tz_j"),  # 投资金额
                mb_ys=row.get("mb_ys")  # 满标用时
            )
        # 增加各端数据详情
        qdate = datetime.datetime.strftime(datetime.datetime.now() + datetime.timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
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
                recover=geduan_rw_dic.get(gd).get("recover"),
                recover_withdraw=geduan_rw_dic.get(gd).get("recover_withdraw"),
                account=geduan_account_dic.get(gd).get("account"),
                xztz_j=geduan_xztz_dic.get(gd).get("xztz_j"),
                withdraw=geduan_withdraw_dic.get(gd).get("withdraw")
            )
        settings.action_logger.info("%s日报所需数据已经更新!" % (qdate,))
        return HttpResponse("ok!")

    def post(self, request, *args, **kwargs):
        pass


class Daily(View):
    """用于日报展示"""

    def dispatch(self, request, *args, **kwargs):
        result = super(Daily, self).dispatch(request, *args, **kwargs)
        return result

    def get_info(self, qdate):
        try:
            base_info = models.BaseInfo.objects.using("default").filter(qdate=qdate).first()  # 获取基础信息
            tg_info = models.TgInfo.objects.using("default").filter(qdate=qdate).first()  # 获取推广信息
            operate_info = models.OperateInfo.objects.using("default").filter(qdate=qdate).first()  # 获取运营信息
            invite_info = models.InviteInfo.objects.using("default").filter(qdate=qdate).first()  # 获取邀请信息
            asset_info = models.AssetInfo.objects.using("default").filter(qdate=qdate).first()  # 获取项目信息
            kefu_info = models.KeFuInfo.objects.using("default").filter(qdate=qdate).first()  # 获取客服信息
            # 存放第一页数据
            daily_page1 = {}
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
            daily_page1["tj_r"] = int(invite_info.invited_st_r)
        except Exception as e:
            print(e)
        return daily_page1

    def get(self, request, *args, **kwargs):
        """获取日报"""
        today = datetime.datetime.strftime(datetime.datetime.now() + datetime.timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        daily_page1 = self.get_info(today)
        qdate = forms.DailyForm(initial={"qdate": today})
        return render(request, "daily.html", {"daily_page1": daily_page1, "qdate": qdate})

    def post(self, request, *args, **kwargs):
        """查询其他日期的日报"""
        qdate = request.POST.get("qdate")
        daily_page1 = self.get_info(qdate)
        qdate = forms.DailyForm(request.POST, initial={"qdate": qdate})
        return render(request, "daily.html", {"daily_page1": daily_page1, "qdate": qdate})


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


def login(request):
    """登录功能"""
    register_obj = forms.RegisterForm()  # 获取RegisterForm对象
    if request.method == "GET":
        login_obj = forms.LoginForm()
        return render(request, "login.html", {"login_obj": login_obj, "register_obj": register_obj})  # 返回登录注册页面
    elif request.method == "POST":
        login_obj = forms.LoginForm(request.POST)
        if login_obj.is_valid():
            request.session.clear_expired()  # 清空过期的session
            username = login_obj.clean().get("username")  # 获取用户名
            if login_obj.clean().get("remember", None) == "True":
                request.session["username"] = username  # 设置session
            return render(request, "index.html", {"username": username})
        else:
            return render(request, "login.html", {"login_obj": login_obj, "register_obj": register_obj})


def register(request):
    """注册功能"""
    if request.method == "GET":
        msg_dic = {'status': False, 'error': "滚!", 'data': None}  # get请求也拒绝
        return HttpResponse(json.dumps(msg_dic))
    elif request.method == "POST":
        register_obj = forms.RegisterForm(request.POST)
        if register_obj.is_valid():
            username = register_obj.cleaned_data.get("username")
            pwd = register_obj.cleaned_data.get("pwd")
            qq = register_obj.cleaned_data.get("qq")
            m_obj = hashlib.md5()
            m_obj.update(pwd.encode())
            pwd = m_obj.hexdigest()
            models.User.objects.create(username=username, pwd=pwd, qq=qq)
            msg_dic = {'status': True, 'error': None, 'data': None}
            return HttpResponse(json.dumps(msg_dic))
        else:
            error = register_obj.errors  # 获取所有的错误信息对象，前端可以通过error.username来获取username的错误信息，其他类似
            msg_dic = {'status': False, 'error': error, 'data': None}  # 返回一个字典，前端可以很方便的处理
            return HttpResponse(json.dumps(msg_dic))
    else:
        msg_dic = {'status': False, 'error': "滚!", 'data': None}  # 其他请求则拒绝
        return HttpResponse(json.dumps(msg_dic))


def index(request):
    """后台首页"""
    if request.method == "GET":
        username = request.session.get("username", None)  # 从session获取用户名
        if username:  # 能获取到用户名，则直接让其看页面，否则让其重新登录
            return render(request, "index.html", {"username": username})
        else:
            return redirect("/crm/login/")
    elif request.method == "POST":
        return HttpResponse("滚！")
    else:
        return HttpResponse("滚！")
