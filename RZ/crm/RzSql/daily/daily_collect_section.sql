SELECT DATE_SUB(CURDATE(),INTERVAL 1 day) qdate,a.lei term,count(DISTINCT a.uid) collect_r,sum(a.recover_account) collect_j
from
(
		SELECT h.uid,sum(h.recover_account) recover_account,
		case when sum(h.recover_account) < 100 then "A:小于100"
		when sum(h.recover_account) >= 100 and sum(h.recover_account) < 1000 then "B:100-1千"
		when sum(h.recover_account) >= 1000 and sum(h.recover_account) < 5000 then "C:1千-5千"
		when sum(h.recover_account) >= 5000 and sum(h.recover_account) < 10000 then "D:5千-1万"
		when sum(h.recover_account) >= 10000 and sum(h.recover_account) < 50000 then "E:1万-5万"
		when sum(h.recover_account) >= 50000 and sum(h.recover_account) < 200000 then "F:5万-20万"
		else "G:20万及以上" end lei
		from
		(
		SELECT a1.uid,a1.recover_account
		from 05b_2list_recover a1
		where a1.bid <> 10000 and a1.recover_status in (0,1)
		and a1.time_h < CURDATE()
		and a1.recover_times >= CURDATE()
		UNION ALL
		SELECT r.user_id uid,r.real_total recover_account
		from new_wd.borrow_collection r
		LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
		where r.`status` in (0,1)
		and r.add_time < CURDATE()
		and DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY ) >= CURDATE()
		and r.real_total > 0
		UNION ALL
		SELECT a3.user_id uid,a3.repayment_amount recover_account
		from (
		SELECT * from new_wd.rz_borrow_collection_0 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_1 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_2 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_3 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_4 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_5 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_6 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_7 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_8 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_9 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_10 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_11 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_12 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_13 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_14 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_15 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_16 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_17 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_18 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_19 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_20 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_21 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_22 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_23 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_24 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_25 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_26 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_27 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_28 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_29 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_30 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_31 where status in (0,1) and create_time < CURDATE() and repayment_time >= CURDATE()
		)  a3
		) h
		INNER JOIN
		(
				SELECT h1.uid,count(h1.uid)
				from
				(
						SELECT a1.uid,a1.account,a1.time_h
						from 05b_1tenderfinal a1
						where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
						and a1.time_h < CURDATE()
						union all
						SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
						from new_wd.borrow_tender a2
						where a2.status = 1
						and a2.add_time < CURDATE()
						union all
						select a3.user_id uid,a3.real_amount account,a3.create_time time_h
						from new_wd.rz_borrow_tender a3
						where a3.status = 1
						and a3.create_time < CURDATE()
				) h1
				GROUP BY h1.uid
				HAVING count(h1.uid) > 1
		) b on h.uid = b.uid
		INNER JOIN 01u_0info c on h.uid = c.uid
		where c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
		and h.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
		GROUP BY h.uid
) a
GROUP BY a.lei
;