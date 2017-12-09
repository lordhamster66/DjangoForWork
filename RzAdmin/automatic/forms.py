#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/12/9
from django.forms import Form
from django.forms import fields
from django.forms import widgets
from django.utils.timezone import datetime, timedelta
from automatic.utils import get_info_list


class FunctionList(object):
    yesterday = datetime.strftime(datetime.now() - timedelta(1), "%Y-%m-%d")  # 获取昨天的日期
    list_per_page = fields.ChoiceField(
        choices=(("10", "10"), ("25", "25"), ("50", "50"), ("100", "100")),
        widget=widgets.Select(attrs={
            "class": "form-control input-sm",
            "id": "list_per_page",
        })
    )
    search_q = fields.IntegerField(
        required=False,
        widget=widgets.TextInput(attrs={
            "class": "form-control",
            "id": "search_q",
            "placeholder": "可根据UID和手机号搜索"
        })
    )
    qudao_name = fields.CharField(
        required=False,
        label="渠道名称",
        widget=widgets.TextInput(attrs={
            "class": "form-control",
            "id": "qudao-name",
            "autocomplete": "off",
            "placeholder": "请输入渠道名称"
        })
    )
    start_time = fields.DateField(
        label="起始日期",
        widget=widgets.TextInput(attrs={
            "class": "form-control date-picker",
            "id": "start_time",
            "value": yesterday,
            "placeholder": "起始日期"
        }),
        error_messages={
            "required": "日期不能为空!",
            "invalid": "请输入正确的日期格式!"
        }
    )
    end_time = fields.DateField(
        label="终止日期",
        widget=widgets.TextInput(attrs={
            "class": "form-control date-picker",
            "id": "end_time",
            "value": yesterday,
            "placeholder": "终止日期"
        }),
        error_messages={
            "required": "日期不能为空!",
            "invalid": "请输入正确的日期格式!"
        }
    )

    def clean_qudao_name(self):
        """验证渠道名称是否存在"""
        qudao_name = self.cleaned_data.pop("qudao_name", "")
        if qudao_name:
            qudao_sign_list = get_info_list(
                "rz",
                "SELECT sign from rzjf_bi.rzjf_qudao_name where name = '%s'" % qudao_name
            )
            if qudao_sign_list:  # 能获取到渠道名称对应的渠道标识
                qudao_sign_list = ["'%s'" % i["sign"] for i in qudao_sign_list]  # 以逗号分隔渠道标识
                qudao_name = "and q.name in (%s)" % ",".join(qudao_sign_list)  # 重组渠道标识
            else:
                self.add_error("qudao_name", "渠道名称不存在或者未添加！")
        else:
            qudao_name = ""
        return qudao_name

    def clean_search_q(self):
        """验证检索内容"""
        search_q = self.cleaned_data.pop("search_q", "")
        if search_q:
            uid_list = get_info_list("rz", """SELECT uid from 01u_0info where uid = '{search_content}' UNION
                                    SELECT uid from 01u_0info where mobile = '{search_content}'""".format(
                search_content=search_q))
            if uid_list:
                search_q = 'and info.uid in ("%s")' % ",".join([str(i["uid"]) for i in uid_list if i])
            else:
                self.add_error("search_q", "该用户不存在！")
        else:
            search_q = ""
        return search_q


def create_table_form(sql_record_obj):
    """动态生成table_form"""
    attrs = {"list_per_page": FunctionList.list_per_page}  # 要生成的字段
    func_name_list = [i.name for i in sql_record_obj.funcs.all()]
    for func_name in func_name_list:
        if hasattr(FunctionList, func_name):
            attrs[func_name] = getattr(FunctionList, func_name)
            if hasattr(FunctionList, "clean_%s" % func_name):
                attrs["clean_%s" % func_name] = getattr(FunctionList, "clean_%s" % func_name)
    dynamic_form = type("DynamicTableFomr", (Form,), attrs)
    return dynamic_form
