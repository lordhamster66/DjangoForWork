#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/10/25
import requests  # 爬虫专用

url = "http://10.1.12.12:9008/crm/rzjf_recorde/"
response1 = requests.get(url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64)"})
print(response1.content.decode())
