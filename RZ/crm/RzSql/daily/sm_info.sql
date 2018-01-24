# 实名人数
SELECT count(DISTINCT(a.uid)) sm_r
from rz_user.rz_user a
INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
LEFT JOIN (SELECT uid from rz_user.rz_user where reg_mobile like "JM%") j on a.uid = j.uid      # 机密借款人注册
where a.real_name_status = 1  # 实名
and j.uid is null  # 剔除机密借款人
and a.deleted = 0  # 记录没被删除
and a.user_type in (1,3)  # 投资人
and a.real_name_verify_time >=  "{qdate}"
and a.real_name_verify_time < DATE_ADD("{qdate}",INTERVAL 1 day)
;