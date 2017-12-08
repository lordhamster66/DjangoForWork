#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/18
from django.forms import ModelForm, widgets, PasswordInput


# from crm import models
# class CustomerModelForm(ModelForm):
#     class Meta:
#         model = models.Customer
#         fields = "__all__"


def create_model_form(admin_class):
    need_readonly = admin_class.need_readonly  # 是否需要只读

    def __new__(cls, *args, **kwargs):
        for field_name, field_obj in cls.base_fields.items():
            if type(field_obj.widget).__name__ != "CheckboxInput":
                field_obj.widget.attrs["class"] = "form-control"
            model_field_obj = admin_class.model._meta.get_field(field_name)
            if field_name in admin_class.readonly_fields and need_readonly:
                field_obj.widget.attrs["disabled"] = "disabled"
            if type(model_field_obj).__name__ == "ForeignKey":
                field_obj.widget.attrs["tag"] = "foreignKey-edit"
                field_obj.widget.attrs["related_model"] = model_field_obj.related_model._meta.model_name
        return ModelForm.__new__(cls)

    def clean(self):
        """form验证"""
        error_dict = {}  # 错误字典
        for field_name, data in self.cleaned_data.items():
            if field_name in admin_class.readonly_fields and need_readonly:
                data_from_frontend = data
                data_from_obj = getattr(self.instance, field_name)
                if type(admin_class.model._meta.get_field(field_name)).__name__ == "ManyToManyField":
                    data_from_frontend = [i.id for i in data_from_frontend]
                    data_from_obj = [i.id for i in data_from_obj.all()]
                if data_from_frontend != data_from_obj:
                    error_dict[field_name] = "该字段不能修改！正确的值为：%s" % data_from_obj
        for k, v in error_dict.items():  # 如果有的话，为model form添加错误
            self.add_error(k, v)
        if hasattr(admin_class, "clean"):  # 用户自定义的clean验证
            getattr(admin_class, "clean")(self)
        for field_name in self.cleaned_data.keys():  # 用户自定义的字段验证
            if hasattr(admin_class, "clean_%s" % field_name):
                getattr(admin_class, "clean_%s" % field_name)(self)
        return self.cleaned_data

    class Meta:
        model = admin_class.model
        fields = "__all__"
        exclude = admin_class.modelform_exclude_fields  # 生成表单是要剔除的字段

    attrs = {"Meta": Meta, "__new__": __new__, "clean": clean}
    model_form_class = type("DynamicModelForm", (ModelForm,), attrs)  # 动态生成ModelForm
    return model_form_class
