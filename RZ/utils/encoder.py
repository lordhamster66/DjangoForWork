#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/10
"""自定义序列化模块"""
import json
from decimal import Decimal
from datetime import date
from datetime import datetime
from django.core.exceptions import ValidationError


class JsonCustomEncoder(json.JSONEncoder):
    def default(self, field):
        if isinstance(field, ValidationError):
            return {"code": field.code, "messages": field.messages}
        elif isinstance(field, datetime):
            return field.strftime('%Y-%m-%d %H:%M:%S')
        elif isinstance(field, date):
            return field.strftime('%Y-%m-%d')
        elif isinstance(field, Decimal):
            return str(float(field))
        else:
            return json.JSONEncoder.default(self, field)
