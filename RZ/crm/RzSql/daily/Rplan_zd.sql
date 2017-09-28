SELECT sum(a3.repayment_amount) Rplan_recover_account
from new_wd.rz_borrow_collection a3
LEFT JOIN new_wd.rz_borrow_big t1 on a3.borrow_id = t1.id
LEFT JOIN new_wd.rz_borrow_tender t2 on a3.tender_id = t2.id
where a3.`status` in (0,1)
and t1.product_id = 10020  # 限定R计划
and unix_timestamp(t2.create_time) < unix_timestamp(DATE_SUB(curdate(),INTERVAL 1 DAY))+86400
and unix_timestamp(a3.repayment_time) >= unix_timestamp(DATE_SUB(curdate(),INTERVAL 1 DAY))+86400
;