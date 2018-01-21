# R计划续投详情
SELECT sum(money) Rplan_xt
from new_wd.rz_financing_flow
where tend_type = 1
and `status` = 1
and ctime >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
and ctime < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
;