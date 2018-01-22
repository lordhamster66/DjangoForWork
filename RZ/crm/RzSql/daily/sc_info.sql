# 首充内容
SELECT count(DISTINCT(a.user_id)) sc_r
from rz_account.rz_account_recharge a
INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
# 限定是首次充值
INNER JOIN (SELECT user_id,min(id) min_id from rz_account.rz_account_recharge where status = 1 and deleted = 0 GROUP BY user_id) c on a.user_id = c.user_id and a.id = c.min_id
where a.status = 1  # 充值成功
and a.deleted = 0  # 记录没被删除
and a.create_time >=  "{qdate}"
and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
;