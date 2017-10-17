SELECT  DATE(a.time_h) qdate,count(DISTINCT(a.uid)) short_tz_r,sum(a.account) short_tz_j
from
(
			SELECT a1.bid,t1.name,t1.borrow_apr,a1.aprplus,
			case when t1.days!=0 then t1.days else t1.borrow_period*30 end qixian,
			a1.uid,a1.account,a1.time_h,a1.hbid
			from 05b_1tenderfinal a1
			INNER JOIN 05b_0base t1 on a1.bid = t1.bid
			where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
			and DATE(a1.time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			union all
			SELECT a2.borrow_id bid,t2.name,t2.apr,'0' aprplus,
			case when t2.borrow_time_type!=0 then t2.time_limit else t2.time_limit*30 end qixian,
			a2.user_id uid,a2.real_amount account,a2.add_time time_h,'0' hbid
			from new_wd.borrow_tender a2
			INNER JOIN new_wd.borrow t2 on a2.borrow_id = t2.id
			where a2.status = 1
			and DATE(a2.add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			union all
			SELECT a3.borrow_id bid,t3.name,t3.apr,'0' aprplus,
			case when t3.borrow_time_type!=0 then t3.time_limit else t3.time_limit*30 end qixian,
			a3.user_id uid,a3.real_amount account,a3.create_time time_h,'0' hbid
			from (
						(SELECT * FROM new_wd.rz_borrow_tender_0 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_1 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_2 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_3 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_4 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_5 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_6 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_7 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_8 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_9 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_10 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_11 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_12 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_13 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_14 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_15 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_16 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_17 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_18 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_19 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_20 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_21 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_22 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_23 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_24 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_25 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_26 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_27 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_28 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_29 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_30 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
						(SELECT * FROM new_wd.rz_borrow_tender_31 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))
					) a3
			INNER JOIN new_wd.rz_borrow_big t3 on a3.big_borrow_id = t3.id
) a
INNER JOIN 01u_0info b on a.uid=b.uid
where  b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and a.qixian < 30  # 30天以内短标
GROUP BY DATE(a.time_h)

