#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/11
from datetime import date
from django import template
from django.utils.safestring import mark_safe
from django.utils.timezone import datetime, timedelta
from django.core.exceptions import FieldDoesNotExist

register = template.Library()


def get_condition_str(condition_dict):
    """拼接过滤条件"""
    condition_str = ""
    for k, v in condition_dict.items():
        condition_str += "&%s=%s" % (k, v)
    return condition_str


@register.simple_tag
def render_table_name(admin_class):
    """返回表名"""
    return admin_class.model._meta.verbose_name_plural


@register.simple_tag
def get_column_name(admin_class, column):
    """返回字段的名称"""
    return admin_class.model._meta.get_field(column).verbose_name


@register.simple_tag
def get_table_thead(admin_class, column, orderby_dict, condition_dict, search_content):
    """获取表头的中文名称"""
    condition_str = get_condition_str(condition_dict)  # 获取过滤条件
    th_ele = ""  # 要返回的thHTML
    orderby_key = column  # 要排序的key,默认就是字段名称
    sorte_icon = ""  # 排序标识(向上和向下的箭头)
    try:
        column_name = get_column_name(admin_class, column)  # 每列的名称，如果类中有定义中文名称则显示中文名称
        if column in orderby_dict:  # 如果column在排序字典中，则其上次进行了排序，这次则获取下次的排序关键字
            orderby_key = orderby_dict[column]  # 下次的排序关键字存在后端返回的排序字典中
            if orderby_key.startswith("-"):  # 下次是降序排列，则本次为升序，箭头应朝上
                sorte_icon = '<i class="fa fa-sort-up" aria-hidden="true"></i>'
            else:
                sorte_icon = '<i class="fa fa-sort-desc" aria-hidden="true"></i>'
        th_ele += '<th><a href="?o=%s%s&_q=%s">%s</a>%s</th>' % (
            orderby_key, condition_str, search_content, column_name, sorte_icon
        )
    except FieldDoesNotExist as e:
        column_name = column
        if hasattr(admin_class, column):
            func = getattr(admin_class, column)
            if hasattr(func, "display_name"):
                column_name = func.display_name
        th_ele += '<th><a href="javascript:void(0);">%s</a></th>' % column_name
    return mark_safe(th_ele)


@register.simple_tag
def get_table_rows(request, obj, admin_class):
    """根据admin配置显示表中的每行"""
    td_ele = ""
    for index, column in enumerate(admin_class.list_display):
        try:
            field_obj = obj._meta.get_field(column)
            if field_obj.choices:
                column_data = getattr(obj, "get_%s_display" % column)()
            else:
                column_data = getattr(obj, column)
            if isinstance(column_data, datetime):
                column_data = column_data.strftime("%Y-%m-%d %H:%M:%S")
            if isinstance(column_data, date):
                column_data = column_data.strftime("%Y-%m-%d")
            if index == 0:  # 表示是第一列，加上跳转至修改页面的a标签
                column_data = '<a href="{request_path}{obj_id}/change/">{column_data}</a>'.format(
                    request_path=request.path,
                    obj_id=getattr(obj, admin_class.model._meta.auto_field.name),
                    column_data=column_data,
                )
        except FieldDoesNotExist as e:
            column_data = column
            admin_class.instance = obj  # 在admin_class里封装实例对象
            admin_class.request = request  # 在admin_class里封装请求内容
            if hasattr(admin_class, column):
                column_data = getattr(admin_class, column)()
        td_ele += "<td>%s</td>" % column_data
    return mark_safe(td_ele)


