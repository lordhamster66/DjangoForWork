import hashlib
from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.shortcuts import redirect
from crm import models
from io import BytesIO
from utils.check_code import create_validate_code
from backend.forms import RegisterForm
from backend.forms import LoginForm


# Create your views here.
def check_code(request):
    """
    验证码
    :param request:
    :return:
    """
    # stream = BytesIO()
    # img, code = create_validate_code()
    # img.save(stream, 'PNG')
    # request.session['CheckCode'] = code
    # return HttpResponse(stream.getvalue())

    # data = open('static/imgs/avatar/20130809170025.png','rb').read()
    # return HttpResponse(data)

    # 1. 创建一张图片 pip3 install Pillow
    # 2. 在图片中写入随机字符串
    # obj = object()
    # 3. 将图片写入到制定文件
    # 4. 打开制定目录文件，读取内容
    # 5. HttpResponse(data)

    stream = BytesIO()
    img, code = create_validate_code()
    img.save(stream, 'PNG')
    request.session['CheckCode'] = code
    return HttpResponse(stream.getvalue())


def login(request):
    """后台登录页面"""
    if request.method == "GET":
        login_obj = LoginForm()
        return render(request, "login.html", {"login_obj": login_obj})
    elif request.method == "POST":
        login_obj = LoginForm(request.POST)
        if login_obj.is_valid():
            code = login_obj.cleaned_data.get("check_code")  # 获取用户输入验证码
            if request.session.get("CheckCode").upper() == code.upper():  # 用户输入验证码和系统生成验证码匹配
                username = login_obj.cleaned_data.get("username")  # 获取用户输入用户名
                request.session["username"] = username  # 在session中设置用户名
                request.session.clear_expired()  # 将所有Session失效日期小于当前日期的数据删除
                remember = login_obj.cleaned_data.get("remember")  # 用户是否选中一个月内自动登录
                if remember:  # 用户选中一个月内自动登录
                    request.session.set_expiry(2592000)  # 设置过期时间为一个月之后
                return redirect("/backend/index/")  # 注册完毕直接跳转登录页面
            else:
                login_obj.add_error("check_code", "验证码错误")  # 添加验证码错误信息
        return render(request, "login.html", {"login_obj": login_obj})


def logout(request):
    """注销登录"""
    if request.method == "GET":
        request.session.delete(request.session.session_key)
    return redirect("/backend/login/")


def register(request):
    """后台注册页面"""
    if request.method == "GET":
        register_obj = RegisterForm()
        return render(request, "register.html", {"register_obj": register_obj})
    elif request.method == "POST":
        register_obj = RegisterForm(request.POST)  # 生成注册form对象
        if register_obj.is_valid():
            code = register_obj.cleaned_data.get("check_code")  # 获取用户输入验证码
            if request.session.get("CheckCode").upper() == code.upper():  # 用户输入验证码和系统生成验证码匹配
                pwd = register_obj.cleaned_data.get("pwd")  # 获取用户输入的密码
                m_obj = hashlib.md5()  # 生成一个加密对象
                m_obj.update(pwd.encode())  # 加密用户密码
                pwd = m_obj.hexdigest()  # 获取加密的用户密码
                # 注册用户
                models.User.objects.using("default").create(
                    username=register_obj.cleaned_data.get("username"),
                    pwd=pwd,
                    qq=register_obj.cleaned_data.get("qq")
                )
                return redirect("/backend/login/")  # 注册完毕直接跳转登录页面
            else:
                register_obj.add_error("check_code", "验证码错误")  # 添加验证码错误信息
        return render(request, "register.html", {"register_obj": register_obj})
