#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/13
from django.forms import Form
from django.forms import fields
from django.forms import widgets
from dm import models
from django.core.exceptions import ValidationError


class BaseSQLForm(Form):
    """基础SQL管理from"""
    sql_name = fields.CharField(
        widget=widgets.TextInput(attrs={"class": "form-control"}),
        error_messages={"required": "SQL名称不能为空！"},
    )

    department = fields.ChoiceField(
        required=False,
        choices=[],
        widget=widgets.Select(attrs={"class": "form-control"})
    )

    sql_tags = fields.MultipleChoiceField(
        required=False,
        choices=[],
        widget=widgets.SelectMultiple(attrs={"class": "form-control"})
    )

    content = fields.CharField(
        widget=widgets.Textarea(attrs={
            "id": "content",
            "class": "form-control",
            "cols": "100",
            "rows": "10",
            "style": "min-height: 200px;",
        }),
        error_messages={"required": "SQL内容不能为空！"},
    )

    def __init__(self, request, *args, **kwargs):
        super(BaseSQLForm, self).__init__(*args, **kwargs)
        department_choices = [("", "---------"), ]
        department_choices.extend(
            list(models.Department.objects.values_list("id", "name"))
        )
        self.fields['department'].choices = department_choices
        self.fields['sql_tags'].choices = models.SQLTag.objects.values_list("id", "name")
        self.request = request


class AddSQLForm(BaseSQLForm):
    """添加SQLform"""

    def clean_sql_name(self):
        """检测输入的sql名称"""
        sql_name = self.cleaned_data.pop("sql_name")
        if models.SQLRecord.objects.filter(sql_name=sql_name).count():
            raise ValidationError("SQL名称已经存在！", "invalid")
        return sql_name


class EditSQLForm(BaseSQLForm):
    """修改SQLform"""

    def clean_sql_name(self):
        """检测输入的sql名称"""
        sql_name = self.cleaned_data.pop("sql_name")
        sql_record_id = self.request.sql_record_id
        temp_obj = models.SQLRecord.objects.exclude(id=sql_record_id).filter(sql_name=sql_name).first()
        if temp_obj:
            raise ValidationError("SQL名称已经存在！", "invalid")
        return sql_name
