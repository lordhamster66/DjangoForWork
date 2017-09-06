#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/6
from django.utils.deprecation import MiddlewareMixin
from django.shortcuts import HttpResponse
from django.shortcuts import render
from django.template.exceptions import TemplateDoesNotExist


class CommonMiddle(MiddlewareMixin):
    """普通中间件"""

    def process_request(self, request):
        pass

    def process_view(self, request, view_func, view_func_args, view_func_kwargs):
        pass

    def process_response(self, request, response):
        pass
        return response  # 必须将内容返回给用户

    def process_exception(self, request, exception):
        """只有出现异常时才会执行"""
        if isinstance(exception, ValueError):
            return HttpResponse('出现异常》。。')
        elif isinstance(exception, TemplateDoesNotExist):
            print(request.path_info)
            return render(request, "404.html")
