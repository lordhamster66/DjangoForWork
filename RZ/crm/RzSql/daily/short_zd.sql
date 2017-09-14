#30天以内短标待收
SELECT  sum(h.recover_account) short_zd_j
from
     (
				SELECT a1.uid,t2.time_h,t1.name,
				case when t1.days!=0 then t1.days else t1.borrow_period*30 end qixian,
				a1.recover_account,a1.recover_capital,a1.recover_interest,
				a1.recover_times,a1.bid
				from 05b_2list_recover a1
				LEFT JOIN 05b_0base t1 on a1.bid = t1.bid
				LEFT JOIN 05b_1tenderfinal t2 on a1.tender_id = t2.id
				where a1.bid <> 10000 and a1.recover_status in (0,1)
				and DATE(t2.time_h) <= DATE_SUB(curdate(),INTERVAL 1 DAY)
				and DATE(a1.recover_times) > DATE_SUB(curdate(),INTERVAL 1 DAY)
				UNION ALL
				SELECT r.user_id uid,t2.add_time time_h,t1.name,
				case when t1.borrow_time_type!=0 then t1.time_limit else t1.time_limit*30 end qixian,
				r.real_total recover_account,r.real_capital recover_capital,r.real_interest recover_interest,
				DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )as recover_times,r.borrow_id
				from new_wd.borrow_collection r
				LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
				LEFT JOIN new_wd.borrow_tender t2 on r.tender_id = t2.id
				where r.`status` in (0,1)
				and DATE(t2.add_time) <= DATE_SUB(curdate(),INTERVAL 1 DAY)
				and DATE(DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )) > DATE_SUB(curdate(),INTERVAL 1 DAY)
				and r.real_total > 0
				UNION ALL
				SELECT a3.user_id uid,t2.create_time time_h,t1.name,
				case when t1.borrow_time_type!=0 then t1.time_limit else t1.time_limit*30 end qixian,
				a3.repayment_amount recover_account,a3.capital recover_capital,a3.interest recover_interest,
				a3.repayment_time recover_times,a3.borrow_id
				from new_wd.rz_borrow_collection a3
				LEFT JOIN new_wd.rz_borrow_big t1 on a3.borrow_id = t1.id
				LEFT JOIN new_wd.rz_borrow_tender t2 on a3.tender_id = t2.id
				where a3.`status` in (0,1)
				and DATE(t2.create_time) <= DATE_SUB(curdate(),INTERVAL 1 DAY)
				and DATE(a3.repayment_time) > DATE_SUB(curdate(),INTERVAL 1 DAY)
     ) h
LEFT JOIN 01u_0info c on h.uid = c.uid
LEFT JOIN 01u_0base b on h.uid = b.uid
where c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and h.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and h.qixian < 30  # 30天以内短标