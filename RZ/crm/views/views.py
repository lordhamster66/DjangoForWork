import datetime
import requests  # 爬虫专用
import json
import hashlib  # 加密模块
from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.shortcuts import redirect
from crm import models
from crm import forms
from utils import mypagenation


# Create your views here.


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


def logout(request):
    """注销功能"""
    if request.method == "GET":
        request.session.delete(request.session.session_key)
    return redirect("/crm/login/")


def wdzj(request):
    """对接网贷之家接口"""
    today = datetime.datetime.strftime(datetime.datetime.now() + datetime.timedelta(-1), "%Y-%m-%d")
    if request.method == "GET":
        qdate = request.GET.get("qdate", today)  # 获取日期，默认昨天
        username = request.GET.get("u")  # 获取用户名
        current_page = int(request.GET.get("p", "1"))  # 获取当前页
    elif request.method == "POST":
        qdate = request.POST.get("qdate", today)  # 获取日期，默认昨天
        username = request.POST.get("username")  # 获取用户名
        current_page = int(request.POST.get("p", "1"))  # 获取当前页
    num_show = 20
    url = "https://www.51rz.com/api/iwdzj.php/IwdzjnewV2/GetNowProjects?token=2e7c3ff493e716d0680d175513b0dff4&date={qdate}&page={current_page}&pageSize={num_show}".format(
        current_page=current_page, num_show=num_show, qdate=qdate)
    response = requests.get(url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64)"})
    data = response.json()  # 获取接口返回的数据
    data_count = int(data.get("totalCount", 0))
    pagenation = mypagenation.MyPageNation(current_page, data_count, num_show)
    page_str = pagenation.page_str("/crm/wdzj/", username, qdate)
    borrowList = data.get("borrowList")
    return render(request, "wdzj.html", {"username": username, "borrowList": borrowList, "page_str": page_str})
