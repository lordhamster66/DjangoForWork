#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/8/23
import time
import datetime
import urllib.request


def checktime(s):
    """
    自动运行脚本
    :param s: 要运行的时间点
    :return:
    """
    stp = time.mktime(time.strptime(s, '%Y-%m-%d %H:%M:%S'))
    while True:
        if time.time() - stp > 600:
            break
        time.sleep(1)


s = '2017-09-01 23:59:59'

while True:
    checktime(s)
    url = "http://10.1.12.12:8002/crm/data_storage/"
    request = urllib.request.Request(url=url)
    response = urllib.request.urlopen(request)
    content = response.read().decode('utf-8')  # 读取网页内容
    print(content)
    tmp = datetime.datetime.strptime(s, '%Y-%m-%d %H:%M:%S') + datetime.timedelta(1)  # 加一天
    s = str(tmp)
