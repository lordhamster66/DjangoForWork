# 回款详情
SELECT count(DISTINCT h.uid) hk_r,sum(h.recover_account) hk_j
from
(
SELECT a1.uid,a1.recover_account,a1.recover_times
from 05b_2list_recover a1
where a1.bid <> 10000 and a1.recover_status in (0,1)
and DATE(a1.recover_times) = DATE_SUB(curdate(),INTERVAL 1 DAY)
UNION ALL
SELECT r.user_id uid,r.real_total recover_account,DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )
from new_wd.borrow_collection r
LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
where r.`status` in (0,1)
and DATE(DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )) = DATE_SUB(curdate(),INTERVAL 1 DAY)
and r.real_total > 0
UNION ALL
SELECT a3.user_id uid,a3.repayment_amount recover_account,a3.repayment_time
from (
			SELECT * from new_wd.rz_borrow_collection_0 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_1 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_2 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_3 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_4 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_5 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_6 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_7 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_8 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_9 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_10 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_11 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_12 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_13 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_14 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_15 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_16 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_17 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_18 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_19 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_20 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_21 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_22 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_23 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_24 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_25 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_26 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_27 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_28 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_29 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_30 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY) UNION ALL
			SELECT * from new_wd.rz_borrow_collection_31 where status in (0,1) and DATE(repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							) a3
) h
INNER JOIN 01u_0info c on h.uid = c.uid
where c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and h.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
;