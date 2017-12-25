#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/12/13
import pika
import json
from RzAdmin import settings
from django.core.signals import request_finished  # 请求结束后
from django.core.signals import request_started  # 请求到来前
from django.core.signals import got_request_exception  # 请求异常后

from django.db.models.signals import class_prepared  # 程序启动时，检测已注册的app中的modal类，对于每一个类，自动触发
from django.db.models.signals import pre_init, post_init  # 构造方法前和构造方法后
from django.db.models.signals import pre_save, post_save  # 对象保存前和对象保存后
from django.db.models.signals import pre_delete, post_delete  # 对象删除前和对象删除后
from django.db.models.signals import m2m_changed  # 操作第三张表前后
from django.db.models.signals import pre_migrate, post_migrate  # 执行migrate命令前后

from django.test.signals import setting_changed  # 使用test测试修改配置文件时
from django.test.signals import template_rendered  # 使用test测试渲染模板时

from django.db.backends.signals import connection_created  # 创建数据库连接时

from RzAdmin.consumer import message_dict


def model_instance_save_callback(sender, **kwargs):
    """model对象保存时的回调函数"""
    from automatic import models
    if sender._meta.model_name == "downloadrecord":  # 说明有人在更新下载记录，即审核
        download_record_obj = kwargs.get("instance")  # 用户下载记录对象
        if kwargs.get("created"):  # 说明用户在创建下载记录
            mass_users = []  # 要群发的用户邮箱
            detaile_jurisdiction_role_objs = models.Role.objects.filter(name__in=settings.DetaileJurisdiction).all()
            for detaile_jurisdiction_role_obj in detaile_jurisdiction_role_objs:
                for user_obj in detaile_jurisdiction_role_obj.userprofile_set.all():
                    user_email = user_obj.email
                    if user_email in message_dict and user_email not in mass_users:
                        mass_users.append(user_obj.email)
            for user_email in mass_users:
                message = message_dict.get(user_email)
                if message:
                    message.reply_channel.send({
                        "text": json.dumps({
                            "title": download_record_obj.download_detail,
                            "message": "用户:%s,提交了新的下载审核，快去检查!" % download_record_obj.user.name,
                            "alert_type": "info"
                        })})
        else:
            message = message_dict.get(download_record_obj.user.email)  # 获取用户的websocket链接
            if message:
                message.reply_channel.send({
                    "text": json.dumps({
                        "title": download_record_obj.download_detail,
                        "message": "已有更新，请去用户中心查看!", "alert_type": "success"
                    })})


post_save.connect(model_instance_save_callback)
# xxoo指上述导入的内容
