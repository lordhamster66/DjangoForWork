SELECT user_id uid from rz_borrow.rz_borrow_tender
where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6) and deleted = 0 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()
UNION
SELECT user_id from new_wd.borrow_tender where  status = 1 and add_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and add_time < CURDATE()
UNION
SELECT user_id from new_wd.rz_borrow_tender where `status` = 1 and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()