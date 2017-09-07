#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/7
import os
from RZ import settings


def sql_file_parser(catalog, sql_name):
    """
    获取sql文件里面的sql内容
    :param catalog: sql目录
    :param sql_name: sql文件名称
    :return:
    """
    file_path = os.path.join(settings.BASE_DIR, "crm", "RzSql", catalog, sql_name)
    f = open(file_path, "r", encoding="utf-8")
    sql = f.read()
    f.close()
    return sql
