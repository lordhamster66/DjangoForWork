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
