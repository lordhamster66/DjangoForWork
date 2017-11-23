#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/11/23
"""可以动态生成model form"""
from django.forms import ModelForm, widgets

"""
class CeshiModelForm(ModelForm):
    class Meta:
        model = ""
        fields = "__all__"
"""


def create_model_form(admin_class):
    """自动生成modelform"""

    def __new__(cls, *args, **kwargs):
        for field_obj in cls.base_fields.values():
            field_obj.widget.attrs["class"] = "form-control"
        return ModelForm.__new__(cls)

    class Meta:
        model = admin_class.model
        fields = "__all__"

    attrs = {"Meta": Meta, "__new__": __new__}
    model_form_class = type("DynamicModelForm", (ModelForm,), attrs)
    return model_form_class
