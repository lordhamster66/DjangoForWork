"""DataManagement URL Configuration

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
from .views import dm_index
from .views import manager

urlpatterns = [
    url(r'^$', dm_index.index, name="dm_index"),
    url(r'^add_sql.html$', manager.add_sql, name="add_sql"),
    url(r'^view_sql.html$', manager.view_sql, name="view_sql"),
    url(r'^edit_sql/(?P<sql_record_id>\d+)/$', manager.edit_sql, name="edit_sql"),
    url(r'^del_sql/(?P<sql_record_id>\d+)/$', manager.del_sql, name="del_sql"),
]
