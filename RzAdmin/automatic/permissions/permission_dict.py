#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/12/21
import re

# url_type: 0 代表相对路径，1代表绝对路径, 2代表模糊路径使用正则进行匹配
PermissionDict = {
    # automatic项目权限
    # 可以访问自动化后台首页
    "automatic.can_access_automatic_index": {
        "url_type": 0,
        "url": "automatic_index",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以访问数据查询功能页
    "automatic.can_access_search_table_list": {
        "url_type": 0,  # 路径类型
        "url": "search_table_list",  # 路径名称,根据路径类型判断是绝对还是相对路径或者模糊路径
        "method": "GET",  # 请求方法
        "args": [],  # 请求参数
        "hooks": []  # 预留钩子,or 和 and 为关键字代表或和与的关系,只有此列表全为真才会通过验证
    },
    # 可以访问详细查询页面并查询数据
    "automatic.can_access_table_search_detail": {
        "url_type": 0,
        "url": "table_search_detail",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以查询渠道名称
    "automatic.can_search_channel_name": {
        "url_type": 0,
        "url": "search_channel_name",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以下载EXCEL
    "automatic.can_download_excel": {
        "url_type": 0,
        "url": "download_excel",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以访问用户中心
    "automatic.can_access_user_center": {
        "url_type": 0,
        "url": "user_center",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以访问下载审核页面
    "automatic.can_access_download_check": {
        "url_type": 0,
        "url": "download_check",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以提交下载审核
    "automatic.can_post_download_check": {
        "url_type": 0,
        "url": "download_check",
        "method": "POST",
        "args": [],
        "hooks": []
    },
    # 可以删除下载纪录
    "automatic.can_delete_download_record": {
        "url_type": 0,
        "url": "delete_download_record",
        "method": "POST",
        "args": [],
        "hooks": []
    },
    # 可以上传审核图片
    "automatic.can_upload_file": {
        "url_type": 0,
        "url": "upload_file",
        "method": "POST",
        "args": [],
        "hooks": []
    },
    # 可以在用户中心修改头像
    "automatic.can_change_avatar": {
        "url_type": 0,
        "url": "change_avatar",
        "method": "POST",
        "args": [],
        "hooks": []
    },

    # kind_admin项目权限
    # 可以访问账户表
    "automatic.can_access_kind_admin_userprofile_table": {
        "url_type": 1,
        "url": "/kind_admin/automatic/userprofile/",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以访问账户表修改页
    "automatic.can_access_kind_admin_userprofile_table_change": {
        "url_type": 2,
        "url": "/kind_admin/automatic/userprofile/\d+/change/$",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以修改账户表
    "automatic.can_change_kind_admin_userprofile_table": {
        "url_type": 2,
        "url": "/kind_admin/automatic/userprofile/\d+/change/$",
        "method": "POST",
        "args": [],
        "hooks": []
    },
    # 可以访问APP库
    "automatic.can_access_kind_admin_table_index": {
        "url_type": 0,
        "url": "table_index",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以访问kind_admin注册的所有table
    "automatic.can_access_kind_admin_all_table_objs": {
        "url_type": 0,
        "url": "table_objs",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以对kind_admin注册的所有table进行行内编辑和action操作
    "automatic.can_change_or_do_action_kind_admin_all_table_objs": {
        "url_type": 0,
        "url": "table_objs",
        "method": "POST",
        "args": [],
        "hooks": []
    },
    # 可以访问kind_admin注册的所有table修改页面
    "automatic.can_access_kind_admin_all_table_change": {
        "url_type": 0,
        "url": "table_change",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以修改kind_admin注册的所有table信息
    "automatic.can_change_kind_admin_all_table_detail": {
        "url_type": 0,
        "url": "table_change",
        "method": "POST",
        "args": [],
        "hooks": []
    },
    # 可以访问密码修改页
    "automatic.can_access_change_password": {
        "url_type": 0,
        "url": "change_password",
        "method": "GET",
        "args": [],
        "hooks": []
    },
    # 可以修改自己的密码
    "automatic.can_change_own_password": {
        "url_type": 2,
        "url": "/kind_admin/automatic/userprofile/\d+/change/password/$",
        "method": "POST",
        "args": [],
        "hooks": ["only_change_own_password"],
    },
    # 可以修改所有人的密码
    "automatic.can_change_all_user_password": {
        "url_type": 0,
        "url": "change_password",
        "method": "POST",
        "args": [],
        "hooks": [],
    },
    # 可以访问所有删除页面
    "automatic.can_access_kind_admin_table_delete": {
        "url_type": 0,
        "url": "table_delete",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
    # 可以删除所有表信息
    "automatic.can_delete_kind_admin_table_detail": {
        "url_type": 0,
        "url": "table_delete",
        "method": "POST",
        "args": [],
        "hooks": [],
    },
    # 可以访问所有添加表信息页面
    "automatic.can_access_kind_admin_table_add": {
        "url_type": 0,
        "url": "table_add",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
    # 可以添加所有表信息
    "automatic.can_add_kind_admin_table_detail": {
        "url_type": 0,
        "url": "table_add",
        "method": "POST",
        "args": [],
        "hooks": [],
    },

    # 可以访问用户提交下载记录页面
    "automatic.can_access_kind_admin_download_record": {
        "url_type": 1,
        "url": "/kind_admin/automatic/downloadrecord/",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
    # 可以对用户提交下载记录页面进行行内编辑和action操作
    "automatic.can_change_or_do_action_kind_admin_download_record": {
        "url_type": 1,
        "url": "/kind_admin/automatic/downloadrecord/",
        "method": "POST",
        "args": [],
        "hooks": [],
    },
    # 可以访问用户具体的下载信息
    "automatic.can_access_kind_admin_download_record_detail": {
        "url_type": 2,
        "url": "/kind_admin/automatic/downloadrecord/\d+/change/$",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
    # 可以修改用户具体的下载信息
    "automatic.can_change_kind_admin_download_record_detail": {
        "url_type": 2,
        "url": "/kind_admin/automatic/downloadrecord/\d+/change/$",
        "method": "POST",
        "args": [],
        "hooks": [],
    },
    # 可以访问删除用户下载信息页面
    "automatic.can_access_kind_admin_download_record_delete": {
        "url_type": 2,
        "url": "/kind_admin/automatic/downloadrecord/.*/delete/$",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
    # 可以删除用户下载信息
    "automatic.can_delete_kind_admin_download_record": {
        "url_type": 2,
        "url": "/kind_admin/automatic/downloadrecord/.*/delete/$",
        "method": "POST",
        "args": [],
        "hooks": [],
    },
    # 可以访问添加SQL记录页面
    "automatic.can_access_kind_admin_sqlrecord_add": {
        "url_type": 1,
        "url": "/kind_admin/automatic/sqlrecord/add/",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
    # 可以添加SQL记录
    "automatic.can_add_kind_admin_sqlrecord": {
        "url_type": 1,
        "url": "/kind_admin/automatic/sqlrecord/add/",
        "method": "POST",
        "args": [],
        "hooks": [],
    },
    # 可以访问查看所有SQL记录页面
    "automatic.can_access_kind_admin_sqlrecord": {
        "url_type": 1,
        "url": "/kind_admin/automatic/sqlrecord/",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
    # 可以对查看所有SQL记录页面进行行内编辑和action操作
    "automatic.can_change_or_do_action_kind_admin_sqlrecord": {
        "url_type": 1,
        "url": "/kind_admin/automatic/sqlrecord/",
        "method": "POST",
        "args": [],
        "hooks": [],
    },
    # 可以访问SQL记录修改页面
    "automatic.can_access_kind_admin_sqlrecord_change": {
        "url_type": 2,
        "url": "/kind_admin/automatic/sqlrecord/\d+/change/$",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
    # 可以修改SQL记录
    "automatic.can_change_kind_admin_sqlrecord": {
        "url_type": 2,
        "url": "/kind_admin/automatic/sqlrecord/\d+/change/$",
        "method": "POST",
        "args": [],
        "hooks": [],
    },
    # 可以访问用户查询记录页面
    "automatic.can_access_kind_admin_usersearchlog": {
        "url_type": 1,
        "url": "/kind_admin/automatic/usersearchlog/",
        "method": "GET",
        "args": [],
        "hooks": [],
    },
}


def only_change_own_password(request, *args, **kwargs):
    """验证只能修改自己的密码"""
    ret = {"status": False, "errors": [], "data": None}  # 要返回的内容
    matched_ret = re.match("/kind_admin/automatic/userprofile/(?P<user_id>\d+)/change/password/$", request.path)
    if matched_ret:
        if matched_ret.groupdict().get("user_id") == str(request.user.id):
            ret["status"] = True
        else:
            ret["errors"].append("因为，您只能修改自己的用户密码！")
    return ret
