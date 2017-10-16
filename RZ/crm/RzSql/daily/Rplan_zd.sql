SELECT sum(a3.repayment_amount) Rplan_recover_account
from (
		SELECT * from new_wd.rz_borrow_collection_0 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_1 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_2 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_3 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_4 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_5 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_6 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_7 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_8 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_9 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_10 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_11 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_12 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_13 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_14 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_15 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_16 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_17 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_18 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_19 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_20 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_21 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_22 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_23 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_24 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_25 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_26 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_27 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_28 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_29 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_30 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate() UNION ALL
		SELECT * from new_wd.rz_borrow_collection_31 where status in (0,1) and date(create_time) < curdate() and date(repayment_time) >= curdate()
		) a3
INNER JOIN new_wd.rz_borrow_big t2 on a3.big_borrow_id = t2.id and t2.product_id = 10020  # 限定R计划