# 各端已还以及各端已还并提现
SELECT a.type geduan,sum(a.recover_account) recover,sum(ifnull(b.money,0)) recover_withdraw
from
(
		SELECT a.uid,sum(a.recover_account) recover_account,
		case when q.name REGEXP "APP" then "APP"
		when q.name REGEXP "PC" then "PC"
		when q.name REGEXP "WAP" then "WAP"
		when b.regist_source_type in (0,4) then "PC"
		when b.regist_source_type = 1 then "WAP"
		when b.regist_source_type in (2,3) then "APP"
		else "PC" end type
		from
		(
				# 没债转的回款
				SELECT a1.user_id uid,a1.repayment_amount recover_account,a1.repayment_time recover_times
				from rz_borrow.rz_borrow_collection a1
				where a1.borrow_id <> 10000 and a1.status in (0,1,2) and a1.deleted = 0  # 记录没被删除
				and a1.bond_capital = 0 and a1.bond_interest = 0
				and a1.repayment_time >= "{qdate}"
				and a1.repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				UNION ALL
				# 债转换了个人回款
				SELECT a1.user_id uid,a1.collection_amount recover_account,a1.collection_time recover_times
				from rz_borrow.rz_bond_collection a1
				where a1.borrow_id <> 10000 and a1.status in (0,1) and a1.deleted = 0  # 记录没被删除
				and a1.bond_capital = 0 and a1.bond_interest = 0
				and a1.collection_time >= "{qdate}"
				and a1.collection_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				UNION ALL
				SELECT r.user_id uid,r.real_total recover_account,DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )
				from new_wd.borrow_collection r
				LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
				where r.`status` in (0,1,66)
				and DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY ) >= "{qdate}"
				and DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY ) < DATE_ADD("{qdate}",INTERVAL 1 day)
				and r.real_total > 0
				UNION ALL
				SELECT a3.user_id uid,a3.repayment_amount recover_account,a3.repayment_time
				from
				(
					SELECT * from new_wd.rz_borrow_collection_0 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_1 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_2 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_3 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_4 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_5 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_6 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_7 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_8 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_9 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_10 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_11 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_12 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_13 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_14 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_15 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_16 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_17 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_18 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_19 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_20 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_21 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_22 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_23 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_24 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_25 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_26 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_27 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_28 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_29 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_30 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
					SELECT * from new_wd.rz_borrow_collection_31 where status in (0,1,66) and repayment_time >=  "{qdate}" and repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				) a3
				where a3.borrow_id not in
				(
						SELECT small_borrow_id
						from new_wd.rz_financing_flow
						where tend_type = 1
						and `status` = 1
						and deleted = 0
						and ctime >=  "{qdate}"
						and ctime < DATE_ADD("{qdate}",INTERVAL 1 day)
						GROUP BY small_borrow_id
				)
		) a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		LEFT JOIN (SELECT `code`,name from rz_article.rz_channel GROUP BY `code`) q on b.utm_source = q.`code`
		GROUP BY a.uid
) a
LEFT JOIN
(
		SELECT a.user_id,sum(a.money) money
		from rz_account.rz_account_cash a
		INNER JOIN rz_user.rz_user c on a.user_id = c.uid
		where a.status in (0,1,3)  # 包含提交成功和审核通过
		and c.user_type in (1,3) # 投资人
		and a.deleted = 0  # 记录没被删除
		and a.create_time >=  "{qdate}"
		and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		GROUP BY a.user_id
) b on a.uid = b.user_id
GROUP BY a.type
;