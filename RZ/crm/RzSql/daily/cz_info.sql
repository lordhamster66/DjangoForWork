# 充值内容
SELECT count(DISTINCT(a.user_id)) cz_r,sum(a.money) cz_j
from rz_account.rz_account_recharge a
INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
INNER JOIN rz_user.rz_user c on a.user_id = c.uid
where a.status = 1  # 充值成功
and a.deleted = 0  # 记录没被删除
and c.user_type in (1,3)  # 投资人
and a.create_time >=  "{qdate}"
and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
;