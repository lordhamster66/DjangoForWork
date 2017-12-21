#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/12/21
import re
import logging
from django.urls import resolve
from django.shortcuts import redirect, HttpResponse
from automatic.permissions import permission_dict
from automatic.permissions.permission_dict import PermissionDict

logger = logging.getLogger("__name__")  # 生成一个以当前模块名为名字的logger实例


def check_user_permission(request, *args, **kwargs):
    """验证用户是否有权限"""
    ret = False  # 是否通过权限验证
    for permission_name, permission_detail in PermissionDict.items():
        url_matched = False  # url是否匹配上
        if permission_detail["url_type"] == 0:  # 相对路径
            resolve_obj = resolve(request.path)  # 生成url resolve对象
            url_name = resolve_obj.url_name  # 获取请求的相对路径，及URL别名
            if permission_detail["url"] == url_name:
                url_matched = True
        elif permission_detail["url_type"] == 1:  # 绝对路径
            if permission_detail["url"] == request.path:
                url_matched = True
        elif permission_detail["url_type"] == 2:  # 模糊路径
            if re.match(permission_detail["url"], request.path):
                url_matched = True

        if url_matched:  # url匹配上了继续往下走
            if permission_detail["method"] == request.method:  # 请求方式匹配上了
                args_matched = True  # 参数是否匹配上
                for arg in permission_detail["args"]:
                    # 如果定义的参数在用户请求的参数中获取不到,则表明用户不符合该条权限定义
                    if not getattr(request, permission_detail["method"]).get(arg):
                        args_matched = False
                        break

                if args_matched:  # 参数匹配上了才继续往下走
                    hooks_aproved = True  # 钩子是否通过验证
                    if permission_detail["hooks"]:  # 用户有添加钩子才会进行钩子验证，否则直接通过
                        judgment_str = ""
                        for hook_name in permission_detail["hooks"]:
                            if hook_name in ["or", "and"]:
                                judgment_str += "%s " % hook_name
                            else:
                                if hasattr(permission_dict, hook_name):  # 执行用户自定义钩子
                                    hook_fun = getattr(permission_dict, hook_name)
                                    judgment_str += "%s " % hook_fun(request, *args, **kwargs)
                        judgment_str = "all([%s])" % judgment_str
                        hooks_aproved = eval(judgment_str)

                    if hooks_aproved:  # 通过了用户自定义的钩子验证
                        if request.user.has_perm(permission_name):  # 用户如果有该条权限，则通过权限认证系统
                            ret = True
                            break  # 权限匹配上了直接跳出循环

    return ret


def check_permission_decorate(func):
    """检查用户是否有权限的装饰器"""

    def inner(request, *args, **kwargs):
        if request.user.is_authenticated():  # 首先判断用户是否登录
            ret = check_user_permission(request, *args, **kwargs)
            if ret:  # 权限认证通过
                response = func(request, *args, **kwargs)
            else:  # 权限认证不通过
                logger.warning("用户:%s正在尝试访问无权限接口%s" % (request.user.email, request.path))
                response = HttpResponse("<h2>403 Forbidden</h2>")
        else:  # 没登录跳转至登录页
            response = redirect("/accounts/login/")
        return response

    return inner
