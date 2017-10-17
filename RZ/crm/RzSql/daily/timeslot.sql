# 各时间段投资人数详情
SELECT sj.shijian timeslot,case when sx.renshu is null then 0 else sx.renshu end tz_r
from
(
	SELECT substring(aa.time_h,12,2) shijian
	from 05b_1tenderfinal aa
	GROUP BY substring(aa.time_h,12,2)
) sj
LEFT JOIN
(
	SELECT substring(a.time_h,12,2) shijian,count(DISTINCT(a.uid)) renshu
	from
	(
			SELECT uid,time_h,account from 05b_1tenderfinal
			where orguid=0 and bid <> 10000 and status in (1,3)
			and DATE(time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			UNION ALL
			SELECT user_id,add_time,real_amount from new_wd.borrow_tender
			where status = 1
			and DATE(add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			UNION ALL
			SELECT a3.user_id,a3.create_time,a3.real_amount from
			(
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
	) a
	INNER JOIN 01u_0info c on a.uid=c.uid
	where  c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
	and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
	GROUP BY substring(a.time_h,12,2)
) sx
on sj.shijian=sx.shijian
;


