# R计划续投详情
SELECT ,sum(money) Rplan_xt
from new_wd.rz_financing_flow
where tend_type = 1
and DATE(ctime) = DATE_SUB(curdate(),INTERVAL 1 DAY)
GROUP BY DATE(ctime)
;
