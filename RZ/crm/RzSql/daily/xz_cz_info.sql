# 新增充值
SELECT ifnull(sum(a.money),0) xz_cz
from rz_account.rz_account_recharge a
INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
INNER JOIN rz_user.rz_user c on a.user_id = c.uid
INNER JOIN
(
	SELECT a.user_id,min(a.create_time) min_recharge_time
	from rz_account.rz_account_recharge a
	where a.status = 1
	and a.deleted = 0
	GROUP BY a.user_id
) c on a.user_id = c.user_id and DATE(a.create_time) = DATE(c.min_recharge_time)
where a.status = 1  # 充值成功
and a.deleted = 0  # 记录没被删除
and c.user_type in (1,3) # 投资人
and a.create_time >=  "{qdate}"
and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
;