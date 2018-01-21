# 投资用户登录详情
SELECT count(DISTINCT a.user_id) tz_dl_r
from
(
		SELECT a.user_id
		from rz_user.rz_user_login_record a
		INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
		where a.deleted = 0  # 记录没被删除
		and a.login_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.login_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
		GROUP BY a.user_id
) a
INNER JOIN
(
		SELECT h1.uid
		from
					(
						SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
						from rz_borrow.rz_borrow_tender a1
						where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
						and a1.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
						union all
						SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
						from new_wd.borrow_tender a2
						where a2.status = 1
						and a2.add_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
						union all
						select a3.user_id uid,a3.real_amount account,a3.create_time time_h
						from new_wd.rz_borrow_tender a3
						where a3.status = 1
						and a3.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
					) h1
		GROUP BY h1.uid
) b on a.user_id = b.uid
;