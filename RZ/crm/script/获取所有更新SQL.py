#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/8
import os
from RZ import settings
from crm import utils

sql_file_name_list = os.listdir(os.path.join(settings.BASE_DIR, "crm", "RzSql", "backup"))
for sql_file_name in sql_file_name_list:
    temp_sql = utils.sql_file_parser("backup", sql_file_name)  # 获取sql
    print(temp_sql)
