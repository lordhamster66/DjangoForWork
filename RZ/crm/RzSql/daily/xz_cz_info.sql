# 新增充值
SELECT ifnull(sum(a.money),0) xz_cz
from rz_account.rz_account_recharge a
INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
INNER JOIN
(
	SELECT a.user_id,min(a.create_time) min_recharge_time
	from rz_account.rz_account_recharge a
	where a.status = 1
	and a.deleted = 0
	GROUP BY a.user_id
) c on a.user_id = c.user_id and DATE(a.create_time) = DATE(c.min_recharge_time)
where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.user_id not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and a.status = 1  # 充值成功
and a.deleted = 0  # 记录没被删除
and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
;