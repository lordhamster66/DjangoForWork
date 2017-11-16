#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/16
from django.forms import Form
from django.forms import fields
from django.forms import widgets


class CheckDetailForm(Form):
    """查看明细form"""
    start_time = fields.DateField(
        widget=widgets.TextInput(attrs={
            "class": "datepicker form-control",
            "id": "start_time",
            "placeholder": "起始日期"
        }),
        error_messages={
            "required": "日期不能为空!",
            "invalid": "请输入正确的日期格式!"
        }
    )

    end_time = fields.DateField(
        widget=widgets.TextInput(attrs={
            "class": "datepicker form-control",
            "id": "end_time",
            "placeholder": "终止日期"
        }),
        error_messages={
            "required": "日期不能为空!",
            "invalid": "请输入正确的日期格式!"
        }
    )

    qudao_name = fields.CharField(
        required=False,
        widget=widgets.TextInput(attrs={
            "class": "form-control",
            "id": "qudao-name",
            "placeholder": "请输入渠道名称"
        })
    )

    data_type = fields.ChoiceField(
        choices=[(23, "注册明细"), (25, "实名明细"), (26, "首投明细")],
        widget=widgets.Select(attrs={"class": "form-control"})
    )
