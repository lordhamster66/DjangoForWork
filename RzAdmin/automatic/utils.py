#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/12/9
import uuid
from django.db import connections
from automatic import models
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger


def create_id():
    """
    创建唯一标识
    :return: 返回唯一标识
    """
    return str(uuid.uuid1())


def get_info_list(db_name, sql):
    """获取SQL执行结果"""
    cursor = connections[db_name].cursor()  # 获取一个游标
    cursor.execute(sql)  # 执行SQL
    data = cursor.fetchall()  # 获取所有结果
    col_names = [i[0] for i in cursor.description]  # 获取所有字段名
    info_list = [dict(zip(col_names, row)) for row in data]  # 拼接字段名和结果
    return info_list  # 返回查询结果


def get_condition_dict(request):
    """获取查询条件"""
    condition_dict = {}
    keywords = ["o", "page", "download_record_id"]  # 保留关键字
    for k, v in request.GET.items():
        if k in keywords:
            continue
        else:
            condition_dict[k] = v
    return condition_dict


def get_contact_list(sql_record_obj, condition_dict):
    """获取查询结果"""
    func_name_list = [i.name for i in models.SQLFunc.objects.all()]
    for func_name in func_name_list:  # 确保format方法不报错
        if func_name not in condition_dict:
            condition_dict[func_name] = ""
    sql_record_content = sql_record_obj.content.format(**condition_dict)
    contact_list = get_info_list(sql_record_obj.get_db_name_display(), sql_record_content)
    return contact_list


def get_paginator_query_sets(request, contact_list, list_per_page):
    """获取封装分页功能的query_sets"""
    paginator = Paginator(contact_list, list_per_page)  # 获取分页对象
    page = request.GET.get('page')  # 获取当前页码
    try:
        query_sets = paginator.page(page)
    except PageNotAnInteger:
        # If page is not an integer, deliver first page.
        query_sets = paginator.page(1)
    except EmptyPage:
        # If page is out of range (e.g. 9999), deliver last page of results.
        query_sets = paginator.page(paginator.num_pages)
    return query_sets


def query_sets_sort(request, contact_list):
    """对query_sets进行排序"""
    order_by_dict = {}  # 返回排序所需字典
    order_by_key = request.GET.get("o", "")  # 通过关键字o获取排序方式
    if order_by_key:
        order_by_field = order_by_key.strip("-")  # 获取要排序的字段
        if order_by_key.startswith("-"):
            is_reverse = True
        else:
            is_reverse = False
        try:
            contact_list = sorted(contact_list, key=lambda i: i.get(order_by_field) or 0, reverse=is_reverse)
        except Exception:
            contact_list = sorted(contact_list, key=lambda i: str(i.get(order_by_field)) or '0', reverse=is_reverse)
        if order_by_key.startswith("-"):  # 表明此次是降序排列
            next_order_by_key = order_by_field  # 返回下次则是升序排列
        else:  # 表明此次是升序排列
            next_order_by_key = "-%s" % order_by_key  # 返回下次则是降序排列
        order_by_dict = {order_by_field: next_order_by_key, "current_order_by_key": order_by_key}
    return contact_list, order_by_dict
