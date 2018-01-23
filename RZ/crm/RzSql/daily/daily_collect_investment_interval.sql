# 待收投资时间间隔
SELECT a.lei term,count(DISTINCT a.uid) collect_r,sum(a.recover_account) collect_j
from
(
		SELECT h.uid,sum(h.recover_account) recover_account,b.time_interval,
		case when b.time_interval < 10 then "A:0-10天"
		when b.time_interval >= 10 and b.time_interval < 30 then "B:10-30天"
		when b.time_interval >= 30 and b.time_interval < 60 then "C:30-60天"
		when b.time_interval >= 60 and b.time_interval < 90 then "D:60-90天"
		else "E:90天及以上" end lei
		from
		(
					# 没债转的在贷
					SELECT a.user_id uid,a.repayment_amount recover_account
					from rz_borrow.rz_borrow_collection a
					INNER JOIN rz_borrow.rz_borrow b on a.borrow_id=b.id
					where b.full_time != "0000-00-00 00:00:00"
					and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day)
					and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day)
					and a.status in (0,1,2) and a.deleted = 0  # 记录没被删除
					and a.bond_capital = 0 and a.bond_interest = 0  # 剔除债转的
					UNION ALL
					# 债转换了个人的在贷
					SELECT a.user_id uid,a.collection_amount recover_account
					from rz_borrow.rz_bond_collection a
					INNER JOIN rz_borrow.rz_borrow b on a.borrow_id=b.id
					where b.full_time != "0000-00-00 00:00:00"
					and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day)
					and a.collection_time >= DATE_ADD("{qdate}",INTERVAL 1 day)
					and a.status in (0,1) and a.deleted = 0  # 记录没被删除
					and a.bond_capital = 0 and a.bond_interest = 0  # 剔除再债转的
					UNION ALL
					SELECT  a.user_id,a.repayment_amount
					from
					(
							SELECT a.* from new_wd.rz_borrow_collection_0 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day)  UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_1 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_2 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_3 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_4 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_5 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_6 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_7 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_8 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_9 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_10 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_11 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_12 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_13 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_14 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_15 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_16 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_17 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_18 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_19 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_20 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_21 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_22 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_23 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_24 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_25 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_26 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_27 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_28 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_29 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_30 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_31 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id where a.`status` in (0,1,66) and b.product_id<>10020 and b.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and b.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day)
					) a
					UNION ALL
					SELECT  a.user_id,a.repayment_amount
					from
					(
							SELECT a.* from new_wd.rz_borrow_collection_0 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_1 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_2 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_3 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_4 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_5 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_6 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_7 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_8 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_9 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_10 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_11 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_12 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_13 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_14 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_15 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_16 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_17 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_18 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_19 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_20 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_21 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_22 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_23 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_24 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_25 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_26 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_27 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_28 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_29 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_30 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day) UNION ALL
							SELECT a.* from new_wd.rz_borrow_collection_31 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id=b.id INNER JOIN new_wd.rz_borrow c on a.borrow_id=c.id where a.`status` in (0,1,66) and b.product_id=10020 and c.full_time < DATE_ADD("{qdate}",INTERVAL 1 day) and c.full_time <> "0000-00-00 00:00:00" and a.repayment_time >= DATE_ADD("{qdate}",INTERVAL 1 day)
					) a
		) h
		INNER JOIN
		(
				SELECT h1.uid,(UNIX_TIMESTAMP(max(h1.time_h)) - UNIX_TIMESTAMP(min(h1.time_h)))/86400 time_interval
				from
				(
							SELECT a1.user_id uid,a1.money account,a1.create_time time_h
							from rz_borrow.rz_borrow_tender a1
							where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
							and a1.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
							union all
							SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
							from new_wd.borrow_tender a2
							where a2.status = 1
							and a2.add_time < DATE_ADD("{qdate}",INTERVAL 1 day)
							union all
							select a3.user_id uid,a3.real_amount account,a3.create_time time_h
							from new_wd.rz_borrow_tender a3
							where a3.status = 1
							and a3.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				) h1
				GROUP BY h1.uid
				HAVING count(h1.uid) > 1
		) b on h.uid = b.uid
		GROUP BY h.uid
) a
GROUP BY a.lei
;