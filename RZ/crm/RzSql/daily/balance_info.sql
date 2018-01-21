# 站岗内容
SELECT SUM(a.balance) zg_j,COUNT(DISTINCT a.objid) zg_r
from
(
  SELECT a.objid,sum(a.balance) balance
  from rz_account.rz_account a
  INNER JOIN rz_user.rz_user_base_info b on a.objid = b.user_id
  LEFT JOIN (SELECT uid from rz_user.rz_user where reg_mobile like "JM%") j on a.objid = j.uid      # 机密借款人注册
  where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
  and a.objid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
  and j.uid is null  # 剔除机密借款人
  and a.deleted = 0  # 记录没被删除
  and a.objtype = "uid"
  GROUP BY a.objid
  HAVING sum(a.balance) > 0
) a