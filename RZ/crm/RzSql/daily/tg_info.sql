# 推广详情(记得剔除邀请的数据)
SELECT sum(a.tg_zhu_r) tg_zhu_r,sum(a.tg_sm_r) tg_sm_r,sum(a.tg_sc_r) tg_sc_r,sum(a.tg_xztz_r) tg_xztz_r,sum(a.tg_xztz_j) tg_xztz_j
from
(		# 推广注册详情
		SELECT count(DISTINCT(a.uid)) tg_zhu_r,0 tg_sm_r,0 tg_sc_r,0 tg_xztz_r,0 tg_xztz_j
		from rz_user.rz_user a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		LEFT JOIN rz_user.rz_user_invite i on a.uid = i.user_id
		LEFT JOIN rzjf_bi.01u_9tjr i1 on a.uid = i1.uid
		where a.user_type in (1,3) # 投资人
		and a.deleted = 0  # 记录没被删除
		and i.user_id is null # 剔除邀请
		and i1.uid is null  # 剔除老版邀请
		and a.create_time >=  "{qdate}"
		and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		UNION ALL
		# 推广实名详情
		SELECT 0 tg_zhu_r,count(DISTINCT(a.uid)) tg_sm_r,0 tg_sc_r,0 tg_xztz_r,0 tg_xztz_j
		from rz_user.rz_user a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		LEFT JOIN rz_user.rz_user_invite i on a.uid = i.user_id
		LEFT JOIN rzjf_bi.01u_9tjr i1 on a.uid = i1.uid
		where a.real_name_status = 1
		and a.user_type in (1,3) # 投资人
		and a.deleted = 0  # 记录没被删除
		and i.user_id is null # 剔除邀请
		and i1.uid is null  # 剔除老版邀请
		and a.real_name_verify_time >=  "{qdate}"
		and a.real_name_verify_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		UNION ALL
		# 推广首充详情
		SELECT 0 tg_zhu_r,0 tg_sm_r,count(DISTINCT(a.user_id)) tg_sc_r,0 tg_xztz_r,0 tg_xztz_j
		from rz_account.rz_account_recharge a
		INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
		INNER JOIN rz_user.rz_user c on a.user_id = c.uid
		INNER JOIN (SELECT user_id,min(id) min_id from rz_account.rz_account_recharge where status = 1 and deleted = 0 GROUP BY user_id) c on a.user_id = c.user_id and a.id = c.min_id  # 限定是首次充值
		LEFT JOIN rz_user.rz_user_invite i on a.user_id = i.user_id
		LEFT JOIN rzjf_bi.01u_9tjr i1 on a.user_id = i1.uid
		where a.status = 1  # 充值成功
		and a.deleted = 0  # 记录没被删除
		and c.user_type in (1,3) # 投资人
		and i.user_id is null # 剔除邀请
		and i1.uid is null  # 剔除老版邀请
		and a.create_time >=  "{qdate}"
		and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		UNION ALL
		# 推广新增详情
		SELECT  0 tg_zhu_r,0 tg_sm_r,0 tg_sc_r,count(DISTINCT(a.uid)) tg_xztz_r,sum(a.account) tg_xztz_j
		from
		(
				SELECT user_id uid,create_time time_h,money account
				from rz_borrow.rz_borrow_tender
				where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0
				and create_time >=  "{qdate}"
				and create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				UNION ALL
				SELECT user_id,add_time,real_amount
				from new_wd.borrow_tender
				where status = 1
				and add_time >=  "{qdate}"
				and add_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				UNION ALL
				SELECT user_id,create_time,real_amount
				from new_wd.rz_borrow_tender
				where `status` = 1
				and create_time >=  "{qdate}"
				and create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		) a
		LEFT JOIN rzjf_bi.rzjf_old_invest_uid c on a.uid = c.uid
		INNER JOIN
		(
					SELECT h1.uid,min(h1.time_h) min_invest_time
					from
								(
									SELECT a1.user_id uid,a1.money account,a1.create_time time_h
									from rz_borrow.rz_borrow_tender a1
									where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
									union all
									SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
									from new_wd.borrow_tender a2
									where a2.status = 1
									union all
									select a3.user_id uid,a3.real_amount account,a3.create_time time_h
									from new_wd.rz_borrow_tender a3
									where a3.status = 1
								) h1
					GROUP BY h1.uid
		) t on a.uid = t.uid and DATE(a.time_h) = DATE(t.min_invest_time)  # 限定新增
		LEFT JOIN rz_user.rz_user_invite i on a.uid = i.user_id
		LEFT JOIN rzjf_bi.01u_9tjr i1 on a.uid = i1.uid
		where c.uid is null  # 剔除老系统投资的用户，这些用户肯定不能算作新增投资用户
		and i.user_id is null # 剔除邀请
		and i1.uid is null  # 剔除老版邀请
) a
;