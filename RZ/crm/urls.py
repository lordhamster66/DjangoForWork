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
from .views import daily
from .views import views
from .views import ceshi
from .views import db_backup
from .views import some_script
from .views import storage
from .views import exhibition

urlpatterns = [
    url(r'^ceshi/$', ceshi.ceshi),  # 测试
    url(r'^data_storage/$', storage.DataStorage.as_view()),  # 获取公司数据库信息
    url(r'^daily/$', daily.Daily.as_view()),  # 日报
    url(r'^monthly/$', daily.monthly),  # 月度数据
    url(r'^get_wdzj_info/$', storage.get_wdzj_info),  # 爬取网贷之家数据信息
    url(r'^get_wdty_info/$', storage.get_wdty_info),  # 爬取网贷天眼数据信息
    url(r'^backup/$', db_backup.backup),  # 备份表
    url(r'^login/$', views.login),  # 登录功能
    url(r'^register/$', views.register),  # 注册功能
    url(r'^logout/$', views.logout),  # 注销功能
    url(r'^index/$', views.index),  # 首页
    url(r'^wdzj/$', views.wdzj),  # 网贷之家
    url(r'^create_fake_info/(?P<bid>\d*)/(?P<new_bid>\d*)/(?P<name>\w*-\w*)/(?P<full_date>\w*-\w*-\w*)/$',
        some_script.create_fake_info),  # 创建虚假数据
    url(r'^rzjf_recorde/$', storage.rzjf_recorde),  # 用于定时存储人众金服业务所产生的一些记录
    url(r'^sales_achievement/$', exhibition.sales_achievement),  # 展示电销业绩
    url(r'^rzjf_invest_rank/$', storage.rzjf_invest_rank),  # 存储投资次数
]
