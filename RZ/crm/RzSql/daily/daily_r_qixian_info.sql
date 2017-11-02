# R计划
SELECT DATE(a.time_h) qdate,a.term,count(DISTINCT a.uid) tz_r,sum(a.account) tz_j
from
(
		SELECT a.uid,a.account,case when a.qixian < 10 then "A:1-10天"
		when a.qixian >= 10 and a.qixian < 30 then "B:10-30天"
		when a.qixian >= 30 and a.qixian < 60 then "C:1月标"
		when a.qixian >= 60 and a.qixian < 90 then "D:2月标"
		when a.qixian >= 90 and a.qixian < 180 then "E:3月标"
		else "F:6月标及以上"
		end term,a.time_h
		from
		(
				SELECT a3.borrow_id bid,t3.name,t3.apr,'0' aprplus,
				case when t3.borrow_time_type!=0 then t3.time_limit else t3.time_limit*30 end qixian,
				a3.user_id uid,a3.real_amount account,a3.create_time time_h,'0' hbid
				from (
							(SELECT * FROM new_wd.rz_borrow_tender_0 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_1 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_2 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_3 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_4 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_5 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_6 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_7 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_8 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_9 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_10 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_11 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_12 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_13 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_14 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_15 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_16 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_17 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_18 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_19 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_20 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_21 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_22 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_23 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_24 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_25 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_26 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_27 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_28 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_29 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_30 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())  union all
							(SELECT * FROM new_wd.rz_borrow_tender_31 where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE())
						) a3
						INNER JOIN new_wd.rz_borrow_big t3 on a3.big_borrow_id = t3.id
					where t3.product_id = 10020
		) a
		INNER JOIN  01u_0info c on a.uid=c.uid
		where  c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
		and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
) a
GROUP BY a.term
;