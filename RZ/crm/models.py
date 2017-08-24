from django.db import models

# Create your models here.


class BaseInfo(models.Model):
    """基础数据"""
    qdate = models.DateField(verbose_name='日期')
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
    tz_dl_r = models.IntegerField(verbose_name='投资登录人数')
    hk_r = models.IntegerField(verbose_name='回款人数')
    hk_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='回款金额')
    zg_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='站岗金额')
    zg_r = models.IntegerField(verbose_name='站岗人数', null=True)
