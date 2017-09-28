#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/12
from django import template
from datetime import datetime

register = template.Library()  # 对象名必须为register


@register.simple_tag
def DailyDate(qdate):
    return datetime.strftime(qdate, "%Y年%m月%d")


@register.filter
def phone_filter(phone):
    """手机号中间四位隐藏"""
    return "%s%s%s" % (phone[0:3], "****", phone[7:])


@register.filter
def name_filter(name):
    """姓名后面几位隐藏"""
    return "%s%s" % (name[0:1], "*" * len(name[1:]))
