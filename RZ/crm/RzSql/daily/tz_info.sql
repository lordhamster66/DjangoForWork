SELECT sum(a.tz_r) tz_r,sum(a.tz_j) tz_j,sum(a.tz_b) tz_b
from
(
		SELECT count(DISTINCT(a.uid)) tz_r,0 tz_j,count(a.uid) tz_b
		from
		(
			SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
			from rz_borrow.rz_borrow_tender a1
			where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
			and a1.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a1.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
			union all
			SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
			from new_wd.borrow_tender a2
			where a2.status = 1
			and a2.add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a2.add_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
			union all
			select a3.user_id uid,a3.real_amount account,a3.create_time time_h
			from new_wd.rz_borrow_tender a3
			where a3.status = 1
			and a3.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a3.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
		) a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
		and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
		UNION ALL
		SELECT 0 tz_r,sum(a.account) tz_j,0 tz_b
		from
		(
			SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
			from rz_borrow.rz_borrow_tender a1
			where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
			and a1.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a1.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
			union all
			SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
			from new_wd.borrow_tender a2
			where a2.status = 1
			and a2.add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a2.add_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
			union all
			SELECT a3.user_id uid,a3.real_amount account,a3.create_time time_h
			from
			(
					(SELECT * FROM new_wd.rz_borrow_tender_0 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_1 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_2 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_3 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_4 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_5 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_6 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_7 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_8 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_9 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_10 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_11 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_12 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_13 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_14 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_15 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_16 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_17 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_18 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_19 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_20 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_21 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_22 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_23 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_24 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_25 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_26 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_27 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_28 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_29 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_30 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT * FROM new_wd.rz_borrow_tender_31 where `status` = 1 and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))
			) a3
		) a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
		and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
) a