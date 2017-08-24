from django.db import models

# Create your models here.


class BaseInfo(models.Model):
    """基础数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    zhu_r = models.IntegerField(verbose_name='注册人数')
    sm_r = models.IntegerField(verbose_name='实名人数')
    sc_r = models.IntegerField(verbose_name='首充人数')
    xztz_r = models.IntegerField(verbose_name='新增投资人数')
    xztz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='新增投资金额')
    cz_r = models.IntegerField(verbose_name='充值人数')
    cz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='充值金额')
    tx_r = models.IntegerField(verbose_name='提现人数')
    tx_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='提现金额')
    tz_r = models.IntegerField(verbose_name='投资人数')
    tz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='投资金额')
    tz_b = models.IntegerField(verbose_name='投资笔数', null=True)
    tz_dl_r = models.IntegerField(verbose_name='投资登录人数', null=True)
    hk_r = models.IntegerField(verbose_name='回款人数')
    hk_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='回款金额')
    zg_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='站岗金额')
    zg_r = models.IntegerField(verbose_name='站岗人数', null=True)


class QudaoName(models.Model):
    """渠道名称对应表"""
    sign = models.CharField(max_length=32, verbose_name='渠道标识', db_index=True)
    name = models.CharField(max_length=32, verbose_name='渠道名称', db_index=True)


class TgInfo(models.Model):
    """推广数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    tg_zhu_r = models.IntegerField(verbose_name='推广注册人数')
    tg_sm_r = models.IntegerField(verbose_name='推广实名人数')
    tg_sc_r = models.IntegerField(verbose_name='推广首充人数')
    tg_xztz_r = models.IntegerField(verbose_name='推广新增人数')
    tg_xztz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='推广新增金额')


class OperateInfo(models.Model):
    """运营数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    xz_cz = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='新增充值')
    hk_cz = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='回款并充值')
    unhk_cz = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='非回款充值')
    zj_ft_lv = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='资金复投率')
    rs_ft_lv = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='人数复投率')


class InviteInfo(models.Model):
    """邀请数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    invite_r = models.IntegerField(verbose_name='邀请人数')
    invited_r = models.IntegerField(verbose_name='被邀请人数')
    invited_st_r = models.IntegerField(verbose_name='被邀请首投人数')
    invited_st_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='被邀请首投金额')
    cash_f = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='现金奖励发放金额')
    cash_l = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='现金奖励领取金额')
    hb_f = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='邀请红包发放金额')
    hb_s = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='邀请红包使用金额')


class AssetInfo(models.Model):
    """资产数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    term = models.CharField(max_length=32, verbose_name='期限类型')
    tz_r = models.IntegerField(verbose_name='投资人数')
    tz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='投资金额')
    mb_ys = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='满标用时')


class KeFuInfo(models.Model):
    """客服数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    st_ft_r = models.IntegerField(verbose_name='首投后复投人数')
    st_r = models.IntegerField(verbose_name='首投人数')
    ls_r = models.IntegerField(verbose_name='流失用户')
    zt_r = models.IntegerField(verbose_name='在投用户')
