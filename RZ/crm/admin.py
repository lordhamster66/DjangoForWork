from django.contrib import admin
from crm import models


# Register your models here.
# 创建类
class BaseInfoAdmin(admin.ModelAdmin):
    # 把这个基础数据表里的想要显示值放进去
    list_display = (
        'qdate', 'zhu_r', 'sm_r', 'sc_r', 'xztz_r', 'xztz_j',
        'cz_r', 'cz_j', 'tx_r', 'tx_j', 'tz_r', 'tz_j', 'tz_b',
        'tz_dl_r', 'hk_r', 'hk_j', 'zg_j', 'zg_r', 'zd_r', 'zd_j'
    )

    search_fields = (
        'qdate', 'zhu_r', 'sm_r', 'sc_r', 'xztz_r', 'xztz_j',
        'cz_r', 'cz_j', 'tx_r', 'tx_j', 'tz_r', 'tz_j', 'tz_b',
        'tz_dl_r', 'hk_r', 'hk_j', 'zg_j', 'zg_r', 'zd_r', 'zd_j'
    )

    ordering = ('qdate',)

    list_filter = ('qdate',)


class QudaoNameAdmin(admin.ModelAdmin):
    """渠道名称对应表显示信息"""
    list_display = ("sign", "name")


class TgInfoAdmin(admin.ModelAdmin):
    """推广数据对应表显示信息"""
    list_display = ("qdate", "tg_zhu_r", "tg_sm_r", "tg_sc_r", "tg_xztz_r", "tg_xztz_j")

    ordering = ('qdate',)

    list_filter = ('qdate',)


class OperateInfoAdmin(admin.ModelAdmin):
    """运营数据对应表显示信息"""
    list_display = ("qdate", "xz_cz", "hk_cz", "unhk_cz", "zj_ft_lv", "rs_ft_lv")

    ordering = ('qdate',)

    list_filter = ('qdate',)


class InviteInfoAdmin(admin.ModelAdmin):
    """邀请数据对应表显示信息"""
    list_display = (
        "qdate", "invite_r", "invited_r", "invited_st_r", "invited_st_j", "cash_f", "cash_l"
        , "hb_f", "hb_s"
    )

    ordering = ('qdate',)

    list_filter = ('qdate',)


class AssetInfoAdmin(admin.ModelAdmin):
    """资产数据对应表显示信息"""
    list_display = ("qdate", "term", "tz_r", "tz_j", "mb_ys")

    ordering = ('qdate',)

    list_filter = ('qdate',)


class KeFuInfoAdmin(admin.ModelAdmin):
    """客服数据信息表显示信息"""
    list_display = ("qdate", "st_ft_r", "st_r", "ls_r", "zt_r")

    ordering = ('qdate',)


class GeDuanInfoAdmin(admin.ModelAdmin):
    """各端数据信息表显示信息"""
    list_display = ("qdate", "geduan", "recover", "recover_withdraw", "account", "xztz_j", "withdraw")

    ordering = ("qdate",)


class WDZJ_InfoAdmin(admin.ModelAdmin):
    """网贷之家数据信息表显示信息"""
    list_display = (
        "qdate", "platName", "amount", "bidderNum", "borrowerNum", "totalLoanNum", "stayStillOfTotal"
    )

    search_fields = ('platName',)

    ordering = ('qdate', "amount")

    list_filter = ('qdate', "platName")


class WDTY_InfoAdmin(admin.ModelAdmin):
    """网贷天眼数据信息表显示信息"""
    list_display = ("qdate", "name", "total", "rate", "pnum", "cycle", "p1num", "fuload", "alltotal", "capital")

    search_fields = ('name',)

    ordering = ('qdate', "total")

    list_filter = ('qdate', "name")


admin.site.register(models.BaseInfo, BaseInfoAdmin)  # 注册基础数据信息
admin.site.register(models.QudaoName, QudaoNameAdmin)  # 注册渠道名称信息
admin.site.register(models.TgInfo, TgInfoAdmin)  # 注册推广数据信息
admin.site.register(models.OperateInfo, OperateInfoAdmin)  # 注册运营数据信息
admin.site.register(models.InviteInfo, InviteInfoAdmin)  # 注册邀请数据信息
admin.site.register(models.AssetInfo, AssetInfoAdmin)  # 注册资产数据信息
admin.site.register(models.KeFuInfo, KeFuInfoAdmin)  # 注册客服数据信息
admin.site.register(models.GeDuanInfo, GeDuanInfoAdmin)  # 注册各端数据信息
admin.site.register(models.WDZJ_Info, WDZJ_InfoAdmin)  # 注册网贷之家数据信息
admin.site.register(models.WDTY_Info, WDTY_InfoAdmin)  # 注册网贷天眼数据信息
