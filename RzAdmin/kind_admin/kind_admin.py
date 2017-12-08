#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/11
from django.shortcuts import redirect
from automatic import models

enabled_admins = {}


class BaseAdmin(object):
    list_display = ()  # 展示字段
    list_filter = ()  # 过滤字段
    search_fields = ()  # 检索字段
    list_per_page = 20  # 每页显示几条数据
    filter_horizontal = ()  # 显示复选框的字段
    ordering = None  # 默认排序字段
    default_actions = ("delete_selected",)  # 默认动作
    actions = ()  # 动作选项
    readonly_fields = ()  # 只读字段
    need_readonly = False  # 是否需要显示为只读
    table_readonly = False  # 整张表是否只读
    modelform_exclude_fields = ()  # model_form表单要剔除的字段

    def delete_selected(self, request, querysets):
        """
        批量删除动作
        :param request: 请求内容
        :param querysets: 请求的所有对象
        :return:
        """
        app_name = self.model._meta.app_label  # APP名称
        table_name = self.model._meta.model_name  # 表名
        obj_ids = "-".join([str(i.id) for i in querysets])  # 拼接所有对象ID
        return redirect("/kind_admin/%s/%s/%s/delete/" % (app_name, table_name, obj_ids))

    delete_selected.display_name = "删除所选记录"


def register(model_class, admin_class=None):
    """注册表"""
    if model_class._meta.app_label not in enabled_admins:
        enabled_admins[model_class._meta.app_label] = {}

    admin_class.model = model_class
    enabled_admins[model_class._meta.app_label][model_class._meta.model_name] = admin_class


# class CustomerAdmin(BaseAdmin):
#     list_display = ("id", "name", "qq", "source", "consult_course", "consultant", "status", "date", "enroll")
#     list_filter = ("source", "consult_course", "consultant", "status", "date")
#     search_fields = ("name", "qq")
#     filter_horizontal = ("tags",)
#     list_per_page = 10
#     actions = ("aa",)
#     readonly_fields = ("qq", "consultant", "tags")
#
#     # table_readonly = True
#
#     # ordering = "name"
#     def aa(self, request, querysets):
#         print("测试")
#         return redirect("/crm/")
#
#     aa.display_name = "测试"
#
#     def enroll(self):
#         return "<a href='/crm/'>报名链接</a>"
#
#     enroll.display_name = "报名"
#
#     def clean(self):
#         pass
#
#     def clean_name(self):
#         pass

class UserProfileAdmin(BaseAdmin):
    list_display = ("email", "name", 'is_admin', "is_active")
    readonly_fields = ("email", "password",)
    filter_horizontal = ("roles",)
    modelform_exclude_fields = ("is_superuser", "last_login", "groups", "user_permissions")


class RoleAdmin(BaseAdmin):
    list_display = ("name",)
    filter_horizontal = ("menus",)


class MenuAdmin(BaseAdmin):
    list_display = ("name", "url_type", "url_name")


class SQLTagAdmin(BaseAdmin):
    list_display = ("user", "name", "date")


class SQLFuncAdmin(BaseAdmin):
    list_display = ("name",)


class SQLRecordAdmin(BaseAdmin):
    list_display = ("user", "name", "content", "query_page", "date")
    filter_horizontal = ("roles", "tags")


class DownloadRecordAdmin(BaseAdmin):
    list_display = ("user", "url", "check_status", "check_user", "date", "end_date")


register(models.UserProfile, UserProfileAdmin)
register(models.Role, RoleAdmin)
register(models.Menu, MenuAdmin)
register(models.SQLTag, SQLTagAdmin)
register(models.SQLFunc, SQLFuncAdmin)
register(models.SQLRecord, SQLRecordAdmin)
register(models.DownloadRecord, DownloadRecordAdmin)
