# 供应链金融投资详情
SELECT sum(a.account) g_tz_j
from
(
		SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
		from rz_borrow.rz_borrow_tender a1
		where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
		and a1.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a1.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
		union all
		SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
		from new_wd.borrow_tender a2
		where a2.status = 1
		and a2.add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a2.add_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
) a
;