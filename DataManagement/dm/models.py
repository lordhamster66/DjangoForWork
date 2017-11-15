from django.db import models
from django.contrib.auth.models import User


# Create your models here.
class UserProfile(models.Model):
    """账户表"""
    user = models.OneToOneField(User)  # 关联django自带的账户表
    name = models.CharField(max_length=32, blank=True, null=True, verbose_name="姓名")
    roles = models.ManyToManyField("Role", blank=True, verbose_name="所属角色")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "账户表"


class Role(models.Model):
    """角色表"""
    name = models.CharField(max_length=64, unique=True, verbose_name="角色名称")
    date = models.DateTimeField(auto_now_add=True, verbose_name="创建日期")
    menus = models.ManyToManyField("Menu", blank=True, verbose_name="所属菜单")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "角色表"


class Menu(models.Model):
    """菜单表"""
    name = models.CharField(max_length=64, unique=True, verbose_name="菜单名称")
    url_type = models.SmallIntegerField(choices=((0, 'relative_name'), (1, 'absolute_url')), verbose_name="URL类型")
    url_name = models.CharField(max_length=64, verbose_name="URL名称")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "菜单表"


class Department(models.Model):
    """部门表"""
    name = models.CharField(max_length=64, unique=True, verbose_name="部门名称")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "部门表"


class SQLRecord(models.Model):
    """SQL记录表"""
    user = models.ForeignKey("UserProfile", verbose_name="创建者")
    sql_name = models.CharField(max_length=64, unique=True, verbose_name="SQL名称")
    department = models.ForeignKey("Department", blank=True, null=True, verbose_name="对应部门")
    sql_tags = models.ManyToManyField("SQLTag", blank=True, verbose_name="对应SQL标签")
    sql_content = models.ForeignKey("SQLContent", on_delete=models.CASCADE, verbose_name="对应SQL内容")
    date = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")

    def __str__(self):
        return self.sql_name

    class Meta:
        verbose_name_plural = "SQL记录表"


class SQLContent(models.Model):
    """SQL内容表"""
    content = models.TextField(verbose_name="sql内容")

    class Meta:
        verbose_name_plural = "SQL内容表"


class SQLTag(models.Model):
    """SQL标签"""
    user = models.ForeignKey("UserProfile", verbose_name="创建者")
    name = models.CharField(max_length=64, unique=True, verbose_name="sql标签名称")
    date = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "SQL标签表"
