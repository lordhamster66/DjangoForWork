#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/10/12
from datetime import datetime, timedelta


def get_date_list(start_date, end_date):
    """
    获取日期列表
    :param start_date: 起始日期
    :param end_date: 终止日期
    :return: 返回日期列表
    """
    date_list = []  # 存放日期的列表
    a = datetime.timestamp(datetime.strptime(start_date, "%Y-%m-%d"))
    b = datetime.timestamp(datetime.strptime(end_date, "%Y-%m-%d"))
    if a > b:
        return "起始日期不能大于终止日期"
    # 以下为生成起始和终止时间之间的所有日期
    while True:
        if start_date == end_date:  # 如果起始日期和终止日期碰头，则结束循环
            date_list.append(end_date)
            break
        date_list.append(start_date)
        start_date = datetime.strptime(start_date, "%Y-%m-%d") + timedelta(1)
        start_date = datetime.strftime(start_date, "%Y-%m-%d")
    return date_list
