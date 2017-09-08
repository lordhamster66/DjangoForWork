#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/8/26
import math
from django.utils.safestring import mark_safe


class MyPageNation(object):
    """自定义分页插件"""

    def __init__(self, current_page, data_count, num_show=10, total_page_show=11):
        self.__current_page = current_page  # 当前页码
        self.__data_count = data_count  # 数据总个数
        self.__num_show = num_show  # 每页显示几行数据
        self.__total_page_show = total_page_show  # 页面总共显示几个页码

    @property
    def start(self):
        """获取数据起始位置"""
        return (self.__current_page - 1) * self.__num_show

    @property
    def end(self):
        """获取数据终止位置"""
        return self.__current_page * self.__num_show

    @property
    def page_count(self):
        """获取总页数"""
        return int(math.ceil(self.__data_count / self.__num_show))

    def page_str(self, base_url, username=None, qdate=None):
        page_list = []  # 存放html内容
        if self.page_count <= self.__total_page_show:  # 如果总页数小于要显示的页码
            start_index = 1
            end_index = self.page_count + 1
        else:
            if self.__current_page < int((self.__total_page_show + 1) / 2):  # 如果当前页在中间页之前
                start_index = 1
                end_index = self.__total_page_show + 1
            else:
                start_index = int(self.__current_page - (self.__total_page_show - 1) / 2)  # 获取起始位置
                # 如果当前页加上总长度的一半超过了总页码
                if self.__current_page + int((self.__total_page_show - 1) / 2) > self.page_count:
                    # 将最后的页码减去要显示的页码即得初始页码
                    start_index = int(self.page_count + 1 - self.__total_page_show)
                    end_index = self.page_count + 1  # 最后的页码不变
                else:
                    end_index = int(self.__current_page + (self.__total_page_show + 1) / 2)  # 获取终止位置
        if self.__current_page == 1:
            page_list.append('<a class="page" href="javascript:void(0);">上一页</a>')
        else:
            page_list.append(
                '<a class="page" href="%s?p=%s&u=%s&qdate=%s">上一页</a>' % (
                    base_url, self.__current_page - 1, username, qdate
                )
            )
        for i in range(start_index, end_index):
            if i == self.__current_page:
                page_list.append("<a class='page active' href='%s?p=%s&u=%s&qdate=%s'>%s</a>" % (
                    base_url, i, username, qdate, i
                ))
            else:
                page_list.append("<a class='page' href='%s?p=%s&u=%s&qdate=%s'>%s</a>" % (
                    base_url, i, username, qdate, i
                ))
        if self.__current_page == self.page_count:
            page_list.append('<a class="page" href="javascript:void(0);">下一页</a>')
        else:
            page_list.append(
                '<a class="page" href="%s?p=%s&u=%s&qdate=%s">下一页</a>' % (
                    base_url, self.__current_page + 1, username, qdate
                ))
        page_str = mark_safe("".join(page_list))
        return page_str
