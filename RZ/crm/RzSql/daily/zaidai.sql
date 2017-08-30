SELECT sum(h.recover_account) zd_j,count(DISTINCT h.uid) zd_r
from
     (
					SELECT a1.uid,t2.time_h,t1.name,a1.recover_account,a1.recover_capital,a1.recover_interest,a1.recover_times,a1.bid
					from 05b_2list_recover a1
					LEFT JOIN 05b_0base t1 on a1.bid = t1.bid
					LEFT JOIN 05b_1tenderfinal t2 on a1.tender_id = t2.id
					where a1.bid <> 10000 and a1.recover_status in (0,1)
					and date(t2.time_h) <= DATE_SUB(curdate(),INTERVAL 1 DAY)
					and date(a1.recover_times) > DATE_SUB(curdate(),INTERVAL 1 DAY)
					UNION ALL
					SELECT r.user_id uid,t2.add_time time_h,t1.name,
					r.real_total recover_account,r.real_capital recover_capital,r.real_interest recover_interest,
					DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )as recover_times,r.borrow_id
					from new_wd.borrow_collection r
					LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
					LEFT JOIN new_wd.borrow_tender t2 on r.tender_id = t2.id
					where r.`status` in (0,1)
					and date(t2.add_time) <= DATE_SUB(curdate(),INTERVAL 1 DAY)
					and date(DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )) > DATE_SUB(curdate(),INTERVAL 1 DAY)
					and r.real_total > 0
					UNION ALL
					SELECT a3.user_id uid,t2.create_time time_h,t1.name,
					a3.repayment_amount recover_account,a3.capital recover_capital,a3.interest recover_interest,
					a3.repayment_time recover_times,a3.borrow_id
					from new_wd.rz_borrow_collection a3
					LEFT JOIN new_wd.rz_borrow_big t1 on a3.borrow_id = t1.id
					LEFT JOIN new_wd.rz_borrow_tender t2 on a3.tender_id = t2.id
					where a3.`status` in (0,1)
					and date(t2.create_time) <= DATE_SUB(curdate(),INTERVAL 1 DAY)
					and date(a3.repayment_time) > DATE_SUB(curdate(),INTERVAL 1 DAY)
     ) h
LEFT JOIN 01u_0info c on h.uid = c.uid
where c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and h.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