@register.simple_tag
def get_page_ele(query_sets, condition_dict, orderby_dict, search_content):
    """生成想要显示的分页标签"""
    condition_str = get_condition_str(condition_dict)  # 过滤条件
    page_ele = ""  # 要返回的分页HTML
    current_orderby_key = orderby_dict.get("current_orderby_key", "")  # 获取本次的排序关键字
    # 上一页
    if query_sets.has_previous():
        page_ele += '''<li><a href="?page=%s%s&o=%s&_q=%s">«</a></li>''' % (
            query_sets.previous_page_number(), condition_str, current_orderby_key, search_content
        )
    else:
        page_ele += '''<li><a href="#">«</a></li>'''
    # 显示的页数
    for loop_num in query_sets.paginator.page_range:
        if loop_num < 3 or loop_num > query_sets.paginator.num_pages - 2 or abs(
                        loop_num - query_sets.number) < 2:  # 最前2页和最后两页以及当前页及当前页前后两页
            actived = ""
            if loop_num == query_sets.number:  # 如果是当前页则激活
                actived = "active"
            page_ele += '''<li class="%s"><a href="?page=%s%s&o=%s&_q=%s">%s</a></li>''' % (
                actived, loop_num, condition_str, current_orderby_key, search_content, loop_num
            )
        elif abs(loop_num - query_sets.number) == 2:
            page_ele += '''<li><a>...</a></li>'''
    # 下一页
    if query_sets.has_next():
        page_ele += '''<li><a href="?page=%s%s&o=%s&_q=%s">»</a></li>''' % (
            query_sets.next_page_number(), condition_str, current_orderby_key, search_content
        )
    else:
        page_ele += '''<li><a href="#">»</a></li>'''
    return mark_safe(page_ele)


@register.simple_tag
def get_condition_ele(filter_field, admin_class, condition_dict):
    """
    生成过滤select
    :param filter_field: 要过滤的字段
    :param admin_class:
    :param condition_dict: 过滤条件
    :return:
    """
    condition_ele = '''<select class="form-control" name={filter_field}>'''
    field_obj = admin_class.model._meta.get_field(filter_field)  # 过滤字段对象
    if type(field_obj).__name__ in ["DateTimeField", "DateField"]:
        filter_field = "%s__gte" % filter_field
        today = datetime.now().date()
        choices = [
            ('', '---------'),
            (today, '今天'),
            (today - timedelta(days=1), '昨天至今天'),
            (today - timedelta(days=7), '近7天'),
            (today.replace(day=1), '本月'),
            (today - timedelta(days=30), '近30天'),
            (today - timedelta(days=90), '近90天'),
            (today.replace(month=1, day=1), '本年'),
            (today - timedelta(days=180), '近180天'),
            (today - timedelta(days=365), '近365天'),
        ]
    else:
        choices = field_obj.get_choices()  # 过滤选项
    for choices_data in choices:
        selected = ""
        if condition_dict.get(filter_field) == str(choices_data[0]):
            selected = "selected"
        condition_ele += '''<option value="%s" %s>%s</option>''' % (choices_data[0], selected, choices_data[1])
    condition_ele += '''</select>'''
    condition_ele = condition_ele.format(filter_field=filter_field)
    return mark_safe(condition_ele)


@register.simple_tag
def render_action_display_name(admin_class, action):
    """显示动作的昵称"""
    action_name = action  # 默认动作名称即为动作函数名
    if hasattr(admin_class, action):
        action_func = getattr(admin_class, action)
        if hasattr(action_func, "display_name"):
            action_name = action_func.display_name  # 有昵称的话则显示动作昵称
    return action_name


@register.simple_tag
def show_dir(arg):
    print(dir(arg))


@register.simple_tag
def get_m2m_available_objs(admin_class, field_name, model_form_obj):
    """获取所有多对多的对象"""
    m2m_available_objs = []  # 要返回的待选对象
    obj = model_form_obj.instance  # 要修改的对象或者为空
    try:
        field_obj = getattr(obj, field_name)  # 获取多对多字段对象
        m2m_chosen_objs = field_obj.all()
    except Exception as e:
        m2m_chosen_objs = []
    m2m = getattr(admin_class.model, field_name)
    m2m_objs = m2m.rel.to.objects.all()
    for i in m2m_objs:
        if i not in m2m_chosen_objs:
            m2m_available_objs.append(i)
    return m2m_available_objs


