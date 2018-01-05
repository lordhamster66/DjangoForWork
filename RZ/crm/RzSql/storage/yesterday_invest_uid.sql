SELECT uid from 05b_1tenderfinal where time_h >= DATE_SUB(CURDATE(),INTERVAL 1 day) and time_h < CURDATE()
UNION
SELECT user_id from new_wd.borrow_tender where add_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and add_time < CURDATE()
UNION
SELECT user_id from new_wd.rz_borrow_tender where create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day) and create_time < CURDATE()