#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/13
"""
方便工作使用，用于对一些重复工作提供接口
"""
import os
from RZ import settings
from crm import models
from django.shortcuts import HttpResponse
from datetime import datetime
from django.db import connections
from crm import utils  # 常用功能及一些工具或一些常用变量

base = """SELECT *
from 05b_0base
where bid = {bid}
;"""

base_run = """SELECT *
from 05b_0base_run
where bid = {bid}
;"""

tenderdetail = """SELECT *
from 05b_1tenderdetail
where bid = {bid}
;"""

tenderfinal = """SELECT *
from 05b_1tenderfinal
where bid = {bid}
;"""


def get_info_list(sql):
    cursor = connections['rz'].cursor()  # 获取一个游标
    cursor.execute(sql)
    base_info = cursor.fetchall()
    col_names = [i[0] for i in cursor.description]
    info_list = [dict(zip(col_names, row)) for row in base_info]
    return info_list


def get_insert_sql(sql_name):
    file_path = os.path.join(settings.BASE_DIR, "crm", "RzSql", "for_script", sql_name)
    f = open(file_path, "r", encoding="utf-8")
    insert_sql = f.read()
    f.close()
    return insert_sql


def get_base_insert_sql(sql, info_list, new_bid, name, full_date):
    year, month, day = full_date.split("-")  # 获取用户输入的年月日
    reverify_time = info_list[0].get('reverify_time')  # 获取该标的的满标时间
    reverify_time = reverify_time.replace(year=int(year), month=int(month), day=int(day))  # 替换满标日期
    base_insert_sql = sql.format(bid=new_bid, status=info_list[0].get('status'),
                                 curstate=info_list[0].get('curstate'), stoptrans=info_list[0].get('stoptrans'),
                                 diya_type=info_list[0].get('diya_type'), cid=info_list[0].get('cid'),
                                 uid=info_list[0].get('uid'),
                                 aid=info_list[0].get('aid'), name=name, flag=info_list[0].get('flag'),
                                 account=info_list[0].get('account'), account_diya=info_list[0].get('account_diya'),
                                 account_diyafanhuan=info_list[0].get('account_diyafanhuan'),
                                 account_zjf=info_list[0].get('account_zjf'), bid_bzj=info_list[0].get('bid_bzj'),
                                 borrow_style=info_list[0].get('borrow_style'),
                                 borrow_period=info_list[0].get('borrow_period'),
                                 pflag=info_list[0].get('pflag'), borrow_apr=info_list[0].get('borrow_apr'),
                                 borrow_webapr=info_list[0].get('borrow_webapr'),
                                 borrow_contents=info_list[0].get('borrow_contents'),
                                 borrow_valid_time=info_list[0].get('borrow_valid_time'),
                                 borrower_apr=info_list[0].get('borrower_apr'),
                                 tender_account_min=info_list[0].get('tender_account_min'),
                                 tender_account_max=info_list[0].get('tender_account_max'),
                                 limit_money=info_list[0].get('limit_money'),
                                 repay_each_time=info_list[0].get('repay_each_time'),
                                 cash_status=info_list[0].get('cash_status'),
                                 verify_userid=info_list[0].get('verify_userid'),
                                 verify_remark=info_list[0].get('verify_remark'),
                                 reverify_userid=info_list[0].get('reverify_userid'),
                                 reverify_remark=info_list[0].get('reverify_remark'),
                                 verify_username=info_list[0].get('verify_username'),
                                 reverify_username=info_list[0].get('reverify_username'), days=info_list[0].get('days'),
                                 time_h=info_list[0].get('time_h'), is_xudai=info_list[0].get('is_xudai'),
                                 repay_account=info_list[0].get('repay_account'),
                                 borrow_yongtu=info_list[0].get('borrow_yongtu'),
                                 repay_account_capital=info_list[0].get('repay_account_capital'),
                                 repay_account_interest=info_list[0].get('repay_account_interest'),
                                 repay_account_other=info_list[0].get('repay_account_other'),
                                 verify_time=info_list[0].get('verify_time'),
                                 reverify_time=reverify_time,
                                 borrow_jiangli=info_list[0].get('borrow_jiangli'),
                                 tend_jiangli_type=info_list[0].get('tend_jiangli_type'),
                                 app_jiangli=info_list[0].get('app_jiangli'), uid_add=info_list[0].get('uid_add'),
                                 uname_add=info_list[0].get('uname_add'), uid_zj=info_list[0].get('uid_zj'),
                                 uname_zj=info_list[0].get('uname_zj'), money_zj=info_list[0].get('money_zj'),
                                 dj_type=info_list[0].get('dj_type'), dj_sq=info_list[0].get('dj_sq'),
                                 lxglf=info_list[0].get('lxglf'), note=info_list[0].get('note'),
                                 is_old=info_list[0].get('is_old'),
                                 imeis=info_list[0].get('imeis'), bnum=info_list[0].get('bnum'),
                                 yewuyuan=info_list[0].get('yewuyuan'), yewuid=info_list[0].get('yewuid'),
                                 classify=info_list[0].get('classify'), bnumht=info_list[0].get('bnumht'),
                                 isapp=info_list[0].get('isapp'), doflag=info_list[0].get('doflag'),
                                 workflow_step=info_list[0].get('workflow_step'), infonum=info_list[0].get('infonum'),
                                 min_period=info_list[0].get('min_period'), useruid=info_list[0].get('useruid'),
                                 isAssign=info_list[0].get('isAssign'), border=info_list[0].get('border'),
                                 hetong_tpl_id=info_list[0].get('hetong_tpl_id'),
                                 pre_track_warning=info_list[0].get('pre_track_warning'),
                                 sent_ancun=info_list[0].get('sent_ancun'),
                                 save_ancun=info_list[0].get('save_ancun'), border_web=info_list[0].get('border_web'),
                                 tender_account_d=info_list[0].get('tender_account_d'),
                                 repay_interest_plus=info_list[0].get('repay_interest_plus'),
                                 thhtbh=info_list[0].get('thhtbh'),
                                 esc_status=info_list[0].get('esc_status'))
    return base_insert_sql


