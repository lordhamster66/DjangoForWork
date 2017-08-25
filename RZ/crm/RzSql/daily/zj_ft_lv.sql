SELECT sum(h.futou)/sum(h.recover_account) zj_ft_lv
from
(
		SELECT a.uid,sum(a.recover_account) recover_account,sum(a.account) account,
		case when  sum(a.recover_account) >= sum(a.account) then sum(a.account) else sum(a.recover_account) end futou
		from
		(
					SELECT a.uid,sum(a.account) account,0 recover_account
					from
					(
								SELECT a1.uid,a1.account
								from 05b_1tenderfinal a1
								where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
								and DATE(a1.time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
								union all
								SELECT a2.user_id uid,a2.real_amount account
								from new_wd.borrow_tender a2
								where a2.status = 1
								and DATE(a2.add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
								union all
								SELECT a3.user_id uid,a3.real_amount account
								from new_wd.rz_borrow_tender a3
								where a3.`status` = 1
								and DATE(a3.create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
					) a
					LEFT JOIN 01u_0info b on a.uid=b.uid
					where  b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
					and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
					GROUP BY a.uid
					UNION ALL
					SELECT h.uid,0 account,sum(h.recover_account) recover_account
					from
					 (
							SELECT a1.uid,a1.recover_account
							from 05b_2list_recover a1
							where a1.bid <> 10000 and a1.recover_status in (0,1)
							and DATE(a1.recover_times) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT r.user_id uid,r.real_total recover_account
							from new_wd.borrow_collection r
							LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
							where r.`status` in (0,1)
							and DATE(DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							and r.real_total > 0
							UNION ALL
							SELECT a3.user_id uid,a3.repayment_amount recover_account
							from new_wd.rz_borrow_collection a3
							where a3.`status` in (0,1)
							and DATE(a3.repayment_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
					 ) h
					LEFT JOIN 01u_0info c on h.uid = c.uid
					where c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
					and h.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
					GROUP BY h.uid
		) a
		GROUP BY a.uid
) h
;

