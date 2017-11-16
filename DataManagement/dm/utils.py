#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/14
"""常用插件和函数"""
from django.db.models import Q
from django.db import connections
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from dm import models


def get_sql_content(id):
    """获取SQL内容"""
    return models.SQLRecord.objects.filter(id=id).first().sql_content.content


def get_qudao_sign(qudao_name):
    """获取渠道名称对应的渠道标识"""
    ret = {"status": False, "data": None}
    if qudao_name:
        qudao_sign_list = get_info_list(
            "rz",
            "SELECT sign from rzjf_bi.rzjf_qudao_name where name = '%s'" % qudao_name
        )
        if qudao_sign_list:  # 能获取到渠道名称对应的渠道标识
            qudao_sign_list = ["'%s'" % i["sign"] for i in qudao_sign_list]  # 以逗号分隔渠道标识
            ret["data"] = "and q.name in (%s)" % ",".join(qudao_sign_list)  # 重组渠道标识
            ret["status"] = True
    else:
        ret["status"] = True
        ret["data"] = ""
    return ret


def get_condition_dict(request):
    """获取过滤条件"""
    condition_dict = {}  # 过滤条件
    keywords = ["page", "o", "_q"]
    for k, v in request.GET.items():
        if k in keywords:  # 保留关键字
            continue
        elif v:
            condition_dict[k] = v
    return condition_dict


def query_sets_search(request, contact_list, admin_class):
    """查找功能"""
    search_content = request.GET.get("_q")  # 获取要查找的内容
    if search_content:  # 有查找内容才进行search操作
        q = Q()  # 生成一个Q对象
        q.connector = "OR"
        for search_field in admin_class.search_fields:
            q.children.append(("%s__contains" % search_field, search_content))
        contact_list = contact_list.filter(q)
    return contact_list


def get_query_sets(request, contact_list, list_per_page):
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


def query_sets_sort(request, contact_list, data_type="query_sets"):
    """对query_sets进行排序"""
    order_by_dict = {}  # 返回排序所需字典
    order_by_key = request.GET.get("o", "")  # 通过关键字o获取排序方式
    if order_by_key:
        order_by_field = order_by_key.strip("-")  # 获取要排序的字段
        if data_type == "query_sets":
            contact_list = contact_list.order_by(order_by_key)  # 获取排序好的query_sets
        else:  # 对于不是django自带query_sets对象的排序方式
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


def get_info_list(db_name, sql):
    """获取SQL执行结果"""
    cursor = connections[db_name].cursor()  # 获取一个游标
    cursor.execute(sql)  # 执行SQL
    data = cursor.fetchall()  # 获取所有结果
    col_names = [i[0] for i in cursor.description]  # 获取所有字段名
    info_list = [dict(zip(col_names, row)) for row in data]  # 拼接字段名和结果
    return info_list  # 返回查询结果
