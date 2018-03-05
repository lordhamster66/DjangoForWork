from django.db import models


# Create your models here.
class User(models.Model):
    """用户表"""
    username = models.CharField(max_length=16, unique=True, verbose_name="用户名", db_index=True)
    pwd = models.CharField(max_length=64, verbose_name="密码")
    qq = models.IntegerField(verbose_name="QQ号")
    avatar = models.ImageField(verbose_name='头像', null=True, upload_to='img', default="img/default.png")
    register_time = models.DateTimeField(auto_now_add=True, verbose_name="注册时间")
    update_time = models.DateTimeField(auto_now=True, verbose_name="更新时间")

    class Meta:
        db_table = "rzjf_user"  # 数据库表名
        verbose_name = "用户信息"  # admin表名
        verbose_name_plural = "用户信息"  # admin +s表名


class BaseInfo(models.Model):
    """基础数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    zhu_r = models.IntegerField(verbose_name='注册人数', null=True)
    sm_r = models.IntegerField(verbose_name='实名人数', null=True)
    sc_r = models.IntegerField(verbose_name='首充人数', null=True)
    xztz_r = models.IntegerField(verbose_name='新增投资人数', null=True)
    xztz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='新增投资金额', null=True)
    cz_r = models.IntegerField(verbose_name='充值人数', null=True)
    cz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='充值金额', null=True)
    tx_r = models.IntegerField(verbose_name='提现人数', null=True)
    tx_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='提现金额', null=True)
    tz_r = models.IntegerField(verbose_name='投资人数', null=True)
    tz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='投资金额', null=True)
    tz_b = models.IntegerField(verbose_name='投资笔数', null=True)
    tz_dl_r = models.IntegerField(verbose_name='投资登录人数', null=True)
    hk_r = models.IntegerField(verbose_name='回款人数', null=True)
    hk_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='回款金额', null=True)
    zg_j = models.DecimalField(max_digits=30, decimal_places=2, verbose_name='站岗金额', null=True)
    zg_r = models.IntegerField(verbose_name='站岗人数', null=True)
    zd_r = models.IntegerField(verbose_name='在贷人数', null=True)
    zd_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name='在贷金额', null=True)
    xt_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name='续投金额', null=True)
    cz_tz = models.DecimalField(max_digits=20, decimal_places=2, verbose_name='充值并投资', null=True)

    class Meta:
        db_table = "rzjf_base_info"
        verbose_name = '基础数据'
        verbose_name_plural = '基础数据'


class QudaoName(models.Model):
    """渠道名称对应表"""
    sign = models.CharField(max_length=32, verbose_name='渠道标识', db_index=True)
    name = models.CharField(max_length=32, verbose_name='渠道名称', db_index=True)

    class Meta:
        db_table = "rzjf_qudao_name"
        verbose_name = '渠道名称对应表'
        verbose_name_plural = '渠道名称对应表'


class TgInfo(models.Model):
    """推广数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    tg_zhu_r = models.IntegerField(verbose_name='推广注册人数', null=True)
    tg_sm_r = models.IntegerField(verbose_name='推广实名人数', null=True)
    tg_sc_r = models.IntegerField(verbose_name='推广首充人数', null=True)
    tg_xztz_r = models.IntegerField(verbose_name='推广新增人数', null=True)
    tg_xztz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='推广新增金额', null=True)
    tg_cost = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='推广花费', default=0, null=True)

    class Meta:
        db_table = "rzjf_tg_info"
        verbose_name = '推广数据'
        verbose_name_plural = '推广数据'


class OperateInfo(models.Model):
    """运营数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    xz_cz = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='新增充值', null=True)
    hk_cz = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='回款并充值', null=True)
    unhk_cz = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='非回款充值', null=True)
    zj_ft_lv = models.DecimalField(max_digits=10, decimal_places=4, verbose_name='资金复投率', null=True)
    rs_ft_lv = models.DecimalField(max_digits=10, decimal_places=4, verbose_name='人数复投率', null=True)

    class Meta:
        db_table = "rzjf_operate_info"
        verbose_name = '运营数据'
        verbose_name_plural = '运营数据'


class InviteInfo(models.Model):
    """邀请数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    invite_r = models.IntegerField(verbose_name='邀请人数', null=True)
    invited_r = models.IntegerField(verbose_name='被邀请人数', null=True)
    invited_st_r = models.IntegerField(verbose_name='被邀请首投人数', null=True)
    invited_st_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='被邀请首投金额', null=True)
    cash_f = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='现金奖励发放金额', null=True)
    cash_l = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='现金奖励领取金额', default=0, null=True)
    hb_f = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='邀请红包发放金额', default=0, null=True)
    hb_s = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='邀请红包使用金额', default=0, null=True)

    class Meta:
        db_table = "rzjf_invite_info"
        verbose_name = '邀请数据'
        verbose_name_plural = '邀请数据'


