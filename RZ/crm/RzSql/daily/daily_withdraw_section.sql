SELECT DATE_SUB(CURDATE(),INTERVAL 1 day) qdate,a.lei term,count(DISTINCT a.uid) tx_r,sum(a.money) tx_j
from
(
		SELECT a.uid,sum(a.money) money,
		case when sum(a.money) < 100 then "A:小于100"
		when sum(a.money) >= 100 and sum(a.money) < 1000 then "B:100-1千"
		when sum(a.money) >= 1000 and sum(a.money) < 5000 then "C:1千-5千"
		when sum(a.money) >= 5000 and sum(a.money) < 10000 then "D:5千-1万"
		when sum(a.money) >= 10000 and sum(a.money) < 50000 then "E:1万-5万"
		when sum(a.money) >= 50000 and sum(a.money) < 200000 then "F:5万-20万"
		else "G:20万及以上" end lei
		from 04a_3applyqueue a
		INNER JOIN 01u_0info b on a.uid = b.uid
		where a.aptype=6                            #提现申请
		and a.uid_ty=1                              #投资人
		and a.status=3
		and b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
		and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
		and a.time_h < CURDATE()
		GROUP BY a.uid
) a
GROUP BY a.lei
;