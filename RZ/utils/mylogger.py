#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/7
"""
日志处理模块
"""
import logging


class Mylogger(object):
    """自定义日志类"""

    def __init__(self, logpath, log_type, log_level):
        # 创建日志对象
        self.logger = logging.getLogger(log_type)
        self.logger.setLevel(log_level["global_level"])

        # 创建一个屏幕输出handler
        ch = logging.StreamHandler()
        ch.setLevel(log_level["ch_level"])

        # 创建一个文件输出handler
        fh = logging.FileHandler(logpath, encoding="utf-8")
        fh.setLevel(log_level["fh_level"])

        # 设置输出格式
        ch_formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s'
                                         , datefmt='%m/%d/%Y %I:%M:%S %p')
        fh_formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(module)s - %(lineno)d:  %(message)s')

        # 绑定输出格式
        ch.setFormatter(ch_formatter)
        fh.setFormatter(fh_formatter)

        # 绑定handler
        self.logger.addHandler(ch)
        self.logger.addHandler(fh)

    def get_logger(self):
        """获取日志对象"""
        return self.logger
