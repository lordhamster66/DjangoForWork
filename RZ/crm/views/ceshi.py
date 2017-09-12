#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/11
from crm import models
from django.shortcuts import HttpResponse
from datetime import timedelta, date


def ceshi(request):
    # cursor = connections['default'].cursor()
    # cursor.execute("""create table 05b_0base like wd.05b_0base;""")
    # cursor.execute("""""")
    obj_list = models.BaseInfo.objects.using("default").filter(
        qdate__range=(date.today() + timedelta(days=-8), date.today() + timedelta(days=-1))).all()
    zhu_r_list = []
    for obj in obj_list:
        zhu_r_list.append(obj.zhu_r)
    print(zhu_r_list)
    return HttpResponse("ok!")
