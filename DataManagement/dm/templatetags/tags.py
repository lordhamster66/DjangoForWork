#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/14
from datetime import datetime, date
from django import template
from django.utils.safestring import mark_safe

register = template.Library()


def get_condition_str(condition_dict):
    """拼接过滤条件"""
    condition_str = ""
    for k, v in condition_dict.items():
        condition_str += "&%s=%s" % (k, v)
    return condition_str


@register.simple_tag
def get_table_thead(admin_class, column):
    """获取表头的中文名称"""
    return admin_class.model._meta.get_field(column).verbose_name


@register.simple_tag
def get_head_name(admin_class, order_by_dict, condition_dict):
    """获取表头"""
    th_ele = ""
    condition_str = get_condition_str(condition_dict)
    for field in admin_class.list_display:
        if field in order_by_dict:
            order_by_key = order_by_dict.get(field)
            if order_by_key.startswith("-"):
                sort_icon = '''<i class="fa fa-sort-up" aria-hidden="true"></i>'''
            else:
                sort_icon = '''<i class="fa fa-sort-desc" aria-hidden="true"></i>'''
        else:
            order_by_key = field
            sort_icon = ''
        th_ele += '<th><a href="?o=%s%s">%s</a> %s</th>' % (
            order_by_key,
            condition_str,
            admin_class.model._meta.get_field(field).verbose_name,
            sort_icon
        )
    return mark_safe(th_ele)


@register.simple_tag
def get_table_rows(obj, admin_class):
    """获取表中的每行"""
    td_ele = ""
    unadd_url = True
    for field in admin_class.list_display:
        field_obj = obj._meta.get_field(field)  # 获取字段对象
        if field_obj.choices:
            column_data = getattr(obj, "get_%s_display" % field)()
        else:
            column_data = getattr(obj, field)
        if isinstance(column_data, datetime):
            column_data = column_data.strftime("%Y-%m-%d %H:%M:%S")
        if isinstance(column_data, date):
            column_data = column_data.strftime("%Y-%m-%d")
        if unadd_url:
            auto_field_data = getattr(obj, admin_class.model._meta.auto_field.name)
            td_ele += '<td><a href="/dm/edit_sql/%s/">%s</a></td>' % (auto_field_data, column_data)
            unadd_url = False  # 加上了URL
        else:
            td_ele += '<td>%s</td>' % column_data
    return mark_safe(td_ele)


@register.simple_tag
def get_page_ele(query_sets, condition_dict, order_by_dict, search_content):
    """生成想要显示的分页标签"""
    page_ele = ""  # 要返回的分页HTML
    condition_str = get_condition_str(condition_dict)
    # 上一页
    if query_sets.has_previous():
        page_ele += '''<li><a href="?page=%s%s&o=%s&_q=%s">«</a></li>''' % (
            query_sets.previous_page_number(), condition_str, order_by_dict.get("current_order_by_key", ""),
            search_content
        )
    else:
        page_ele += '''<li><a href="#">«</a></li>'''
    # 显示的页数
    for loop_num in query_sets.paginator.page_range:
        if loop_num < 3 or loop_num > query_sets.paginator.num_pages - 2 or abs(
                        loop_num - query_sets.number) < 2:  # 最前2页和最后两页以及当前页及当前页前后两页
            actived = ""
            if loop_num == query_sets.number:
                actived = "active"
            page_ele += '''<li class="%s"><a href="?page=%s%s&o=%s&_q=%s">%s</a></li>''' % (
                actived, loop_num, condition_str, order_by_dict.get("current_order_by_key", ""), search_content,
                loop_num
            )
        elif abs(loop_num - query_sets.number) == 2:
            page_ele += '''<li><a>...</a></li>'''
    # 下一页
    if query_sets.has_next():
        page_ele += '''<li><a href="?page=%s%s&o=%s&_q=%s">»</a></li>''' % (
            query_sets.next_page_number(), condition_str, order_by_dict.get("current_order_by_key", ""), search_content
        )
    else:
        page_ele += '''<li><a href="#">»</a></li>'''
    return mark_safe(page_ele)


@register.simple_tag
def get_condition_ele(condition, admin_class, condition_dict):
    """生成过滤select"""
    condition_ele = '''<select class="form-control" name=%s>''' % condition
    field_obj = admin_class.model._meta.get_field(condition)
    choices = field_obj.get_choices()
    for choices_data in choices:
        selected = ""
        if condition_dict.get(condition) == str(choices_data[0]):
            selected = "selected"
        condition_ele += '''<option value="%s" %s>%s</option>''' % (choices_data[0], selected, choices_data[1])
    condition_ele += '''</select>'''
    return mark_safe(condition_ele)
