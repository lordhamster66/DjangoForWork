# 消费金融投资详情
SELECT sum(a.account) x_tz_j
from
(
		SELECT a3.user_id uid,a3.real_amount account
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
;