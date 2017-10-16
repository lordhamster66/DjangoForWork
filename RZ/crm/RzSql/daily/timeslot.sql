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
			SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
			where status = 1
			and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
	) a
	INNER JOIN 01u_0info c on a.uid=c.uid
	where  c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
	and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
	GROUP BY substring(a.time_h,12,2)
) sx
on sj.shijian=sx.shijian
;