class AssetInfo(models.Model):
    """资产数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    asset_type = models.CharField(max_length=32, verbose_name='资产类型', default="所有", null=True)
    term = models.CharField(max_length=32, verbose_name='期限类型', null=True)
    tz_r = models.IntegerField(verbose_name='投资人数', null=True)
    tz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='投资金额', null=True)
    mb_ys = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='满标用时', null=True)

    class Meta:
        db_table = "rzjf_asset_info"
        verbose_name = '资产数据'
        verbose_name_plural = '资产数据'


class DailyAssetInfo(models.Model):
    """日报所需资产数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    term = models.CharField(max_length=32, verbose_name='期限类型', null=True)
    tz_r = models.IntegerField(verbose_name='投资人数', null=True)
    tz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='投资金额', null=True)
    mb_ys = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='满标用时', null=True)
    asset_type = models.CharField(max_length=32, verbose_name='资产类型', default="所有", null=True)

    class Meta:
        db_table = "rzjf_daily_asset_info"
        verbose_name = '日报资产数据'
        verbose_name_plural = '日报资产数据'


class DailyWithdrawClassify(models.Model):
    """日报所需提现分类数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    term = models.CharField(max_length=32, verbose_name='提现分类', null=True)
    tx_r = models.IntegerField(verbose_name='提现人数', null=True)
    tx_j = models.DecimalField(max_digits=30, decimal_places=2, verbose_name='提现金额', null=True)
    withdraw_type = models.CharField(max_length=32, verbose_name='提现类型', default="所有", null=True)

    class Meta:
        db_table = "rzjf_daily_withdraw_classify"
        verbose_name = '日报提现分类数据'
        verbose_name_plural = '日报提现分类数据'


class DailyCollectClassify(models.Model):
    """日报所需待收分类数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    term = models.CharField(max_length=32, verbose_name='待收分类', null=True)
    collect_r = models.IntegerField(verbose_name='待收人数', null=True)
    collect_j = models.DecimalField(max_digits=30, decimal_places=2, verbose_name='待收金额', null=True)
    collect_type = models.CharField(max_length=32, verbose_name='待收类型', default="所有", null=True)

    class Meta:
        db_table = "rzjf_daily_collect_classify"
        verbose_name = '日报待收分类数据'
        verbose_name_plural = '日报待收分类数据'


class KeFuInfo(models.Model):
    """客服数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    st_ft_r = models.IntegerField(verbose_name='首投后复投人数', null=True)
    st_r = models.IntegerField(verbose_name='首投人数', null=True)
    ls_r = models.IntegerField(verbose_name='流失用户', null=True)
    zt_r = models.IntegerField(verbose_name='在投用户', null=True)

    class Meta:
        db_table = "rzjf_kefu_info"
        verbose_name = '客服数据'
        verbose_name_plural = '客服数据'


class GeDuanInfo(models.Model):
    """各端数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    geduan = models.CharField(max_length=32, verbose_name='各端类型', null=True)
    recover = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="各端已还", null=True)
    recover_withdraw = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="各端回款并提现", null=True)
    account = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="各端投资", null=True)
    xztz_j = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="各端新增投资", null=True)
    withdraw = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="各端提现金额", null=True)

    class Meta:
        db_table = "rzjf_geduan_info"
        verbose_name = "各端数据"
        verbose_name_plural = "各端数据"


class TimeSlot(models.Model):
    """各时间段详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    timeslot = models.IntegerField(verbose_name="时间段", null=True)
    tz_r = models.IntegerField(verbose_name='投资人数', null=True)

    class Meta:
        db_table = "rzjf_time_slot"
        verbose_name = "各时间段数据"
        verbose_name_plural = "各时间段数据"


class OtherInfo(models.Model):
    """其他数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    cz_fee = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="充值手续费", default=0)
    short_tz_r = models.IntegerField(verbose_name="30天以内短标交易人数", null=True)
    short_tz_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="30天以内短标交易金额", null=True)
    short_zd_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="30天以内短标待还总额", null=True)
    Rplan_account = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="R计划投资金额", null=True)
    Rplan_recover_account = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="R计划在贷金额", null=True)
    g_tz_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="供应链金融投资金额", default=0, null=True)
    x_tz_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="消费金融投资金额", default=0, null=True)
    Rplan_xt = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="R计划续投金额", default=0, null=True)
    unRplan_xt_hk_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="非R计划自动续投金额", default=0,
                                          null=True)

    class Meta:
        db_table = "rzjf_other_info"
        verbose_name = "其他数据"
        verbose_name_plural = "其他数据"


