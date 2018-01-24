# 非R计划续投回款详情
SELECT a.hk_j - b.Rplan_xt
from
(
		# 回款详情
		SELECT 1 id,sum(a.recover_account) hk_j
		from
		(
				# 没债转的回款
				SELECT a1.user_id uid,a1.repayment_amount recover_account,a1.repayment_time recover_times
				from rz_borrow.rz_borrow_collection a1
				where a1.borrow_id <> 10000 and a1.status in (0,1,2) and a1.deleted = 0  # 记录没被删除
				and a1.bond_capital = 0 and a1.bond_interest = 0  # 剔除债转的
				and a1.repayment_time >= "{qdate}"
				and a1.repayment_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				UNION ALL
				# 债转换了个人回款
				SELECT a1.user_id uid,a1.collection_amount recover_account,a1.collection_time recover_times
				from rz_borrow.rz_bond_collection a1
				where a1.borrow_id <> 10000 and a1.status in (0,1) and a1.deleted = 0  # 记录没被删除
				and a1.bond_capital = 0 and a1.bond_interest = 0  # 剔除再债转的
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
		) a
) a
INNER JOIN
(
		SELECT 1 id,sum(money) Rplan_xt
		from new_wd.rz_financing_flow
		where tend_type = 1
		and `status` = 1
		and ctime >=  "{qdate}"
		and ctime < DATE_ADD("{qdate}",INTERVAL 1 day)
) b on a.id = b.id
;
