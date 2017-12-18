SELECT count(DISTINCT(a.uid)) tz_dl_r
from
(
	SELECT a.id uid
	from zzz_ctlog_l_uid_loginsuc a
	where DATE(a.time_h) = DATE_SUB(CURDATE(),INTERVAL 1 DAY)
) a
INNER JOIN
(
			SELECT a.uid
      from
      (
					SELECT uid
					from 05b_1tenderfinal
					where orguid=0 and bid <> 10000 and status in (1,3)
					and DATE(time_h) < CURDATE()
					UNION
					SELECT user_id
					from new_wd.borrow_tender
					where status = 1
					and DATE(add_time) < CURDATE()
					UNION
					SELECT user_id
					from new_wd.rz_borrow_tender
					where status = 1
					and DATE(create_time) < CURDATE()
			) a
			INNER JOIN 01u_0info b on a.uid = b.uid
			where b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
			and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
) t on a.uid = t.uid
