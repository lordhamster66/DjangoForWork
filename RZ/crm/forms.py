#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/8/29
from django.forms import Form
from django.forms import fields
from django.forms import widgets
from django.forms import RegexField


class DailyForm(Form):

    qdate = fields.DateField(
        error_messages={"required": "日期不能为空!"},
        widget=widgets.TextInput(attrs={"class": "datepicker right search"})
    )
