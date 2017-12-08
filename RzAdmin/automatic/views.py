import logging
from django.shortcuts import render
from django.contrib.auth.decorators import login_required

# Create your views here.
logger = logging.getLogger("__name__")  # 生成一个以当前模块名为名字的logger实例
c_logger = logging.getLogger("collect")  # 生成一个名为'collect'的logger实例，用于收集一些需要特殊记录的日志


@login_required
def index(request):
    return render(request, "index.html")
