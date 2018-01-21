# 注册人数
SELECT count(DISTINCT(a.uid)) zhu_r
from rz_user.rz_user a
INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
LEFT JOIN (SELECT uid from rz_user.rz_user where reg_mobile like "JM%") j on a.uid = j.uid      # 机密借款人注册
where j.uid is null  # 剔除机密借款人
and a.deleted = 0  # 记录没被删除
and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
;