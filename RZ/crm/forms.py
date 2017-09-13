#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/8/29
import hashlib
from django.forms import Form
from django.forms import fields
from django.forms import widgets
from django.forms import RegexField
from crm import models
from django.core.exceptions import ValidationError
from datetime import datetime


class DailyForm(Form):
    qdate = fields.DateField(
        widget=widgets.TextInput(attrs={"class": "datepicker right search"}),
        error_messages={
            "required": "日期不能为空!",
            "invalid": "请输入正确的日期格式!"
        }
    )


class LoginForm(Form):
    """登录验证FORM"""
    username = fields.CharField(
        label="用户名：",
        widget=widgets.TextInput(attrs={"id": "u", "class": "inputstyle"}),
        error_messages={"required": "用户名不能为空！"}
    )

    pwd = fields.CharField(
        label="密码：",
        widget=widgets.PasswordInput(attrs={"id": "p", "class": "inputstyle"}),
        error_messages={"required": "密码不能为空！"}
    )

    remember = fields.CharField(
        required=False,
        widget=widgets.CheckboxInput()
    )

    def clean_username(self):
        """检查用户输入的用户名"""
        username = self.cleaned_data.get("username")
        obj = models.User.objects.filter(username=username).first()
        if not obj:
            raise ValidationError("用户不存在！", "invalid")
        return username

    def clean_pwd(self):
        username = self.cleaned_data.get("username")
        pwd = self.cleaned_data.get("pwd")
        if username:
            m_obj = hashlib.md5()
            m_obj.update(pwd.encode())
            password = m_obj.hexdigest()
            obj = models.User.objects.filter(username=username).first()
            if password != obj.pwd:
                raise ValidationError("密码错误！", "invalid")
        return pwd


class RegisterForm(Form):
    """注册验证FORM"""
    username = fields.CharField(
        label="用户名：",
        widget=widgets.TextInput(attrs={"id": "user", "class": "inputstyle2", "maxlength": "16"}),
        error_messages={"required": "用户名不能为空！"}
    )

    pwd = fields.CharField(
        label="密码：",
        widget=widgets.PasswordInput(attrs={"id": "passwd", "class": "inputstyle2", "maxlength": "16"}),
        error_messages={"required": "密码不能为空！"}
    )

    pwd_again = fields.CharField(
        label="确认密码：",
        widget=widgets.PasswordInput(attrs={"id": "passwd2", "class": "inputstyle2", "maxlength": "16"}),
        error_messages={"required": "确认密码不能为空！"}
    )

    qq = fields.IntegerField(
        label="QQ：",
        widget=widgets.TextInput(attrs={"id": "qq", "class": "inputstyle2", "maxlength": "10"}),
        error_messages={"required": "QQ号不能为空！", "invalid": "QQ号必须为数字!"}
    )

    def clean_username(self):
        """检测用户输入的用户名"""
        username = self.cleaned_data.get("username")
        user_obj = models.User.objects.filter(username=username).first()
        if user_obj:
            raise ValidationError("用户名已经存在！", "invalid")
        return username

    def clean_qq(self):
        """检测用户输入的qq号"""
        qq = self.cleaned_data.get("qq")
        user_obj = models.User.objects.filter(qq=qq).first()
        if user_obj:
            raise ValidationError("qq号已经存在！", "invalid")
        return qq

    def clean_pwd_again(self):
        """检测用户输入的密码"""
        pwd = self.cleaned_data.get("pwd")
        pwd_again = self.cleaned_data.get("pwd_again")
        if pwd != pwd_again:
            raise ValidationError("两次输入的密码不一样！", "invalid")
        return pwd_again
