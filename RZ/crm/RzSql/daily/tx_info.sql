# 提现内容
SELECT count(DISTINCT(a.user_id)) tx_r,sum(a.money) tx_j
from rz_account.rz_account_cash a
INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
INNER JOIN rz_user.rz_user c on a.user_id = c.uid
where a.status in (0,1,3)  # 包含提交成功和审核通过
and c.user_type = 1 # 投资人
and a.deleted = 0  # 记录没被删除
and a.create_time >=  "{qdate}"
and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
;

