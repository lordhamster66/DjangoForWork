#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/12/22
import json
from django.http import HttpResponse
from channels.handler import AsgiHandler

message_dict = {}  # 存储用户连上来的message


# message.reply_channel    一个客户端通道的对象
# message.reply_channel.send(chunk)  用来唯一返回这个客户端
# 一个管道大概会持续30s

# 当连接上时，发回去一个connect字符串
def ws_connect(message):
    message.reply_channel.send({"accept": "ok!"})


# 将发来的信息原样返回
def ws_message(message):
    """将发来的信息原样返回"""
    message_dict[message["text"]] = message
    # t = threading.Thread(target=receive, args=(message,))  # 用户连接服务器则启动一个线程用来监测rabbitmq
    # t.start()  # 启动线程


# 断开连接时发送一个disconnect字符串，当然，他已经收不到了
def ws_disconnect(message):
    message.reply_channel.send({"disconnect": "disconnect"})
