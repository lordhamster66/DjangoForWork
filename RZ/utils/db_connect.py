#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/27
import os
from RZ import settings
from django.db import connections


def get_info_list(db_name, base_dir, sql_dir, catalog, file_name):
    """
    执行sql语句并以列表的形式返回单行结果
    :param base_dir: 主目录名
    :param sql_dir: sql语句所在主目录名
    :param catalog: sql语句目录名
    :param file_name: sql文件名
    :return: 返回查询结果(列表形式)
    """
    file_path = os.path.join(settings.BASE_DIR, base_dir, sql_dir, catalog, file_name)
    f = open(file_path, "r", encoding="utf-8")
    sql = f.read()
    f.close()
    cursor = connections[db_name].cursor()
    cursor.execute(sql)
    data = cursor.fetchall()
    col_names = [i[0] for i in cursor.description]
    info_list = [dict(zip(col_names, row)) for row in data]
    return info_list
