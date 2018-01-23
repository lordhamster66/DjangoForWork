# 投资内容
SELECT sum(a.tz_r) tz_r,sum(a.tz_j) tz_j,sum(a.tz_b) tz_b
from
(
		SELECT count(DISTINCT(a.uid)) tz_r,0 tz_j,count(a.uid) tz_b
		from
		(
			SELECT a1.user_id uid,a1.money account,a1.create_time time_h
			from rz_borrow.rz_borrow_tender a1
			where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
			and a1.create_time >=  "{qdate}"
			and a1.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
			union all
			SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
			from new_wd.borrow_tender a2
			where a2.status = 1
			and a2.add_time >=  "{qdate}"
			and a2.add_time < DATE_ADD("{qdate}",INTERVAL 1 day)
			union all
			select a3.user_id uid,a3.real_amount account,a3.create_time time_h
			from new_wd.rz_borrow_tender a3
			where a3.status = 1
			and a3.create_time >=  "{qdate}"
			and a3.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		) a
		UNION ALL
		SELECT 0 tz_r,sum(a.account) tz_j,0 tz_b
		from
		(
			SELECT a1.user_id uid,a1.money account,a1.create_time time_h
			from rz_borrow.rz_borrow_tender a1
			where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
			and a1.create_time >=  "{qdate}"
			and a1.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
			union all
			SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
			from new_wd.borrow_tender a2
			where a2.status = 1
			and a2.add_time >=  "{qdate}"
			and a2.add_time < DATE_ADD("{qdate}",INTERVAL 1 day)
			union all
			SELECT a3.user_id uid,a3.real_amount account,a3.create_time time_h
			from
			(
					(SELECT * FROM new_wd.rz_borrow_tender_0 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_1 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_2 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_3 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_4 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_5 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_6 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_7 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_8 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_9 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_10 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_11 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_12 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_13 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_14 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_15 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_16 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_17 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_18 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_19 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_20 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_21 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_22 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_23 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_24 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_25 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_26 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_27 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_28 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_29 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_30 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_31 where `status` = 1 and create_time >=  "{qdate}" and create_time < DATE_ADD("{qdate}",INTERVAL 1 day))
			) a3
		) a
) a
;