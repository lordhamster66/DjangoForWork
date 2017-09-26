#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/19
import os
import json
from django.shortcuts import render
from django.shortcuts import redirect
from django.shortcuts import HttpResponse
from crm import models
from backend.forms import UserForm
from RZ import settings


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


@login_decorate
def index(request):
    username = request.session.get("username")  # 获取用户名
    userobj = models.User.objects.using("default").filter(username=username).first()
    return render(request, "backend_index.html", {"username": username, "userobj": userobj})


@login_decorate
def base_info(request):
    username = request.session.get("username")  # 获取用户名
    userobj = models.User.objects.using("default").filter(username=username).first()
    if request.method == "GET":
        userform_obj = UserForm()
        return render(request, "backend_base_info.html", {
            "username": username, "userform_obj": userform_obj, "userobj": userobj
        })


@login_decorate
def tg_info(request):
    username = request.session.get("username")  # 获取用户名
    userobj = models.User.objects.using("default").filter(username=username).first()
    if request.method == "GET":
        userform_obj = UserForm()
        return render(request, "backend_tg_info.html", {
            "username": username, "userform_obj": userform_obj, "userobj": userobj
        })


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
