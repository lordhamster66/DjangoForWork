# 提现详情
SELECT count(DISTINCT (a.uid)) tx_r,sum(abs(a.money)) tx_j
from 04a_3applyqueue a
LEFT JOIN 01u_0info c on a.uid=c.uid
where a.aptype=6                            #提现申请
and a.uid_ty=1                              #投资人
and c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and DATE(a.time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
;