import json
from django.shortcuts import render, redirect
from kind_admin import kind_admin
from kind_admin.utils import (
    get_condition_dict, get_paginator_query_sets, query_sets_sort, query_sets_search, count_related_objs
)
from kind_admin.forms import create_model_form
from django.contrib.auth.decorators import login_required


# Create your views here.
@login_required
def index(request):
    return render(request, "kind_admin/table_index.html", {"table_list": kind_admin.enabled_admins})


@login_required
def table_objs(request, app_name, table_name):
    """对每张表进行展示"""
    admin_class = kind_admin.enabled_admins[app_name][table_name]  # 获取admin_class
    if request.method == "POST":
        selected_ids = request.POST.get("selected_ids")  # 获取用户选择的对象ID
        selected_ids = json.loads(selected_ids)
        action_name = request.POST.get("action_select")  # 获取动作的名称
        querysets = admin_class.model.objects.filter(id__in=selected_ids).all()
        if hasattr(admin_class, action_name):  # 检测admin_class是否有该动作的函数
            func = getattr(admin_class, action_name)
            return func(admin_class, request, querysets)  # 有则直接运行该函数并返回
    condition_dict = get_condition_dict(request)  # 获取过滤条件
    contact_list = admin_class.model.objects.filter(**condition_dict).order_by(
        admin_class.ordering or "-%s" % admin_class.model._meta.auto_field.name  # 默认按照主键降序排列
    )  # 过滤
    contact_list = query_sets_search(request, contact_list, admin_class)  # 查询
    contact_list, orderby_dict = query_sets_sort(request, contact_list)  # 排序
    query_sets = get_paginator_query_sets(request, contact_list, admin_class.list_per_page)  # 获取带分页对象的query_sets
    return render(request, "kind_admin/table_objs.html", {
        "admin_class": admin_class,
        "query_sets": query_sets,
        "condition_dict": condition_dict,
        "orderby_dict": orderby_dict,
        "search_content": request.GET.get("_q", ""),
    })


@login_required
def table_add(request, app_name, table_name):
    """
    添加表信息
    :param request:
    :param app_name: APP名称
    :param table_name: 表名称
    :return:
    """
    model_form_obj = None  # 要返回的model_form对象
    admin_class = kind_admin.enabled_admins[app_name][table_name]  # 获取admin_class
    admin_class.need_readonly = False  # 对对象进行添加时，不需要有readonly的需求
    model_form_class = create_model_form(admin_class)  # 获取ModelForm
    if request.method == "GET":
        model_form_obj = model_form_class()
    elif request.method == "POST":
        model_form_obj = model_form_class(request.POST)
        if model_form_obj.is_valid():
            if not admin_class.table_readonly:  # 不是只读的表才会进行增加操作
                model_form_obj.save()  # 增加对象
            if request.POST.get("_save"):
                return redirect("/kind_admin/%s/%s/" % (app_name, table_name))
            elif request.POST.get("_addanother"):
                return redirect("/kind_admin/%s/%s/add/" % (app_name, table_name))
            elif request.POST.get("_continue"):
                return redirect("/kind_admin/%s/%s/%s/change/" % (app_name, table_name, model_form_obj.instance.id))
    return render(request, "kind_admin/table_add.html", {
        "admin_class": admin_class,
        "model_form_obj": model_form_obj,
        "app_name": app_name,
        "table_name": table_name,
    })


@login_required
def table_change(request, app_name, table_name, obj_id):
    """
    对表进行修改操作
    :param request:
    :param app_name: APP名称
    :param table_name: 表名称
    :param obj_id: 一条记录的主键ID
    :return:
    """
    model_form_obj = None  # 要返回的model_form对象
    admin_class = kind_admin.enabled_admins[app_name][table_name]  # 获取admin_class
    admin_class.need_readonly = True  # 对对象进行修改时，需要有readonly的需求
    model_form_class = create_model_form(admin_class)  # 获取ModelForm
    obj = admin_class.model.objects.filter(id=obj_id).first()  # 获取要修改的对象
    admin_class.request = request  # 在admin_class封装request对象
    for field in admin_class.dynamic_default_fields:
        if hasattr(admin_class, "dynamic_default_%s" % field):
            dynamic_default_func = getattr(admin_class, "dynamic_default_%s" % field)
            setattr(obj, field, dynamic_default_func(admin_class))
    if request.method == "GET":
        model_form_obj = model_form_class(instance=obj)
    elif request.method == "POST":
        model_form_obj = model_form_class(request.POST, instance=obj)
        if model_form_obj.is_valid():
            if not admin_class.table_readonly:  # 不是只读的表才会进行更新操作
                model_form_obj.save()  # 更新对象
            if request.POST.get("_save"):
                return redirect("/kind_admin/%s/%s/" % (app_name, table_name))
            elif request.POST.get("_addanother"):
                return redirect("/kind_admin/%s/%s/add/" % (app_name, table_name))
            elif request.POST.get("_continue"):
                return redirect("/kind_admin/%s/%s/%s/change/" % (app_name, table_name, model_form_obj.instance.id))
    return render(request, "kind_admin/table_change.html", {
        "admin_class": admin_class,
        "model_form_obj": model_form_obj,
        "app_name": app_name,
        "table_name": table_name,
    })


@login_required
def table_delete(request, app_name, table_name, obj_ids):
    """
    删除某条记录
    :param request:
    :param app_name: APP名称
    :param table_name: 表名称
    :param obj_ids: 记录对应ID
    :return:
    """
    related_count_dict = {}  # 用来存放关联对象的个数
    obj_id_list = obj_ids.split("-")
    admin_class = kind_admin.enabled_admins[app_name][table_name]  # 获取admin_class
    objs = admin_class.model.objects.filter(id__in=obj_id_list).all()  # 获取要修改的对象
    related_count_dict = count_related_objs(objs, related_count_dict)  # 计算关联对象的个数
    if request.method == "GET":
        return render(request, "kind_admin/table_delete.html", {
            "admin_class": admin_class,
            "objs": objs,
            "app_name": app_name,
            "table_name": table_name,
            "obj_ids": obj_ids,
            "related_count_dict": related_count_dict,
        })
    elif request.method == "POST":
        if not admin_class.table_readonly:  # 不是只读的表才会进行删除操作
            objs.delete()  # 删除所有对象
        return redirect("/kind_admin/%s/%s" % (app_name, table_name))


@login_required
def change_password(request, app_name, table_name, obj_id):
    """
    修改用户密码
    :param request:
    :param app_name:
    :param table_name:
    :param obj_id:
    :return:
    """
    errors_dict = {}  # 要返回的错误信息
    admin_class = kind_admin.enabled_admins[app_name][table_name]  # 获取admin_class
    obj = admin_class.model.objects.filter(id=obj_id).first()  # 获取要修改的对象
    if request.method == "POST":
        pwd1 = request.POST.get("password1")
        pwd2 = request.POST.get("password2")
        if pwd1 and pwd2:
            if pwd1 == pwd2:
                obj.set_password(pwd1)
                obj.save()
                return redirect("/accounts/login/")
            else:
                errors_dict["error"] = "两次输入密码不一致!"
        else:
            errors_dict["invalid"] = "密码不能为空！"
    return render(request, "kind_admin/change_password.html", {"errors_dict": errors_dict})
