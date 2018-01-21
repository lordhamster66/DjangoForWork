# 各端已还以及各端已还并提现
SELECT a.type,sum(a.recover_account) recover,sum(ifnull(b.money,0)) recover_withdraw
from
(
		SELECT a.uid,sum(a.recover_account) recover_account,
		case when q.name REGEXP "APP" then "APP"
		when q.name REGEXP "PC" then "PC"
		when q.name REGEXP "WAP" then "WAP"
		when b.regist_source_type in (0,4) then "PC"
		when b.regist_source_type = 1 then "WAP"
		when b.regist_source_type in (2,3) then "APP"
		else "PC" end type
		from
		(
				# 没债转的回款
				SELECT a1.user_id uid,a1.repayment_amount recover_account,a1.repayment_time recover_times
				from rz_borrow.rz_borrow_collection a1
				where a1.borrow_id <> 10000 and a1.status in (0,1,2) and a1.deleted = 0  # 记录没被删除
				and a1.bond_capital = 0 and a1.bond_interest = 0
				and a1.repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
				and a1.repayment_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
				UNION ALL
				# 债转换了个人回款
				SELECT a1.user_id uid,a1.collection_amount recover_account,a1.collection_time recover_times
				from rz_borrow.rz_bond_collection a1
				where a1.borrow_id <> 10000 and a1.status in (0,1) and a1.deleted = 0  # 记录没被删除
				and a1.bond_capital = 0 and a1.bond_interest = 0
				and a1.collection_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
				and a1.collection_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
				UNION ALL
				SELECT r.user_id uid,r.real_total recover_account,DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )
				from new_wd.borrow_collection r
				LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
				where r.`status` in (0,1,66)
				and DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY ) >= DATE_SUB(CURDATE(),INTERVAL 1 day)
				and DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY ) < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
				and r.real_total > 0
				UNION ALL
				SELECT user_id uid,repayment_amount recover_account,repayment_time
				from new_wd.rz_borrow_collection
				where status in (0,1,66)
				and repayment_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
				and repayment_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
		) a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		LEFT JOIN rz_article.rz_channel q on b.utm_source = q.`code`
		GROUP BY a.uid
) a
LEFT JOIN
(
		SELECT a.user_id,sum(a.money) money
		from rz_account.rz_account_cash a
		where a.status in (0,1,3)  # 包含提交成功和审核通过
		and a.deleted = 0  # 记录没被删除
		and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
		GROUP BY a.user_id
) b on a.uid = b.user_id
GROUP BY a.type
;
