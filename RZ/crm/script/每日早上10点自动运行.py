#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/8/29
import requests  # 爬虫专用
url1 = "http://10.1.12.12:9008/crm/get_wdzj_info/"
url2 = "http://10.1.12.12:9008/crm/get_wdty_info/"
# 通过访问第一个接口获取网贷之家数据并填入数据库
response1 = requests.get(url1, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64)"})
print(response1.content.decode())
# 通过访问第二个接口获取网贷天眼数据并填入数据库
response2 = requests.get(url2, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64)"})
print(response2.content.decode())
