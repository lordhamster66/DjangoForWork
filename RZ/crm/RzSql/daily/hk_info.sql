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
from new_wd.rz_borrow_collection a3
where a3.`status` in (0,1)
and DATE(a3.repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
) h
LEFT JOIN 01u_0info c on h.uid = c.uid
where c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and h.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
;