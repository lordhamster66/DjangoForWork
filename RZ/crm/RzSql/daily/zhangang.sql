SELECT SUM(a.balance) zg_j,COUNT(DISTINCT a.objid) zg_r
from
(
SELECT a.objid,sum(a.balance) balance
from 04a_0base a
LEFT JOIN 01u_0info b on a.objid = b.uid
where a.objtype = "uid"
and a.atid <> 4
and b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.objid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
GROUP BY a.objid
HAVING sum(a.balance) > 0
) a
