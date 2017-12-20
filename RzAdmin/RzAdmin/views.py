import json, os
from RzAdmin import settings
from django.shortcuts import render, redirect, HttpResponse
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


@login_required
def change_avatar(request):
    """修改用户头像"""
    ret = {"status": False, "data": None, "error": None}
    if request.method == "POST":
        avatar_file = request.FILES.get("upload_file")
        avatar_imge_file_path = os.path.join(
            settings.BASE_DIR, "static", "img", "avatar", request.user.email
        )
        os.makedirs(avatar_imge_file_path, exist_ok=True)
        with open(os.path.join(avatar_imge_file_path, avatar_file.name), "wb") as f:
            for line in avatar_file:
                f.write(line)
        avatar = "/static/img/avatar/%s/%s" % (request.user.email, avatar_file.name)
        request.user.avatar = avatar
        request.user.save()
        ret["status"] = True
        ret["data"] = avatar
    return HttpResponse(json.dumps(ret))
