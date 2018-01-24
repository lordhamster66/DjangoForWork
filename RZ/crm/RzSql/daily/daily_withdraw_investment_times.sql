# 投资次数
SELECT a.lei term,count(DISTINCT a.uid) tx_r,sum(a.money) tx_j
from
(
		SELECT h.uid,h.money,b.cishu,
		case when b.cishu is null then "A:没投资"
		when b.cishu = 1 then "B:投资1次"
		when b.cishu >= 2 and b.cishu <= 5 then "C:2-5次"
		when b.cishu >= 6 and b.cishu <= 10 then "D:6-10次"
		when b.cishu >= 11 and b.cishu <= 20 then "E:11-20次"
		when b.cishu >= 21 then "F:21次及以上" else "不存在" end lei
		from
		(
				SELECT a.user_id uid,sum(a.money) money
				from rz_account.rz_account_cash a
				INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
				INNER JOIN rz_user.rz_user c on a.user_id = c.uid
				where c.user_type in (1,3) # 投资人
		    and a.status in (0,1,3)  # 包含提交成功和审核通过
				and a.deleted = 0  # 记录没被删除
				and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				GROUP BY a.user_id
		) h
		LEFT JOIN
		(
				SELECT h1.uid,count(h1.uid) cishu
				from
				(
							SELECT a1.user_id uid,a1.money account,a1.create_time time_h
							from rz_borrow.rz_borrow_tender a1
							where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
							and a1.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
							union all
							SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
							from new_wd.borrow_tender a2
							where a2.status = 1
							and a2.add_time < DATE_ADD("{qdate}",INTERVAL 1 day)
							union all
							select a3.user_id uid,a3.real_amount account,a3.create_time time_h
							from new_wd.rz_borrow_tender a3
							where a3.status = 1
							and a3.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				) h1
				GROUP BY h1.uid
		) b on h.uid = b.uid
) a
GROUP BY a.lei
;