@register.simple_tag
def get_m2m_chosen_objs(model_form_obj, field_name):
    """获取已经选择的多对多对象"""
    obj = model_form_obj.instance
    try:
        field_obj = getattr(obj, field_name)
        m2m_chosen_objs = field_obj.all()
    except Exception as e:
        m2m_chosen_objs = []
    return m2m_chosen_objs


@register.simple_tag
def render_related_objs(objs):
    """展示有关联的对象"""
    ul_ele = "<ul>"
    for obj in objs:
        li_ele = '''<li><span class='btn-link'> %s:</span> %s </li>''' % (
            obj._meta.verbose_name, obj.__str__().strip("<>"))
        ul_ele += li_ele
        for related_obj in obj._meta.related_objects:  # 找出关联的对象
            if hasattr(obj, related_obj.get_accessor_name()):
                accessor_obj = getattr(obj, related_obj.get_accessor_name())
                if hasattr(accessor_obj, 'select_related'):
                    target_objs = accessor_obj.select_related()
                    if 'ManyToManyRel' in related_obj.__repr__():  # 如果是间接的m2m关系则直接列出关联的对象，不需要再进行递归查找
                        sub_ul_ele = "<ul>"
                        for o in target_objs:
                            li_ele = '''<li> <span class='btn-link'>%s</span>: %s </li>''' % (
                                o._meta.verbose_name, o.__str__().strip("<>"))
                            sub_ul_ele += li_ele
                        sub_ul_ele += "</ul>"
                        ul_ele += sub_ul_ele
                        continue  # 无需再进行递归
                else:
                    target_objs = [accessor_obj]
                if len(target_objs) > 0:
                    nodes = render_related_objs(target_objs)
                    ul_ele += nodes

        for m2m_field in obj._meta.local_many_to_many:  # 把所有跟这个对象直接关联的m2m字段取出来
            sub_ul_ele = "<ul>"
            m2m_field_obj = getattr(obj, m2m_field.name)  # getattr(customer, 'tags')
            for o in m2m_field_obj.select_related():  # customer.tags.select_related()
                li_ele = '''<li> %s: %s </li>''' % (m2m_field.verbose_name, o.__str__().strip("<>"))
                sub_ul_ele += li_ele
            sub_ul_ele += "</ul>"
            ul_ele += sub_ul_ele  # 最终跟最外层的ul相拼接

    ul_ele += "</ul>"
    return mark_safe(ul_ele)


@register.simple_tag
def get_field_error(model_form_obj, field):
    """
    获取model_form字段对应的错误
    :param model_form_obj: model_form对象
    :param field: 字段
    :return:
    """
    field_name = field.name  # 字段名
    return model_form_obj[field_name].errors  # 返回字段名对应的错误


@register.simple_tag
def get_all_error(model_form_obj):
    """获取__all__下面的错误信息"""
    return model_form_obj.errors.get("__all__", "")


@register.simple_tag
def foreignKey_add_button(admin_class, field):
    """
    如果是外键则加上添加按钮
    :param admin_class:
    :param field: 字段
    :return:
    """
    btn_ele = ""
    field_name = field.name  # 字段名
    field_obj = admin_class.model._meta.get_field(field_name)  # 字段对象
    if type(field_obj).__name__ in ["ForeignKey", "ManyToManyField"]:  # todo OneToOneField
        btn_ele += "<a href='/kind_admin/%s/%s/add/' class='btn btn-success btn-xs btn-rounded' target='_blank' style='display:inline-block;margin-top:4px;'><i class='fa fa-plus' aria-hidden='true'></i>添加</a>" % (
            admin_class.model._meta.app_label,
            field_obj.related_model._meta.model_name
        )
    return mark_safe(btn_ele)
