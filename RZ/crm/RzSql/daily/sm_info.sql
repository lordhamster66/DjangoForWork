# 实名详情
SELECT count(DISTINCT(a.uid)) sm_r
from rz_cg_user_ext a
LEFT JOIN 01u_0info b on a.uid = b.uid
where DATE(a.update_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
and a.`status` = 1
and a.is_authentication = 1
and a.is_tied_card = 1
and b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
;