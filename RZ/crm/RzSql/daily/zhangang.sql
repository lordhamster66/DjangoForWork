SELECT SUM(a.balance) zg_j,COUNT(DISTINCT a.objid) zg_r
from
(
SELECT a.objid,sum(a.balance) balance
from 04a_0base a
INNER JOIN 01u_0info b on a.objid = b.uid
LEFT JOIN (SELECT uid from 01u_0info where mobile like "JM%") c on a.objid = c.uid      # 机密借款人注册
where a.objtype = "uid"
and a.atid <> 4
and c.uid is null  # 剔除机密借款人
and b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.objid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
GROUP BY a.objid
HAVING sum(a.balance) > 0
) a