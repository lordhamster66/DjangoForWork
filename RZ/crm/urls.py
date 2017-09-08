"""RZ URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.10/topics/http/urls/
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
from crm import views

urlpatterns = [
    url(r'^ceshi/$', views.ceshi),  # 测试
    url(r'^data_storage/$', views.DataStorage.as_view()),  # 获取公司数据库信息
    url(r'^daily/$', views.Daily.as_view()),  # 日报
    url(r'^get_wdzj_info/$', views.get_wdzj_info),  # 爬取网贷之家数据信息
    url(r'^get_wdty_info/$', views.get_wdty_info),  # 爬取网贷天眼数据信息
    url(r'^backup/$', views.backup),  # 备份表
    url(r'^login/$', views.login),  # 登录功能
    url(r'^register/$', views.register),  # 注册功能
    url(r'^logout/$', views.logout),  # 注销功能
    url(r'^index/$', views.index),  # 首页
    url(r'^wdzj/$', views.wdzj),  # 网贷之家
]
