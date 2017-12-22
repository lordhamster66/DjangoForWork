#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/12/22

import os
import channels.asgi

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "RzAdmin.settings")  # 这里填的是你的配置文件settings.py的位置
channel_layer = channels.asgi.get_channel_layer()
