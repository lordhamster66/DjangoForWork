# 各时间段投资人数详情
SELECT sj.shijian timeslot,case when sx.renshu is null then 0 else sx.renshu end tz_r
from
(
	SELECT DATE_FORMAT(aa.create_time,"%H") shijian
	from rz_borrow.rz_borrow_tender aa
	GROUP BY DATE_FORMAT(aa.create_time,"%H")
) sj
LEFT JOIN
(
	SELECT DATE_FORMAT(a.time_h,"%H") shijian,count(DISTINCT(a.uid)) renshu
	from
	(
			SELECT user_id uid,create_time time_h,real_amount account
			from rz_borrow.rz_borrow_tender
			where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6) and deleted = 0  # 记录没被删除
			and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
			and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
			UNION ALL
			SELECT user_id,add_time,real_amount
			from new_wd.borrow_tender
			where status = 1
			and add_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
			and add_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
			UNION ALL
			SELECT a3.user_id,a3.create_time,a3.real_amount
			from new_wd.rz_borrow_tender a3
			where a3.`status` = 1
			and a3.create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a3.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
	) a
	INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
	where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
	and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
	GROUP BY DATE_FORMAT(a.time_h,"%H")
) sx
on sj.shijian=sx.shijian
;
