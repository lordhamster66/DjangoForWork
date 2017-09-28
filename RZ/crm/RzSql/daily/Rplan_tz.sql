SELECT sum(a3.real_amount) Rplan_account
from new_wd.rz_borrow_tender a3
LEFT JOIN new_wd.rz_borrow_big t3 on a3.borrow_id = t3.id
where a3.`status` = 1
and t3.product_id = 10020  # 限定R计划
and DATE(a3.create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)