SELECT COUNT(DISTINCT if(h.futou =0,null,h.uid))/COUNT(DISTINCT if(h.recover_account =0,null,h.uid)) rs_ft_lv
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
								and DATE(a1.time_h) = DATE_SUB(CURDATE(),INTERVAL 1 DAY)
								union all
								SELECT a2.user_id uid,a2.real_amount account
								from new_wd.borrow_tender a2
								where a2.status = 1
								and DATE(a2.add_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY)
								union all
								SELECT a3.user_id uid,a3.real_amount account
								from (
											(SELECT * FROM new_wd.rz_borrow_tender_0 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_1 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_2 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_3 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_4 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_5 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_6 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_7 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_8 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_9 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_10 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_11 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_12 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_13 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_14 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_15 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_16 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_17 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_18 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_19 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_20 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_21 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_22 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_23 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_24 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_25 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_26 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_27 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_28 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_29 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_30 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))  union all
											(SELECT * FROM new_wd.rz_borrow_tender_31 where `status` = 1 and DATE(create_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY))
										) a3
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
							and DATE(a1.recover_times) = DATE_SUB(CURDATE(),INTERVAL 1 DAY)
							UNION ALL
							SELECT r.user_id uid,r.real_total recover_account
							from new_wd.borrow_collection r
							LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
							where r.`status` in (0,1)
							and DATE(DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )) = DATE_SUB(CURDATE(),INTERVAL 1 DAY)
							and r.real_total > 0
							UNION ALL
							SELECT a3.user_id uid,a3.repayment_amount recover_account
							from (
										SELECT * from new_wd.rz_borrow_collection_0 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_1 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_2 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_3 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_4 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_5 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_6 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_7 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_8 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_9 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_10 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_11 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_12 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_13 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_14 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_15 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_16 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_17 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_18 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_19 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_20 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_21 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_22 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_23 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_24 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_25 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_26 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_27 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_28 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_29 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_30 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY) UNION ALL
										SELECT * from new_wd.rz_borrow_collection_31 where status in (0,1) and DATE(repayment_time) = DATE_SUB(CURDATE(),INTERVAL 1 DAY)
							) a3
					 ) h
					LEFT JOIN 01u_0info c on h.uid = c.uid
					where c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
					and h.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
					GROUP BY h.uid
		) a
		GROUP BY a.uid
) h
;

