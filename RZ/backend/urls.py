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
from .views import user
from .views import manage

urlpatterns = [
    url(r'^check_code.html$', user.check_code),
    url(r'^register/$', user.register),
    url(r'^login/$', user.login),
    url(r'^logout/$', user.logout),
    url(r'^index/$', manage.index),
    url(r'^base_info/$', manage.base_info),
    url(r'^tg_info/$', manage.tg_info),
    url(r'^upload_head_portrait/$', manage.upload_head_portrait),
]
