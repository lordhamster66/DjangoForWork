SELECT DATE_SUB(CURDATE(),INTERVAL 1 day) qdate,a.lei term,count(DISTINCT a.uid) tx_r,sum(a.money) tx_j
from
(
		SELECT h.uid,h.money,b.time_interval,
		case when b.time_interval is null then "A:没投资"
		when b.time_interval < 10 then "B:0-10天"
		when b.time_interval >= 10 and b.time_interval < 30 then "C:10-30天"
		when b.time_interval >= 30 and b.time_interval < 60 then "D:30-60天"
		when b.time_interval >= 60 and b.time_interval < 90 then "E:60-90天"
		else "F:90天及以上" end lei
		from
		(
				SELECT a.uid,sum(a.money) money
				from 04a_3applyqueue a
				INNER JOIN 01u_0info b on a.uid = b.uid
				where a.aptype=6                            #提现申请
				and a.uid_ty=1                              #投资人
				and a.status=3
				and b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
				and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
				and a.time_h < CURDATE()
				GROUP BY a.uid
		) h
		LEFT JOIN
		(
				SELECT h1.uid,(UNIX_TIMESTAMP(max(h1.time_h)) - UNIX_TIMESTAMP(min(h1.time_h)))/86400 time_interval
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
		) b on h.uid = b.uid
) a
GROUP BY a.lei
;