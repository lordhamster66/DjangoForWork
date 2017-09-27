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


class LoginForm(Form):
    """登录验证FORM"""
    username = fields.CharField(
        label="用户名：",
        widget=widgets.TextInput(attrs={"id": "username", "class": "form-control", "placeholder": "请输入用户名"}),
        error_messages={"required": "用户名不能为空！"}
    )

    pwd = fields.CharField(
        label="密码：",
        widget=widgets.PasswordInput(attrs={"id": "pwd", "class": "form-control", "placeholder": "请输入密码"}),
        error_messages={"required": "密码不能为空！"}
    )

    check_code = fields.CharField(
        label="验证码：",
        widget=widgets.TextInput(attrs={"id": "check_code", "class": "form-control", "placeholder": "请输入验证码"}),
        error_messages={"required": "验证码不能为空！"}
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

    def clean(self):
        """整体验证"""
        username = self.cleaned_data.get("username")  # 获取用户输入的用户名
        pwd = self.cleaned_data.get("pwd")  # 获取用户输入的密码
        if username:
            m_obj = hashlib.md5()  # 获取一个加密对象
            m_obj.update(pwd.encode())  # 加密密码
            password = m_obj.hexdigest()  # 获取加密的密码
            obj = models.User.objects.filter(username=username).first()  # 获取用户对象
            if password != obj.pwd:  # 检测密码输入是否正确
                self.add_error("pwd", "密码错误!")
        return self.cleaned_data


class RegisterForm(Form):
    """注册验证FORM"""
    username = fields.CharField(
        label="用户名：",
        widget=widgets.TextInput(attrs={"id": "username", "class": "form-control", "placeholder": "请输入用户名"}),
        error_messages={"required": "用户名不能为空！"}
    )

    pwd = fields.CharField(
        label="密码：",
        widget=widgets.PasswordInput(attrs={"id": "pwd", "class": "form-control", "placeholder": "请输入密码"}),
        error_messages={"required": "密码不能为空！"}
    )

    pwd_again = fields.CharField(
        label="确认密码：",
        widget=widgets.PasswordInput(
            attrs={"id": "pwd_again", "class": "form-control", "placeholder": "请重新输入密码"}
        ),
        error_messages={"required": "确认密码不能为空！"}
    )

    qq = fields.IntegerField(
        label="QQ：",
        widget=widgets.TextInput(attrs={"id": "qq", "class": "form-control", "placeholder": "请输入QQ号"}),
        error_messages={"required": "QQ号不能为空！", "invalid": "QQ号必须为数字!"}
    )

    check_code = fields.CharField(
        label="验证码：",
        widget=widgets.TextInput(attrs={"id": "check_code", "class": "form-control", "placeholder": "请输入验证码"}),
        error_messages={"required": "验证码不能为空！"}
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

    def clean(self):
        """检测整体"""
        pwd = self.cleaned_data.get("pwd")
        pwd_again = self.cleaned_data.get("pwd_again")
        if pwd != pwd_again:
            self.add_error("pwd_again", "两次密码不一样")
        return self.cleaned_data


class UserForm(Form):
    """个人信息修改"""
    username = fields.CharField(
        label="用户名：",
        widget=widgets.TextInput(attrs={
            "class": "form-control",
            "id": "username",
            "placeholder": "请输入昵称"
        }),
        error_messages={"required": "用户名不能为空！"}
    )

    qq = fields.IntegerField(
        label="QQ：",
        widget=widgets.TextInput(attrs={"id": "qq", "class": "form-control", "placeholder": "请输入QQ号"}),
        error_messages={"required": "QQ号不能为空！", "invalid": "QQ号必须为数字!"}
    )


class SmStForm(Form):
    """实名首投查询"""
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

    qudao_name = fields.ChoiceField(
        choices=[],
        widget=widgets.Select()
    )

    data_type = fields.ChoiceField(
        choices=[("1", "实名"), ("2", "首投")],
        widget=widgets.Select()
    )

    def __init__(self, *args, **kwargs):
        super(SmStForm, self).__init__(*args, **kwargs)
        self.fields['qudao_name'].choices = models.TgQudaoName.objects.using("default").values_list("id", "name")
