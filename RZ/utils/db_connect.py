#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/27
import os
from RZ import settings
from django.db import connections


def get_sql(base_dir, sql_dir, catalog, file_name):
    """
    获取sql语句
    :param base_dir: 主目录
    :param sql_dir: SQL文件主目录
    :param catalog: SQL分类目录
    :param file_name: SQL文件名
    :return:
    """
    file_path = os.path.join(settings.BASE_DIR, base_dir, sql_dir, catalog, file_name)
    f = open(file_path, "r", encoding="utf-8")
    sql = f.read()
    f.close()
    return sql


def get_info_list(db_name, sql):
    """
    执行sql语句并返回列表形式的结果
    :param db_name: 连接的库名，对应settings中的名字
    :param sql: sql语句
    :return:
    """
    cursor = connections[db_name].cursor()
    cursor.execute(sql)
    data = cursor.fetchall()
    col_names = [i[0] for i in cursor.description]
    info_list = [dict(zip(col_names, row)) for row in data]
    return info_list