def get_base_run_insert_sql(sql, info_list, new_bid):
    base_run_insert_sql = sql.format(bid=new_bid, account=info_list[0].get('account'),
                                     tender_num=info_list[0].get('tender_num'),
                                     tender_times=info_list[0].get('tender_times'), hits=info_list[0].get('hits'),
                                     time_h=info_list[0].get('time_h'),
                                     borrow_account_yes=info_list[0].get('borrow_account_yes'),
                                     borrow_account_wait=info_list[0].get('borrow_account_wait'),
                                     borrow_account_scale=info_list[0].get('borrow_account_scale'),
                                     borrow_times=info_list[0].get('borrow_times'), dj_bzj=info_list[0].get('dj_bzj'),
                                     dj_sq=info_list[0].get('dj_sq'), attrv=info_list[0].get('attrv'),
                                     autorepay=info_list[0].get('autorepay'))
    return base_run_insert_sql


def get_tenderdetail_insert_sql(sql, info, new_bid):
    tenderdetail_insert_sql = sql.format(id=info.get('id'), bid=new_bid, uid=info.get('uid'),
                                         status=info.get('status'), account_tender=info.get('account_tender'),
                                         account=info.get('account'), already_pay=info.get('already_pay'),
                                         bid_cur_money=info.get('bid_cur_money'), is_auto=info.get('is_auto'),
                                         addtime=info.get('addtime'), addip=info.get('addip'),
                                         tender_auto_bianhao=info.get('tender_auto_bianhao'),
                                         successtime=info.get('successtime') if info.get(
                                             'successtime') is not None else "0000-00-00 00:00:00",
                                         time_h=info.get('time_h'),
                                         per=info.get('per'), pid=info.get('pid'), cid=info.get('cid'),
                                         ucid=info.get('ucid'), zqzr=info.get('zqzr'), t_c_no=info.get('t_c_no'),
                                         t_t_s=info.get('t_t_s'), voteclt=info.get('voteclt'), lcid=info.get('lcid'),
                                         at_1=info.get('at_1'), at_2=info.get('at_2'), at_4=info.get('at_4'),
                                         at_5=info.get('at_5'), hbid=info.get('hbid'), aprplus=info.get('aprplus'),
                                         jxid=info.get('jxid'), toubiao_time=info.get('toubiao_time'))
    return tenderdetail_insert_sql


