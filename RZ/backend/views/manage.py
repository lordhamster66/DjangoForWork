#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/19
from django.shortcuts import render


def index(request):
    username = request.session.get("username", "breakering")
    return render(request, "index.html", {"username": username})
