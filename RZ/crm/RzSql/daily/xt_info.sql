# 续投金额
SELECT sum(a.account) xt_j
from
(
	SELECT uid,time_h,account from 05b_1tenderfinal
	where orguid=0 and bid <> 10000 and status in (1,3)
	and time_h >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
	and time_h < CURDATE()
	UNION ALL
	SELECT user_id,add_time,real_amount from new_wd.borrow_tender
	where status = 1
	and add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
	and add_time < CURDATE()
	UNION ALL
	SELECT a3.user_id,a3.create_time,a3.real_amount from (
				(SELECT * FROM new_wd.rz_borrow_tender_0 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_1 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_2 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_3 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_4 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_5 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_6 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_7 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_8 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_9 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_10 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_11 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_12 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_13 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_14 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_15 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_16 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_17 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_18 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_19 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_20 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_21 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_22 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_23 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_24 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_25 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_26 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_27 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_28 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_29 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_30 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )  union all
				(SELECT * FROM new_wd.rz_borrow_tender_31 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()   )
			) a3
) a
INNER JOIN
(
		SELECT a1.uid
		from 05b_2list_recover a1
		where a1.bid <> 10000 and a1.recover_status in (0,1,66)
		and a1.recover_times >= DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a1.recover_times < CURDATE()
		UNION
		SELECT a3.user_id uid
		from (
					SELECT * from new_wd.rz_borrow_collection_0 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_1 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_2 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_3 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_4 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_5 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_6 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_7 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_8 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_9 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_10 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_11 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_12 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_13 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_14 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_15 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_16 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_17 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_18 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_19 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_20 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_21 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_22 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_23 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_24 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_25 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_26 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_27 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_28 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_29 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_30 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
					UNION ALL
					SELECT * from new_wd.rz_borrow_collection_31 where status in (0,1) and repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and repayment_time < CURDATE()
	) a3
) b on a.uid = b.uid
INNER JOIN 01u_0info c on a.uid=c.uid
LEFT JOIN
(
		SELECT a.uid
		from 04a_3applyqueue a
		LEFT JOIN 01u_0info b on a.uid=b.uid
		where a.aptype = 7
		and a.uid_ty = 1
		and a.`status` = 3
		and a.time_h >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.time_h < CURDATE()
		GROUP BY a.uid
) d on a.uid = d.uid
where c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and d.uid is null  # 未充值
;