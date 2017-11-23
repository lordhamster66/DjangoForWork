#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/13
import json
from django.shortcuts import render
from django.shortcuts import redirect
from django.shortcuts import HttpResponse
from dm.forms.manager_form import AddSQLForm, EditSQLForm
from dm import models
from django.db import transaction
from dm.myadmin import enabled_admin
from dm.utils import get_condition_dict, get_paginator_query_sets, query_sets_sort, query_sets_search, login_decorator


@login_decorator
def add_sql(request):
    """添加sql功能"""
    if request.method == "GET":
        add_sql_from = AddSQLForm(request=request)
        return render(request, "manager/add_sql.html", {
            "add_sql_from": add_sql_from
        })
    elif request.method == "POST":
        add_sql_from = AddSQLForm(request=request, data=request.POST)
        if add_sql_from.is_valid():
            with transaction.atomic():  # 开启事务
                sql_content = models.SQLContent.objects.create(content=add_sql_from.cleaned_data.pop("content"))
                sql_record = models.SQLRecord.objects.create(
                    user=request.user.userprofile,
                    sql_name=add_sql_from.cleaned_data.pop("sql_name"),
                    department_id=add_sql_from.cleaned_data.pop("department"),
                    sql_content_id=sql_content.id
                )
                sql_tags = add_sql_from.cleaned_data.pop("sql_tags")  # 获取用户选择的标签
                # 为该SQL记录添加标签
                sql_record.sql_tags.add(*[models.SQLTag.objects.filter(id=i).first() for i in sql_tags])
                sql_record.save()  # 存储该SQL记录
            return redirect("/dm/view_sql.html")
        else:
            return render(request, "manager/add_sql.html", {
                "add_sql_from": add_sql_from
            })


@login_decorator
def view_sql(request):
    """查看所有的SQL记录"""
    if request.method == "GET":
        condition_dict = get_condition_dict(request)  # 获取过滤条件
        # 获取admin_class
        admin_class = enabled_admin.get(models.SQLRecord._meta.app_label).get(models.SQLRecord._meta.model_name)
        contact_list = admin_class.model.objects.filter(**condition_dict)  # 获取过滤后的query_sets
        contact_list = query_sets_search(request, contact_list, admin_class)  # 获取search后的query_sets
        contact_list, order_by_dict = query_sets_sort(request, contact_list)  # 获取排序后的query_sets以及排序所要用到的字典
        query_sets = get_paginator_query_sets(request, contact_list, admin_class.list_per_page)  # 获取带分页功能的query_sets
        return render(request, "manager/view_sql.html", {
            "admin_class": admin_class,
            "query_sets": query_sets,
            "condition_dict": condition_dict,
            "order_by_dict": order_by_dict,
            "search_content": request.GET.get("_q", "")
        })


@login_decorator
def edit_sql(request, sql_record_id):
    """编辑SQL记录"""
    sql_record_obj = models.SQLRecord.objects.filter(id=sql_record_id).first()  # 要返回的sql_record对象
    edit_sql_from = None  # 要返回的form对象
    if request.method == "GET":
        edit_sql_from = EditSQLForm(request=request, initial={
            "sql_name": sql_record_obj.sql_name,
            "department": sql_record_obj.department_id,
            "sql_tags": [i.id for i in sql_record_obj.sql_tags.all()],
            "content": sql_record_obj.sql_content.content
        })
    elif request.method == "POST":
        request.sql_record_id = sql_record_id  # 将要编辑的SQL记录ID存入request
        edit_sql_from = EditSQLForm(request=request, data=request.POST)
        if edit_sql_from.is_valid():
            with transaction.atomic():
                sql_tags = edit_sql_from.cleaned_data.pop("sql_tags")
                sql_record_obj.sql_name = edit_sql_from.cleaned_data.pop("sql_name")  # 更新sql记录名称
                sql_record_obj.department_id = edit_sql_from.cleaned_data.pop("department")  # 更新sql记录对应部门
                models.SQLContent.objects.filter(id=sql_record_obj.sql_content.id).update(
                    content=edit_sql_from.cleaned_data.pop("content")
                )  # 更新sql内容
                sql_record_obj.sql_tags.clear()  # 先清空所有标签
                sql_record_obj.sql_tags.add(*[models.SQLTag.objects.filter(id=i).first() for i in sql_tags])
                sql_record_obj.save()
            return redirect("/dm/view_sql.html")
    return render(request, "manager/edit_sql.html", {
        "edit_sql_from": edit_sql_from,
        "sql_record_obj": sql_record_obj
    })


@login_decorator
def del_sql(request, sql_record_id):
    """删除sql记录"""
    ret = {"status": False, "errors": None, "data": None}
    if request.method == "POST":
        models.SQLRecord.objects.filter(id=sql_record_id).first().sql_content.delete()
        models.SQLRecord.objects.filter(id=sql_record_id).delete()
        ret["status"] = True
        return HttpResponse(json.dumps(ret))
