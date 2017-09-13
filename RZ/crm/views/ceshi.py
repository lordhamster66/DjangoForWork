#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/11
import os
from RZ import settings
from crm import models
from django.shortcuts import HttpResponse
from datetime import timedelta, date
from django.db import connections
from crm import utils  # 常用功能及一些工具或一些常用变量


def ceshi(request):
    cursor = connections['rz_bi'].cursor()  # 获取一个游标
    updatesql_file_name_list = os.listdir(os.path.join(settings.BASE_DIR, "crm", "RzSql", "update"))
    for sql_file_name in updatesql_file_name_list:
        temp_sql = utils.sql_file_parser("update", sql_file_name)  # 获取sql
        temp_ret = cursor.execute(temp_sql)  # 执行sql
        print(1)
    return HttpResponse("ok!")
