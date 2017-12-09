from django.db import models
from django.contrib.auth.models import User  # django自带的账户认证表
from django.contrib.auth.models import (
    BaseUserManager, AbstractBaseUser, PermissionsMixin
)
from django.utils.translation import ugettext_lazy as _
from django.utils.safestring import mark_safe


# Create your models here.
class UserProfileManager(BaseUserManager):
    def create_user(self, email, name, password=None):
        """
        Creates and saves a User with the given email, date of
        birth and password.
        """
        if not email:
            raise ValueError('Users must have an email address')

        user = self.model(
            email=self.normalize_email(email),
            name=name,
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, name, password):
        """
        Creates and saves a superuser with the given email, date of
        birth and password.
        """
        user = self.create_user(
            email,
            password=password,
            name=name,
        )
        user.is_admin = True
        user.save(using=self._db)
        return user


class UserProfile(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(
        verbose_name='邮箱地址',
        max_length=255,
        unique=True,
    )
    password = models.CharField(
        _('password'),
        max_length=128,
        help_text=mark_safe("<a href='password/'>点我修改密码</a>")
    )
    name = models.CharField(max_length=32)
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)
    roles = models.ManyToManyField("Role", blank=True, verbose_name="所属角色", default=None)
    themes_choices = (
        ("type-a/theme-coffee.min.css", "A类coffee色"),
        ("type-a/theme-dark.min.css", "A类dark"),
        ("type-a/theme-dust.min.css", "A类dust"),
        ("type-a/theme-light.min.css", "A类light"),
        ("type-a/theme-lime.min.css", "A类lime"),
        ("type-a/theme-mint.min.css", "A类mint"),
        ("type-a/theme-navy.min.css", "A类navy"),
        ("type-a/theme-ocean.min.css", "A类ocean"),
        ("type-a/theme-prickly-pear.min.css", "A类prickly-pear"),
        ("type-a/theme-purple.min.css", "A类purple"),
        ("type-a/theme-well-red.min.css", "A类well-red"),
        ("type-a/theme-yellow.min.css", "A类yellow"),
        ("type-b/theme-coffee.min.css", "B类coffee色"),
        ("type-b/theme-dark.min.css", "B类dark"),
        ("type-b/theme-dust.min.css", "B类dust"),
        ("type-b/theme-light.min.css", "B类light"),
        ("type-b/theme-lime.min.css", "B类lime"),
        ("type-b/theme-mint.min.css", "B类mint"),
        ("type-b/theme-navy.min.css", "B类navy"),
        ("type-b/theme-ocean.min.css", "B类ocean"),
        ("type-b/theme-prickly-pear.min.css", "B类prickly-pear"),
        ("type-b/theme-purple.min.css", "B类purple"),
        ("type-b/theme-well-red.min.css", "B类well-red"),
        ("type-b/theme-yellow.min.css", "B类yellow"),
        ("type-c/theme-coffee.min.css", "C类coffee色"),
        ("type-c/theme-dark.min.css", "C类dark"),
        ("type-c/theme-dust.min.css", "C类dust"),
        ("type-c/theme-light.min.css", "C类light"),
        ("type-c/theme-lime.min.css", "C类lime"),
        ("type-c/theme-mint.min.css", "C类mint"),
        ("type-c/theme-navy.min.css", "C类navy"),
        ("type-c/theme-ocean.min.css", "C类ocean"),
        ("type-c/theme-prickly-pear.min.css", "C类prickly-pear"),
        ("type-c/theme-purple.min.css", "C类purple"),
        ("type-c/theme-well-red.min.css", "C类well-red"),
        ("type-c/theme-yellow.min.css", "C类yellow"),
    )
    themes = models.CharField(max_length=64, choices=themes_choices, verbose_name="主题",
                              default="type-c/theme-dark.min.css")
    objects = UserProfileManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    def get_full_name(self):
        # The user is identified by their email address
        return self.email

    def get_short_name(self):
        # The user is identified by their email address
        return self.email

    def __str__(self):  # __unicode__ on Python 2
        return self.email

    def has_perm(self, perm, obj=None):
        "Does the user have a specific permission?"
        # Simplest possible answer: Yes, always
        return True

    def has_module_perms(self, app_label):
        "Does the user have permissions to view the app `app_label`?"
        # Simplest possible answer: Yes, always
        return True

    @property
    def is_staff(self):
        "Is the user a member of staff?"
        # Simplest possible answer: All admins are staff
        return self.is_admin

    class Meta:
        verbose_name_plural = "账户表"


class Role(models.Model):
    """角色表"""
    name = models.CharField(max_length=32, unique=True, verbose_name="角色名称")
    menus = models.ManyToManyField("Menu", blank=True, verbose_name="菜单")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "角色表"


class Menu(models.Model):
    """动态菜单表"""
    name = models.CharField(unique=True, max_length=32, verbose_name="菜单名")
    url_type = models.SmallIntegerField(choices=((0, 'relative_name'), (1, 'absolute_url')), verbose_name="菜单url类型")
    url_name = models.CharField(unique=True, max_length=128, verbose_name="菜单url")
    icon = models.CharField(max_length=32, blank=True, null=True, verbose_name="菜单图标")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "动态菜单表"


class SQLTag(models.Model):
    """sql标签"""
    user = models.ForeignKey("UserProfile", verbose_name="创建者")
    name = models.CharField(max_length=32, verbose_name="标签名称")
    date = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "sql标签表"


class SQLFunc(models.Model):
    """sql具备的功能表"""
    name = models.CharField(max_length=32, verbose_name="功能名称")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "sql具备的功能表"


class SQLRecord(models.Model):
    """sql记录表"""
    user = models.ForeignKey("UserProfile", verbose_name="创建者")
    name = models.CharField(max_length=32, verbose_name="sql名称")
    roles = models.ManyToManyField("Role", blank=True, verbose_name="所属角色", default=None)
    tags = models.ManyToManyField("SQLTag", blank=True, verbose_name="标签", default=None)
    content = models.TextField(verbose_name="sql内容")
    funcs = models.ManyToManyField("SQLFunc", blank=True, verbose_name="sql具备的功能")
    query_page = models.BooleanField(default=False, verbose_name="是否生成查询页面")
    date = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "sql记录表"


class DownloadRecord(models.Model):
    """下载记录"""
    user = models.ForeignKey("UserProfile", related_name="user_download", verbose_name="下载用户")
    download_detail = models.CharField(max_length=32, verbose_name="下载信息")
    detail_url = models.TextField(verbose_name="详细信息地址")
    download_url = models.TextField(verbose_name="下载地址")
    check_img = models.ImageField(blank=True, null=True, verbose_name="审核用图片")
    check_status_choices = ((0, "未审核"), (1, "审核通过"), (2, "审核不通过"))
    check_status = models.SmallIntegerField(choices=check_status_choices, verbose_name="审核状态", default=0)
    check_user = models.ForeignKey("UserProfile", related_name="user_check_download", blank=True, null=True,
                                   verbose_name="审核用户")
    date = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")
    end_date = models.DateTimeField(verbose_name="过期时间", default="2099-12-31 00:00:00")

    def __str__(self):
        return self.download_detail

    class Meta:
        verbose_name_plural = "下载记录表"
