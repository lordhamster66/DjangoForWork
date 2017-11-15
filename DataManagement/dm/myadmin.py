#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/14
from dm import models

"""
{"dm": {"sql_record": SQLRecordAdmin}}
"""
enabled_admin = {}


class BaseAdmin(object):
    list_display = ()  # 显示字段的列表
    list_filter = ()  # 过滤字段的列表
    search_fields = ()
    list_per_page = 20  # 每页显示多少个


def register(model_class, admin_class):
    """注册表"""
    app_name = model_class._meta.app_label  # 获取APP名称
    model_name = model_class._meta.model_name  # 获取表名称
    if app_name not in enabled_admin:
        enabled_admin[app_name] = {}
    admin_class.model = model_class  # 将表对应的类存储至admin_class中
    enabled_admin[app_name][model_name] = admin_class


class SQLRecordAdmin(BaseAdmin):
    list_display = ("id", "user", "sql_name", "department", "date")
    list_filter = ("user", "department",)
    search_fields = ("sql_name", "department__name")
    list_per_page = 20


register(models.SQLRecord, SQLRecordAdmin)
