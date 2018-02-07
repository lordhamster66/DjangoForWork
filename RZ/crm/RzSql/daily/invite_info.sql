# 邀友详情
SELECT sum(a.invite_r) invite_r,sum(a.invited_r) invited_r,sum(a.invited_st_r) invited_st_r,sum(a.invited_st_j) invited_st_j,
sum(a.cost) cash_f
from
(
		SELECT count(DISTINCT i.invite_user) invite_r,count(DISTINCT(a.uid)) invited_r,0 invited_st_r,0 invited_st_j,0 cost
		from rz_user.rz_user a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		INNER JOIN rz_user.rz_user_invite i on a.uid = i.user_id
		LEFT JOIN (SELECT uid from rz_user.rz_user where reg_mobile like "JM%") j on a.uid = j.uid      # 机密借款人注册
		where j.uid is null  # 剔除机密借款人
		and a.user_type in (1,3) # 投资人
		and a.deleted = 0  # 记录没被删除
		and a.create_time >=  "{qdate}"
		and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		UNION ALL
		SELECT  0 invite_r,0 invited_r,count(DISTINCT(a.uid)) invited_st_r,sum(a.account) invited_st_j,0 cost
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
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		LEFT JOIN rzjf_bi.rzjf_old_invest_uid c on a.uid = c.uid
		INNER JOIN (SELECT user_id from rz_user.rz_user_invite UNION SELECT uid from rzjf_bi.01u_9tjr) i on a.uid = i.user_id
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
		) t on a.uid = t.uid and a.time_h = t.min_invest_time  # 限定首投
		where c.uid is null  # 剔除老系统投资的用户，这些用户肯定不能算作新增投资用户
		UNION ALL
		SELECT 0 invite_r,0 invited_r,0 invited_st_r,0 invited_st_j,sum(case when a.amount = 10 then a.amount else null end)+sum(case when a.amount = 90 then a.amount else null end) cost
		FROM
		(
				SELECT a.source,a.amount,a.use_time,a.create_time
				from rz_activity.rz_additional_user_red_envelope a
				where a.name in ('邀请好友投资送10元红包','邀请好友投资送90元红包','邀好友投资获得10元','邀好友投资获得90元') and a.status = 1  and a.deleted = 0
				and a.use_time >=  "{qdate}"
				and a.use_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				and a.create_time >= DATE_SUB(CURDATE(),INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
		) a
		INNER JOIN
		(
							SELECT a.source,min(a.create_time)create_time
							FROM
							(
							SELECT a.source,a.create_time
							from rz_activity.rz_additional_user_red_envelope a
							where a.source_type in (4) and a.deleted = 0
							union ALL
							SELECT a.source,a.create_time
							from rz_activity.rz_additional_user_red_envelope_cash a
							where a.source_type in (3,4) and a.deleted = 0
							) a
							GROUP BY 1
		) b on a.source = b.source and a.create_time = b.create_time
		UNION ALL
		SELECT 0 invite_r,0 invited_r,0 invited_st_r,0 invited_st_j,sum(case when a.amount = 50 then a.amount else null end) cost
		FROM
		(
							SELECT a.source,a.amount,a.create_time
							from rz_activity.rz_additional_user_red_envelope_cash a
							where a.source_type in (4) and a.deleted = 0
							and a.create_time >= "{qdate}"
							and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		) a
		INNER JOIN
		(
							SELECT a.source,min(a.create_time)create_time
							FROM
							(
							SELECT a.source,a.create_time
							from rz_activity.rz_additional_user_red_envelope a
							where a.source_type in (4) and a.deleted = 0
							union ALL
							SELECT a.source,a.create_time
							from rz_activity.rz_additional_user_red_envelope_cash a
							where a.source_type in (3,4) and a.deleted = 0
							) a
							GROUP BY 1
		) b on a.source = b.source and a.create_time = b.create_time
		UNION ALL
		SELECT 0 invite_r,0 invited_r,0 invited_st_r,0 invited_st_j,sum(a.amount) cost
		FROM
		(
							SELECT a.source,a.amount,a.create_time
							from rz_activity.rz_additional_user_red_envelope_cash a
							where a.source_type in (3) and a.deleted = 0
							and a.create_time >= "{qdate}"
							and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		) a
		INNER JOIN
		(
							SELECT a.source,min(a.create_time)create_time
							FROM
							(
							SELECT a.source,a.create_time
							from rz_activity.rz_additional_user_red_envelope a
							where a.source_type in (4) and a.deleted = 0
							union ALL
							SELECT a.source,a.create_time
							from rz_activity.rz_additional_user_red_envelope_cash a
							where a.source_type in (3,4) and a.deleted = 0
							) a
							GROUP BY 1
		) b on a.source = b.source and a.create_time = b.create_time
) a
;