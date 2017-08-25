SELECT sum(a.money) hk_cz
from 04a_3applyqueue a
LEFT JOIN 01u_0info b on a.uid=b.uid
LEFT JOIN
(
  SELECT uid,min(time_h) min_time
  from 04a_3applyqueue
  where aptype = 7 and uid_ty = 1 and `status` = 3
  GROUP BY uid
) c on a.uid = c.uid
LEFT JOIN
(
			SELECT a1.uid
			from 05b_2list_recover a1
			where a1.bid <> 10000 and a1.recover_status in (0,1)
			and DATE(a1.recover_times) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			UNION
			SELECT r.user_id uid
			from new_wd.borrow_collection r
			LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
			where r.`status` in (0,1)
			and DATE(DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			and r.real_total > 0
			UNION
			SELECT a3.user_id uid
			from new_wd.rz_borrow_collection a3
			where a3.`status` in (0,1)
			and DATE(a3.repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
) d on a.uid = d.uid
where a.aptype = 7
and a.uid_ty = 1
and a.`status` = 3
and b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and DATE(a.time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
and DATE(a.time_h)  != DATE(c.min_time)
and a.uid = d.uid
;





