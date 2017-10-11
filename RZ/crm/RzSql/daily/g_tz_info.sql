# 供应链金融投资详情
SELECT sum(a.account) g_tz_j
from
(
SELECT a1.uid,a1.account
from 05b_1tenderfinal a1
where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
and DATE(a1.time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
union all
SELECT a2.user_id uid,a2.real_amount account
from new_wd.borrow_tender a2
where a2.status = 1
and DATE(a2.add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
) a
LEFT JOIN 01u_0info b on a.uid=b.uid
where  b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
;