#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/13
"""
网贷之家网贷天眼所属数据库表备份模块
"""
import os
from django.db import connections
from crm import utils  # 常用功能及一些工具或一些常用变量
from django.shortcuts import HttpResponse
from RZ import settings


def backup(request):
    """备份数据库表"""
    if request.method == "GET":
        """
            01u_0info_compay    11_auth             01u_0base   05b_0base           05b_0base_run
            05b_7dsbid          05b_1tenderfinal    rz_borrow   rz_loan_open_data   rz_borrow_tender
            rz_borrow_big       01u_0info           01u_0info   05b_1tenderdetail
            rz_borrow_tender_0 ~ rz_borrow_tender_31
        """
        cursor = connections['rz_bi'].cursor()  # 获取一个游标
        try:
            cursor.execute("start transaction;")  # 开启事务
            # 获取所有备份数据文件名称
            sql_file_name_list = os.listdir(os.path.join(settings.BASE_DIR, "crm", "RzSql", "backup"))
            # 获取所有更新数据文件名称
            updatesql_file_name_list = os.listdir(os.path.join(settings.BASE_DIR, "crm", "RzSql", "update"))

            # 插入数据
            for sql_file_name in sql_file_name_list:
                temp_sql = utils.sql_file_parser("backup", sql_file_name)  # 获取sql
                temp_ret = cursor.execute(temp_sql)  # 执行sql
                table_name = sql_file_name.replace(".sql", "")  # 获取表名
                settings.action_logger.info("%s插入了%s条数据!" % (table_name, temp_ret))  # 插入日志

            # 更新数据
            for sql_file_name in updatesql_file_name_list:
                temp_sql = utils.sql_file_parser("update", sql_file_name)  # 获取sql
                temp_ret = cursor.execute(temp_sql)  # 执行sql
                table_name = sql_file_name.replace(".sql", "")  # 获取表名
                settings.action_logger.info("%s更新了%s条数据!" % (table_name, temp_ret))  # 插入日志
        except Exception as e:
            settings.action_logger.info("数据备份出错了!%s" % e)
            cursor.execute("rollback;")
        else:
            cursor.execute("commit;")
        return HttpResponse("ok!")
