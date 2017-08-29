#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/8/29
import time
import datetime
import requests  # 爬虫专用


def checktime(s):
    """
    自动运行脚本
    :param s: 要运行的时间点
    :return:
    """
    stp = time.mktime(time.strptime(s, '%Y-%m-%d %H:%M:%S'))
    while True:
        if time.time() - stp > 0:
            break
        time.sleep(1)


s = '2017-08-30 09:00:00'

while True:
    checktime(s)
    url1 = "http://10.1.12.12:8002/crm/get_wdzj_info/"
    url2 = "http://10.1.12.12:8002/crm/get_wdty_info/"
    # 通过访问第一个接口获取网贷之家数据并填入数据库
    response1 = requests.get(url1, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64)"})
    print(response1.content.decode())
    # 通过访问第二个接口获取网贷天眼数据并填入数据库
    response2 = requests.get(url2, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64)"})
    print(response2.content.decode())
    tmp = datetime.datetime.strptime(s, '%Y-%m-%d %H:%M:%S') + datetime.timedelta(1)  # 加一天
    s = str(tmp)
