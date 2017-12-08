from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.decorators import login_required


# Create your views here.
@login_required
def index(request):
    return render(request, "index.html")


def acc_login(request):
    """登录接口"""
    email = ""  # 用户登录用邮箱
    password = ""  # 用户密码
    errors_dict = {}  # 要返回的错误信息
    if request.method == "POST":
        email = request.POST.get("email")
        password = request.POST.get("password")
        user = authenticate(username=email, password=password)
        if user:
            login(request, user)
            return redirect("/automatic/")
        else:
            errors_dict["认证失败"] = "邮箱或者密码错误！"
    return render(request, "login.html", {"email": email, "password": password, "errors_dict": errors_dict})


def acc_logout(request):
    """注销接口"""
    logout(request)
    return redirect("/accounts/login/")
