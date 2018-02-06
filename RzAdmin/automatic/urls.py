"""RzAdmin URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from automatic import views

urlpatterns = [
    url(r'^$', views.index, name="automatic_index"),  # 自动化后台首
    url(r'^search_table_list/$', views.search_table_list, name="search_table_list"),  # 可用数据查询功能展示
    url(r'^table_search_detail/(?P<sql_record_id>\d+)/$', views.table_search_detail,
        name="table_search_detail"),  # 详细数据查询
    url(r'^search_channel_name/$', views.search_channel_name, name="search_channel_name"),  # 查询渠道名称
    url(r'^download_excel/(?P<sql_record_id>\d+)/$', views.download_excel, name="download_excel"),  # 下载EXCEL
    url(r'^user_center.html$', views.user_center, name="user_center"),  # 用户中心
    url(r'^download_check/(?P<sql_record_id>\d+)/$', views.download_check, name="download_check"),  # 下载审核
    url(r'^delete_download_record/$', views.delete_download_record, name="delete_download_record"),  # 删除下载记录
    url(r'^upload_file.html$', views.upload_file, name="upload_file"),  # 上传文件
    url(r'^channel_name_detail.html$', views.channel_name_detail, name="channel_name_detail"),  # 渠道名称详细信息
    url(r'^change_channel_name.html$', views.change_channel_name, name="change_channel_name"),  # 修改渠道名称
]
