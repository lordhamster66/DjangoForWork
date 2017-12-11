#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/12/9
from datetime import date
from django.utils.timezone import datetime
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
def get_page_ele(query_sets, condition_dict=None, order_by_dict=None):
    """生成想要显示的分页标签"""
    page_ele = ""  # 要返回的分页HTML
    condition_str = ""  # 过滤条件
    current_order_by_key = ""  # 排序条件
    if condition_dict:
        condition_str = get_condition_str(condition_dict)
    if order_by_dict:
        current_order_by_key = order_by_dict.get("current_order_by_key", "")
    # 上一页
    if query_sets.has_previous():
        page_ele += '''<li><a href="?page=%s%s&o=%s">«</a></li>''' % (
            query_sets.previous_page_number(), condition_str, current_order_by_key
        )
    else:
        page_ele += '''<li class="paginate_button disabled"><a href="javascript:void(0);">«</a></li>'''
    # 显示的页数
    for loop_num in query_sets.paginator.page_range:
        if loop_num < 3 or loop_num > query_sets.paginator.num_pages - 2 or abs(
                        loop_num - query_sets.number) < 2:  # 最前2页和最后两页以及当前页及当前页前后两页
            actived = ""
            if loop_num == query_sets.number:
                actived = "active"
            page_ele += '''<li class="%s"><a href="?page=%s%s&o=%s">%s</a></li>''' % (
                actived, loop_num, condition_str, current_order_by_key, loop_num
            )
        elif abs(loop_num - query_sets.number) == 2:
            page_ele += '''<li class="paginate_button disabled"><a>...</a></li>'''
    # 下一页
    if query_sets.has_next():
        page_ele += '''<li><a href="?page=%s%s&o=%s">»</a></li>''' % (
            query_sets.next_page_number(), condition_str, current_order_by_key
        )
    else:
        page_ele += '''<li class="paginate_button disabled"><a href="#">»</a></li>'''
    return mark_safe(page_ele)


@register.simple_tag
def get_table_rows(request, row):
    """获取表格每一行数据"""
    """
    {% for v in row.values %}
        <td>{{ v }}</td>
    {% endfor %}
    """
    td_ele = ""
    detaile_jurisdiction = ["数据组", "管理员"]  # 有详细信息查看权限的角色
    user_roles_list = [i.name for i in request.user.roles.all() if i.name in detaile_jurisdiction]
    for field, data in row.items():
        if isinstance(data, datetime):
            data = datetime.strftime(data, "%Y-%m-%d %H:%M:%S")
        if isinstance(data, date):
            data = date.strftime(data, "%Y-%m-%d")
        if len(user_roles_list) == 0:
            if field in ["姓名", "uname", "用户名", "un"]:
                data = "%s%s" % (data[:1], "*" * len(data[1:]))
            if field in ["手机", "手机号", "mobile"]:
                data = "%s%s%s" % (data[0:3], "****", data[7:])
            if field in ["身份证", "personid"]:
                data = "%s%s%s" % (data[0:5], "*" * 9, data[14:])
        td_ele += "<td style='white-space:nowrap'>%s</td>" % data
    return mark_safe(td_ele)


@register.simple_tag
def get_table_head(query_sets, condition_dict, order_by_dict):
    """查看详细页面的表头"""
    '''
    {% for field in query_sets.0.keys %}
        <th class="sorting">{{ field }}</th>
    {% endfor %}
    '''
    th_ele = ""
    condition_str = get_condition_str(condition_dict)
    if query_sets:
        for k in query_sets[0].keys():
            if k in order_by_dict:
                order_by_key = order_by_dict.get(k)
                if order_by_key.startswith("-"):
                    sort_class = "sorting_asc"
                else:
                    sort_class = "sorting_desc"
            else:
                order_by_key = k
                sort_class = "sorting"
            th_ele += '<th class="%s" style="white-space:nowrap"><a href="?o=%s%s">%s</a></th>' % (
                sort_class, order_by_key, condition_str, k
            )
    return mark_safe(th_ele)


@register.simple_tag
def render_download_option(request, sql_record_obj, condition_dict, order_by_dict):
    """展示下载EXCEL功能或者是提交下载审核功能"""
    detaile_jurisdiction = ["数据组", "管理员"]  # 有详细信息查看权限的角色
    user_roles_list = [i.name for i in request.user.roles.all() if i.name in detaile_jurisdiction]
    if len(user_roles_list) == 0:
        condition_str = "?o=%s" % order_by_dict.get("current_order_by_key", "") + get_condition_str(condition_dict)
        download_option_ele = """
                <a href="/automatic/download_excel/%s/%s" target="_blank"
                class="btn btn-success btn-rounded pull-right btn-lg" style="margin-top: 3px;">提交导出审核</a>
                """
    else:
        """<a class="btn btn-success btn-rounded pull-right btn-lg" style="margin-top: 3px;">导出EXCEL</a>"""
        condition_str = "?o=%s" % order_by_dict.get("current_order_by_key", "") + get_condition_str(condition_dict)
        download_option_ele = """
        <a href="/automatic/download_excel/%s/%s" target="_blank"
        class="btn btn-success btn-rounded pull-right btn-lg" style="margin-top: 3px;">导出EXCEL</a>
        """ % (sql_record_obj.id, condition_str)
    return mark_safe(download_option_ele)