def get_tenderfinal_insert_sql(sql, info, new_bid):
    tenderfinal_insert_sql = sql.format(id=info.get('id'), bid=new_bid, uid=info.get('uid'),
                                        status=info.get('status'), account=info.get('account'),
                                        recover_account_all=info.get('recover_account_all'),
                                        recover_account_interest=info.get('recover_account_interest'),
                                        recover_account_yes=info.get('recover_account_yes'),
                                        recover_account_interest_yes=info.get('recover_account_interest_yes'),
                                        recover_account_capital_yes=info.get('recover_account_capital_yes'),
                                        recover_account_sxf_yes=info.get('recover_account_sxf_yes'),
                                        recover_account_wait=info.get('recover_account_wait'),
                                        recover_account_interest_wait=info.get('recover_account_interest_wait'),
                                        recover_account_capital_wait=info.get('recover_account_capital_wait'),
                                        recover_times=info.get('recover_times'), contents=info.get('contents'),
                                        successtime=info.get('successtime') if info.get(
                                            'successtime') is not None else "0000-00-00 00:00:00",
                                        time_h=info.get('time_h'),
                                        per=info.get('per'), pid=info.get('pid'), cid=info.get('cid'),
                                        at_1=info.get('at_1'), at_2=info.get('at_2'), at_4=info.get('at_4'),
                                        at_5=info.get('at_5'), orguid=info.get('orguid'),
                                        sent_ancun=info.get('sent_ancun'), save_ancun=info.get('save_ancun'),
                                        tid=info.get('tid'), lzid=info.get('lzid'), aprplus=info.get('aprplus'),
                                        recover_account_interest_plus=info.get('recover_account_interest_plus'),
                                        recover_account_interest_plus_yes=info.get('recover_account_interest_plus_yes'),
                                        hbid=info.get('hbid'), jxid=info.get('jxid'), htid=info.get('htid'))
    return tenderfinal_insert_sql


def create_fake_info(request, bid, new_bid, name, full_date):
    base_info_list = get_info_list(base.format(bid=bid))
    insert_sql = get_insert_sql("05b_0base_insert.sql")
    base_insert_sql = get_base_insert_sql(insert_sql, base_info_list, new_bid, name, full_date)
    base_insert_sql = base_insert_sql.replace("'None'", 'NULL')

    base_run_info_list = get_info_list(base_run.format(bid=bid))
    insert_sql = get_insert_sql("05b_0base_run_insert.sql")
    base_run_insert_sql = get_base_run_insert_sql(insert_sql, base_run_info_list, new_bid)
    base_run_insert_sql = base_run_insert_sql.replace("'None'", 'NULL')

    tenderdetail_info_list = get_info_list(tenderdetail.format(bid=bid))
    insert_sql = get_insert_sql("05b_1tenderdetail_insert.sql")
    tenderdetail_insert_sql_list = []
    for i in tenderdetail_info_list:
        tenderdetail_insert_sql = get_tenderdetail_insert_sql(insert_sql, i, new_bid)
        tenderdetail_insert_sql = tenderdetail_insert_sql.replace("'None'", 'NULL')
        tenderdetail_insert_sql_list.append(tenderdetail_insert_sql)
    tenderdetail_insert_sql = "<br>".join(tenderdetail_insert_sql_list)

    tenderfinal_info_list = get_info_list(tenderfinal.format(bid=bid))
    insert_sql = get_insert_sql("05b_1tenderfinal_insert.sql")
    tenderfinal_insert_sql_list = []
    for i in tenderfinal_info_list:
        tenderfinal_insert_sql = get_tenderfinal_insert_sql(insert_sql, i, new_bid)
        tenderfinal_insert_sql = tenderfinal_insert_sql.replace("'None'", 'NULL')
        tenderfinal_insert_sql_list.append(tenderfinal_insert_sql)
    tenderfinal_insert_sql = "<br>".join(tenderfinal_insert_sql_list)

    return HttpResponse("%s <br><br> %s <br><br> %s <br><br> %s" % (
        base_insert_sql, base_run_insert_sql, tenderdetail_insert_sql, tenderfinal_insert_sql
    ))
