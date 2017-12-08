#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/13
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.db.models import Q


def get_condition_dict(request):
    """获取GET请求的条件并返回字典的格式"""
    condition_dict = {}  # 过滤条件
    keywords = ["page", "o", "_q"]  # 保留关键字
    for k, v in request.GET.items():
        if k in keywords:
            continue
        elif v:
            condition_dict[k] = v
    return condition_dict


def get_paginator_query_sets(request, contact_list, list_per_page):
    """
    获取带分页对象的query_sets
    :param request:
    :param contact_list: query_sets
    :param list_per_page: 每页显示几条
    :return:
    """
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
    """
    对query_sets进行排序
    :param request:
    :param contact_list: 要进行排序的query_sets
    :return:
    """
    orderby_dict = {}  # 排序相关的字典
    orderby_key = request.GET.get("o", "")  # 排序关键字
    orderby_dict["current_orderby_key"] = orderby_key
    if orderby_key:
        orderby_field = orderby_key.strip("-")
        contact_list = contact_list.order_by(orderby_key)
        if orderby_key.startswith("-"):  # 如果此次是降序排列，则下次为升序排列
            orderby_dict[orderby_field] = orderby_field
        else:
            orderby_dict[orderby_field] = "-%s" % orderby_field
    return contact_list, orderby_dict


def query_sets_search(request, contact_list, admin_class):
    """查询并返回相关的query_sets"""
    search_content = request.GET.get("_q")  # 获取要查找的内容
    if search_content:  # 有查找内容才进行search操作
        q = Q()  # 生成一个Q对象
        q.connector = "OR"
        for search_field in admin_class.search_fields:
            q.children.append(("%s__contains" % search_field, search_content))
        contact_list = contact_list.filter(q)
    return contact_list


def count_related_objs(objs, related_count_dict):
    """计算关联对象个数"""
    for obj in objs:
        obj_name = obj._meta.verbose_name_plural  # 获取对象名称
        if obj_name in related_count_dict:  # 如果对象名称在对象统计字典里面，则统计值加1
            related_count_dict[obj_name] += 1
        else:  # 不在则默认为1
            related_count_dict[obj_name] = 1

        for related_obj in obj._meta.related_objects:  # 找出关联的对象
            if hasattr(obj, related_obj.get_accessor_name()):
                accessor_obj = getattr(obj, related_obj.get_accessor_name())
                if hasattr(accessor_obj, 'select_related'):
                    target_objs = accessor_obj.select_related()
                    if 'ManyToManyRel' in related_obj.__repr__():  # 如果是间接的m2m关系则直接列出关联的对象，不需要再进行递归查找
                        for o in target_objs:
                            o_name = o._meta.verbose_name_plural  # 获取对象名称
                            if o_name in related_count_dict:
                                related_count_dict[o_name] += 1
                            else:
                                related_count_dict[o_name] = 1
                        continue  # 无需再进行递归
                else:
                    target_objs = [accessor_obj]
                if len(target_objs) > 0:
                    count_related_objs(target_objs, related_count_dict)

        for m2m_field in obj._meta.local_many_to_many:  # 把所有跟这个对象直接关联的m2m字段取出来
            m2m_field_obj = getattr(obj, m2m_field.name)  # getattr(customer, 'tags')
            for o in m2m_field_obj.select_related():  # customer.tags.select_related()
                o_name = o._meta.verbose_name_plural  # 获取对象名称
                if o_name in related_count_dict:
                    related_count_dict[o_name] += 1
                else:
                    related_count_dict[o_name] = 1
    return related_count_dict
