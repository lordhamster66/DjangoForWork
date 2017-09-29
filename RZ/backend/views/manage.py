#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/19
import json
import requests  # 爬虫专用
from django.shortcuts import render
from django.shortcuts import redirect
from django.shortcuts import HttpResponse
from crm import models
from utils import db_connect
from utils.pagination import Page
from backend.forms import UserForm
from utils.encoder import JsonCustomEncoder
from backend.forms import SmStForm
from datetime import datetime, timedelta


def login_decorate(func):
    """登录验证装饰器"""

    def inner(request, *args, **kwargs):
        username = request.session.get("username", None)  # 获取session中的用户名
        if username:
            user_obj = models.User.objects.filter(username=username).first()
            if user_obj:
                ret = func(request, *args, **kwargs)
            else:
                return redirect("/backend/login/")
        else:
            return redirect("/backend/login/")
        return ret

    return inner


def upload_head_portrait(request):
    """上传头像"""
    username = request.session.get("username")
    userobj = models.User.objects.using("default").filter(username=username).first()
    if request.method == "GET":
        pass
    elif request.method == "POST":
        ret = {"status": True, "data": None}
        userobj.avatar = request.FILES.get("head_portrait")
        userobj.save()
        return HttpResponse(json.dumps(ret))


@login_decorate
def index(request):
    """后台首页"""
    username = request.session.get("username")  # 获取用户名
    userobj = models.User.objects.using("default").filter(username=username).first()  # 获取用户对象
    return render(request, "backend_index.html", {"username": username, "userobj": userobj})


@login_decorate
def base_info(request):
    """后台个人信息"""
    username = request.session.get("username")  # 获取用户名
    userobj = models.User.objects.using("default").filter(username=username).first()  # 获取用户对象
    if request.method == "GET":
        userform_obj = UserForm()
        return render(request, "backend_base_info.html", {
            "username": username, "userform_obj": userform_obj, "userobj": userobj
        })


@login_decorate
def tg_info(request):
    """后台推广数据信息"""
    username = request.session.get("username")  # 获取用户名
    userobj = models.User.objects.using("default").filter(username=username).first()  # 获取用户对象
    if request.method == "GET":
        start_time = request.session.get("smst_start_time", "")  # 获取上次查询的起始日期
        end_time = request.session.get("smst_end_time", "")  # 获取上次查询的终止日期
        qudao_name = request.session.get("smst_qudao_name_id", "1")  # 获取上次查询的渠道名称
        data_type = request.session.get("smst_data_type_id", "1")  # 获取上次查询的是实名还是首投
        info_list = request.session.get("tg_info_list", [])  # 获取上次查询的信息,没有则置空
        smst_obj = SmStForm({
            "start_time": start_time,
            "end_time": end_time,
            "qudao_name": qudao_name,
            "data_type": data_type
        })  # 获取实名首投form对象
        current_page = int(request.GET.get("p", "1"))  # 获取当前页，没有则默认第一页
        page_obj = Page(current_page, len(info_list))  # 生成分页对象
        info_list = info_list[page_obj.start:page_obj.end]  # 获取当前页的所有文章
        page_str = page_obj.page_str("/backend/tg_info/")  # 获取分页html
        return render(request, "backend_tg_info.html", {
            "username": username, "userobj": userobj, "info_list": info_list, "page_str": page_str,
            "smst_obj": smst_obj
        })
    elif request.method == "POST":
        data_type_dict = {"1": "sm.sql", "2": "st.sql"}  # 实名首投对应sql语句
        smst_obj = SmStForm(request.POST)  # 获取实名首投form对象
        if smst_obj.is_valid():  # 验证是否通过form认证
            start_time = datetime.strftime(smst_obj.cleaned_data.get("start_time"), "%Y-%m-%d")  # 格式化用户输入起始日期
            end_time = datetime.strftime(smst_obj.cleaned_data.get("end_time"), "%Y-%m-%d")  # 格式化用户输入终止日期
            qudao_name_id = smst_obj.cleaned_data.get("qudao_name")  # 获取用户输入渠道名称
            data_type_id = smst_obj.cleaned_data.get("data_type")  # 获取用户输入的是实名还是首投
            # 获取渠道名称对应的对象
            tg_qudao_name_obj = models.TgQudaoName.objects.using("default").filter(id=qudao_name_id).first()
            qudao_sign_list = ["'%s'" % i for i in tg_qudao_name_obj.sign.split(",")]  # 以逗号分隔渠道标识
            qudao_sign = ",".join(qudao_sign_list)  # 重组渠道标识
            # 获取sql语句
            sql = db_connect.get_sql("crm", "RzSql", "tg", data_type_dict[data_type_id])
            # 格式化sql语句
            sql = sql.format(
                start_time=start_time,
                end_time=end_time,
                name=qudao_sign
            )
            info_list = db_connect.get_info_list("rz", sql)  # 获取查询结果
            info_list = json.loads(json.dumps(info_list, cls=JsonCustomEncoder))
            request.session["tg_info_list"] = info_list  # 将查询结果放入session
            request.session["smst_start_time"] = start_time  # 将用户查询的日期，保存以便告诉用户刚才所查询的日期
            request.session["smst_end_time"] = end_time
            request.session["smst_qudao_name_id"] = qudao_name_id  # 存放这次查询的渠道名称id
            request.session["smst_data_type_id"] = data_type_id  # 存放这次查询的是实名还是首投
            page_obj = Page(1, len(info_list))  # 生成分页对象
            info_list = info_list[page_obj.start:page_obj.end]  # 获取当前页的所有文章
            page_str = page_obj.page_str("/backend/tg_info/")  # 获取分页html
            return render(request, "backend_tg_info.html", {
                "username": username, "userobj": userobj, "info_list": info_list, "page_str": page_str,
                "smst_obj": smst_obj
            })
        else:
            return render(request, "backend_tg_info.html", {
                "username": username, "userobj": userobj, "smst_obj": smst_obj
            })


