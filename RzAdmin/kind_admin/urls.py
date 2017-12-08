"""PerfectCRM URL Configuration

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
from kind_admin import views

urlpatterns = [
    url(r'^$', views.index, name="table_index"),
    url(r'^(?P<app_name>\w+)/(?P<table_name>\w+)/$', views.table_objs, name="table_objs"),
    url(r'^(?P<app_name>\w+)/(?P<table_name>\w+)/(?P<obj_id>\w+)/change/$', views.table_change, name="table_change"),
    url(r'^(?P<app_name>\w+)/(?P<table_name>\w+)/(?P<obj_ids>.*)/delete/$', views.table_delete, name="table_delete"),
    url(r'^(?P<app_name>\w+)/(?P<table_name>\w+)/add/$', views.table_add, name="table_add"),
]
