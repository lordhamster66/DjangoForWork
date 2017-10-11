# 消费金融投资详情
SELECT sum(a.account) x_tz_j
from
(
SELECT a3.user_id uid,a3.real_amount account
from new_wd.rz_borrow_tender a3
where a3.`status` = 1
and DATE(a3.create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
) a
LEFT JOIN 01u_0info b on a.uid=b.uid
where  b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
;