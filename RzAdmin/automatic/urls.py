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
    url(r'^$', views.index, name="automatic_index"),
    url(r'^search_table_list/$', views.search_table_list, name="search_table_list"),
    url(r'^table_search_detail/(?P<sql_record_id>\d+)/$', views.table_search_detail),
    url(r'^search_channel_name/$', views.search_channel_name),
    url(r'^download_excel/(?P<sql_record_id>\d+)/$', views.download_excel),
    url(r'^user_center.html$', views.user_center, name="user_center"),
    url(r'^download_check/(?P<sql_record_id>\d+)/$', views.download_check),
    url(r'^delete_download_record/(?P<download_record_id>\d+)/$', views.delete_download_record),
]
