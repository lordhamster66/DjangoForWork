SELECT DATE_SUB(CURDATE(),INTERVAL 1 day) qdate,a.lei term,count(DISTINCT a.uid) tx_r,sum(a.money) tx_j
from
(
		SELECT h.uid,h.money,b.cishu,
		case when b.cishu is null then "A:没投资"
		when b.cishu = 1 then "B:投资1次"
		when b.cishu >= 2 and b.cishu <= 5 then "C:2-5次"
		when b.cishu >= 6 and b.cishu <= 10 then "D:6-10次"
		when b.cishu >= 11 and b.cishu <= 20 then "E:11-20次"
		when b.cishu >= 21 then "F:21次及以上" else "不存在" end lei
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
				SELECT h1.uid,count(h1.uid) cishu
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