class ReCasting(models.Model):
    """专属客服复投数据"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    kefuname = models.CharField(max_length=64, verbose_name="客服姓名", null=True)
    ft_r = models.IntegerField(verbose_name="首投后复投人数", null=True)
    st_r = models.IntegerField(verbose_name="首投人数", null=True)
    ft_lv = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="复投率", null=True)
    ft_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="复投金额", null=True)
    day_t_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="当日投资金额", null=True)
    month_t_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="当月投资金额", null=True)

    one_month_ft_r = models.IntegerField(verbose_name="本月首投后复投人数", null=True)
    one_month_st_r = models.IntegerField(verbose_name="本月首投人数", null=True)
    one_month_ft_lv = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="本月首投用户复投率", null=True)
    one_month_ft_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="本月首投用户复投金额", null=True)

    two_month_ft_r = models.IntegerField(verbose_name="前两月首投后复投人数", null=True)
    two_month_st_r = models.IntegerField(verbose_name="前两月首投人数", null=True)
    two_month_ft_lv = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="前两月首投用户复投率", null=True)
    two_month_ft_j = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="前两月首投用户复投金额", null=True)

    class Meta:
        unique_together = ("qdate", "kefuname")
        db_table = "rzjf_re_casting"
        verbose_name = "专属客服复投数据"
        verbose_name_plural = "专属客服复投数据"


class LossRate(models.Model):
    """VIP客服流失率"""
    qdate = models.DateField(verbose_name='日期', db_index=True)
    kefuname = models.CharField(max_length=64, verbose_name="客服姓名", null=True)
    loss_num = models.IntegerField(verbose_name="流失用户", null=True)
    exist_num = models.IntegerField(verbose_name="在投用户", null=True)
    day_invest = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="当日投资金额", null=True)
    month_withdraw = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="当月提现金额", null=True)
    month_invest = models.DecimalField(max_digits=20, decimal_places=2, verbose_name="当月投资金额", null=True)
    recall_num = models.IntegerField(verbose_name="当月召回人数", null=True)

    class Meta:
        db_table = "rzjf_loss_rate"
        verbose_name = "VIP客服流失率数据"
        verbose_name_plural = "VIP客服流失率数据"


class WDZJ_Info(models.Model):
    """网贷之家数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True, null=True)
    platName = models.CharField(max_length=32, verbose_name='平台名称', null=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='成交量(万元)', null=True)
    incomeRate = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='平均预期收益率(%)', null=True)
    loanPeriod = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='平均借款期限(月)', null=True)
    regCapital = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='注册资本(万元)', null=True)
    fullloanTime = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='满标用时(分)', null=True)
    stayStillOfTotal = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='待还余额(万元)', null=True)
    netInflowOfThirty = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='资金净流入(万元)', null=True)
    timeOperation = models.IntegerField(verbose_name='运营时间(月)', null=True)
    bidderNum = models.IntegerField(verbose_name='投资人数(人)', null=True)
    borrowerNum = models.IntegerField(verbose_name='借款人数(人)', null=True)
    totalLoanNum = models.IntegerField(verbose_name='借款标数(个)', null=True)
    top10DueInProportion = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='前十大土豪待收金额占比(%)',
                                               null=True)
    avgBidMoney = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='人均投资金额(万元)', null=True)
    top10StayStillProportion = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='前十大借款人待还金额占比(%)',
                                                   null=True)
    avgBorrowMoney = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='人均借款金额(万元)', null=True)
    developZhishu = models.IntegerField(verbose_name='发展指数排名', null=True)

    class Meta:
        db_table = "rzjf_wdzj_info"
        verbose_name = '网贷之家数据信息'
        verbose_name_plural = '网贷之家数据信息'


class WDTY_Info(models.Model):
    """网贷天眼数据详情"""
    qdate = models.DateField(verbose_name='日期', db_index=True, null=True)
    name = models.CharField(max_length=32, verbose_name='平台名称', null=True)
    total = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='平台成交额(万)', null=True)
    rate = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='平台综合利率(%)', null=True)
    pnum = models.IntegerField(verbose_name='平台投资人数(人)', null=True)
    cycle = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='平台借款周期(月)', null=True)
    p1num = models.IntegerField(verbose_name='平台借款人(人)', null=True)
    fuload = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='平台满标速度(分钟)', null=True)
    alltotal = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='平台累计贷款余额(万)', null=True)
    capital = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='平台资金净流入(万)', null=True)

    class Meta:
        db_table = "rzjf_wdty_info"
        verbose_name = '网贷天眼数据信息'
        verbose_name_plural = '网贷天眼数据信息'
