# 首充内容
SELECT count(DISTINCT(a.user_id)) sc_r
from rz_account.rz_account_recharge a
INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
# 限定是首次充值
INNER JOIN (SELECT user_id,min(id) min_id from rz_account.rz_account_recharge where status = 1 and deleted = 0 GROUP BY user_id) c on a.user_id = c.user_id and a.id = c.min_id
where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.user_id not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and a.status = 1  # 充值成功
and a.deleted = 0  # 记录没被删除
and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
;
