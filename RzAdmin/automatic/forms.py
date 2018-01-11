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
    @classmethod
    def list_per_page(cls):
        field = fields.ChoiceField(
            choices=(("10", "10"), ("25", "25"), ("50", "50"), ("100", "100")),
            widget=widgets.Select(attrs={
                "class": "form-control input-sm",
                "id": "list_per_page",
            })
        )
        return field

    @classmethod
    def search_q(cls):
        field = fields.IntegerField(
            required=False,
            label="uid和手机号检索",
            widget=widgets.TextInput(attrs={
                "class": "form-control",
                "id": "search_q",
                "placeholder": "可根据UID和手机号搜索"
            })
        )
        return field

    @classmethod
    def qudao_name(cls):
        field = fields.CharField(
            required=False,
            label="渠道名称",
            widget=widgets.TextInput(attrs={
                "class": "form-control",
                "id": "qudao-name",
                "autocomplete": "off",
                "placeholder": "请输入渠道名称"
            })
        )
        return field

    @classmethod
    def start_time(cls):
        field = fields.DateField(
            label="起始日期",
            widget=widgets.TextInput(attrs={
                "class": "form-control date-picker",
                "id": "start_time",
                "value": datetime.strftime(datetime.now() - timedelta(1), "%Y-%m-%d"),
                "placeholder": "起始日期"
            }),
            error_messages={
                "required": "日期不能为空!",
                "invalid": "请输入正确的日期格式!"
            }
        )
        return field

    @classmethod
    def end_time(cls):
        field = fields.DateField(
            label="终止日期",
            widget=widgets.TextInput(attrs={
                "class": "form-control date-picker",
                "id": "end_time",
                "value": datetime.strftime(datetime.now() - timedelta(1), "%Y-%m-%d"),
                "placeholder": "终止日期"
            }),
            error_messages={
                "required": "日期不能为空!",
                "invalid": "请输入正确的日期格式!"
            }
        )
        return field

    @classmethod
    def invite_user(cls):
        field = fields.CharField(
            required=False,
            label="邀请人",
            widget=widgets.TextInput(attrs={
                "class": "form-control",
                "id": "invite-user",
                "placeholder": "请输入邀请人ID或者手机号"
            })
        )
        return field

    @classmethod
    def invited_user(cls):
        field = fields.CharField(
            required=False,
            label="被邀请人",
            widget=widgets.TextInput(attrs={
                "class": "form-control",
                "id": "invited-user",
                "placeholder": "请输入被邀请人ID或者手机号"
            })
        )
        return field

    @staticmethod
    def get_uids(search_content):
        """返回搜索到的所有用户ID"""
        uids = ""
        if search_content:
            uid_list = get_info_list("rz", """SELECT uid from 01u_0info where uid = '{search_content}' UNION
                                                SELECT uid from 01u_0info where mobile = '{search_content}'""".format(
                search_content=search_content))
            if uid_list:
                uids = ",".join([str(i["uid"]) for i in uid_list if i])
        return uids

    def clean(self):
        if "invite_user" in self.cleaned_data.keys() or "invited_user" in self.cleaned_data.keys():
            invite_user = self.cleaned_data.get("invite_user")  # 用户输入的邀请人信息
            invited_user = self.cleaned_data.get("invited_user")  # 用户输入的被邀请人信息
            if not invite_user and not invited_user:
                self.add_error("__all__", "不能同时为空！")
            invite_user_uids = FunctionList.get_uids(invite_user)
            invited_user_uids = FunctionList.get_uids(invited_user)
            self.cleaned_data["invite_user"] = ""
            self.cleaned_data["invited_user"] = ""
            if invite_user:
                if invite_user_uids:
                    self.cleaned_data["invite_user"] = 'invite.uid in ("%s")' % invite_user_uids
                else:
                    self.add_error("invite_user", "该邀请用户不存在！")
            if invited_user:
                if invited_user_uids:
                    self.cleaned_data["invited_user"] = 'invited.uid in ("%s")' % invited_user_uids
                else:
                    self.add_error("invited_user", "该被邀请用户不存在！")
            if invite_user and invited_user:
                self.cleaned_data["invited_user"] = "and %s" % self.cleaned_data["invited_user"]
        return self.cleaned_data

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

    def __new__(cls, *args, **kwargs):
        cls.base_fields.get("list_per_page").initial = [sql_record_obj.list_per_page]  # 设置默认每页显示多少条
        return Form.__new__(cls)

    attrs = {
        "list_per_page": FunctionList.list_per_page(),
        "clean": FunctionList.clean,
        "__new__": __new__
    }  # 要生成的字段
    func_name_list = [i.name for i in sql_record_obj.funcs.all()]
    for func_name in func_name_list:
        if hasattr(FunctionList, func_name):
            func = getattr(FunctionList, func_name)
            attrs[func_name] = func()
            if hasattr(FunctionList, "clean_%s" % func_name):
                attrs["clean_%s" % func_name] = getattr(FunctionList, "clean_%s" % func_name)
    dynamic_form = type("DynamicTableForm", (Form,), attrs)
    return dynamic_form