@login_decorate
def wdzj_jk(request):
    """网贷之家接口"""
    username = request.session.get("username")  # 获取用户名
    userobj = models.User.objects.using("default").filter(username=username).first()  # 获取用户对象
    qdate = ""  # 定义日期
    num_show = 10  # 定义每页显示行数
    current_page = 1  # 定义当前页
    if request.method == "GET":
        today = datetime.strftime(datetime.now() + timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        default_wdzj_jk_dict = {"qdate": today}  # 默认日期为昨天
        qdate = request.session.get("wdzj_jk_dict", default_wdzj_jk_dict).get("qdate")
        current_page = int(request.GET.get("p", "1"))  # 获取当前页
    elif request.method == "POST":
        qdate = request.POST.get("qdate")  # 获取起始日期
        request.session["wdzj_jk_dict"] = {
            "qdate": qdate
        }  # 将用户此次输入日期存入session
        current_page = 1  # POST请求则为第一页
    url = "https://www.51rz.com/api/iwdzj.php/IwdzjnewV2/GetNowProjects?token=2e7c3ff493e716d0680d175513b0dff4&date={qdate}&page={current_page}&pageSize={num_show}".format(
        qdate=qdate,
        num_show=num_show,
        current_page=current_page,
    )
    response = requests.get(url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64)"})
    data = response.json() if response.status_code == 200 else {"totalCount": 0, "borrowList": []}  # 获取接口返回的数据
    data_count = int(data.get("totalCount", 0))  # 获取总个数
    info_list = data.get("borrowList")  # 获取当前页内容
    page_obj = Page(current_page, data_count)  # 生成分页对象
    page_str = page_obj.page_str("/backend/wdzj_jk/")  # 获取分页html
    return render(request, "backend_wdzj_jk.html", {
        "username": username, "userobj": userobj, "info_list": info_list, "page_str": page_str,
        "qdate": qdate
    })


@login_decorate
def wdty_jk(request):
    """网贷天眼接口"""
    username = request.session.get("username")  # 获取用户名
    userobj = models.User.objects.using("default").filter(username=username).first()  # 获取用户对象
    time_from = ""  # 定义起始日期
    time_to = ""  # 定义终止日期
    num_show = 10  # 定义每页显示行数
    current_page = 1  # 定义当前页
    if request.method == "GET":
        today = datetime.strftime(datetime.now() + timedelta(-1), "%Y-%m-%d")  # 获取昨天日期
        default_wdty_jk_dict = {"time_from": today, "time_to": today}  # 默认日期为昨天
        time_from = request.session.get("wdty_jk_dict", default_wdty_jk_dict).get("time_from")
        time_to = request.session.get("wdty_jk_dict", default_wdty_jk_dict).get("time_to")
        current_page = int(request.GET.get("p", "1"))  # 获取当前页
    elif request.method == "POST":
        time_from = request.POST.get("time_from")  # 获取起始日期
        time_to = request.POST.get("time_to")  # 获取终止日期
        request.session["wdty_jk_dict"] = {
            "time_from": time_from,
            "time_to": time_to,
        }  # 将用户此次输入日期存入session
        current_page = 1  # POST请求则为第一页
    url = "https://www.51rz.com/api/ip2peye.php/Ip2peye/blist?token=acb1415727bc2b1375d8f3a221816c1b&time_from={time_from}&time_to={time_to}%2023:59:59&status=1&page_size={num_show}&page_index={current_page}".format(
        time_from=time_from,
        time_to=time_to,
        num_show=num_show,
        current_page=current_page,
    )
    response = requests.get(url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64)"})
    data = response.json() if response.status_code == 200 else {"page_count": 0, "loans": []}  # 获取接口返回的数据
    data_count = int(data.get("page_count", 0)) * num_show  # 获取总个数
    info_list = data.get("loans")  # 获取当前页内容
    page_obj = Page(current_page, data_count)  # 生成分页对象
    page_str = page_obj.page_str("/backend/wdty_jk/")  # 获取分页html
    return render(request, "backend_wdty_jk.html", {
        "username": username, "userobj": userobj, "info_list": info_list, "page_str": page_str,
        "time_from": time_from, "time_to": time_to
    })
