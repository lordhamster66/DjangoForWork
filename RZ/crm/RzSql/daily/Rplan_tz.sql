SELECT sum(a3.real_amount) Rplan_account
from (
			(SELECT * FROM new_wd.rz_borrow_tender_0 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_1 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_2 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_3 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_4 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_5 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_6 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_7 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_8 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_9 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_10 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_11 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_12 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_13 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_14 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_15 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_16 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_17 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_18 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_19 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_20 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_21 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_22 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_23 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_24 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_25 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_26 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_27 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_28 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_29 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_30 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
			(SELECT * FROM new_wd.rz_borrow_tender_31 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))
			) a3
INNER JOIN new_wd.rz_borrow_big t3 on a3.big_borrow_id = t3.id
where t3.product_id = 10020  # 限定R计划