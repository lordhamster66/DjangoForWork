# 投资时间间隔
SELECT a.lei term,count(DISTINCT a.uid) tx_r,sum(a.money) tx_j
from
(
		SELECT h.uid,h.money,b.time_interval,
		case when b.time_interval is null then "A:没投资"
		when b.time_interval < 10 then "B:0-10天"
		when b.time_interval >= 10 and b.time_interval < 30 then "C:10-30天"
		when b.time_interval >= 30 and b.time_interval < 60 then "D:30-60天"
		when b.time_interval >= 60 and b.time_interval < 90 then "E:60-90天"
		else "F:90天及以上" end lei
		from
		(
				SELECT a.user_id uid,sum(a.money) money
				from rz_account.rz_account_cash a
				INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
				INNER JOIN rz_user.rz_user c on a.user_id = c.uid
				where c.user_type = 1 # 投资人
				and a.status in (1,3)  # 包含提交成功和审核通过
				and a.deleted = 0  # 记录没被删除
				and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
				GROUP BY a.user_id
		) h
		LEFT JOIN
		(
				SELECT h1.uid,(UNIX_TIMESTAMP(max(h1.time_h)) - UNIX_TIMESTAMP(min(h1.time_h)))/86400 time_interval
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
		) b on h.uid = b.uid
) a
GROUP BY a.lei
;
