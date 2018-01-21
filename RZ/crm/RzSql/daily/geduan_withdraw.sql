# 各端提现
SELECT a.type geduan,sum(a.money) withdraw
from
(
		SELECT a.uid,sum(a.money) money,
		case when q.name REGEXP "APP" then "APP"
		when q.name REGEXP "PC" then "PC"
		when q.name REGEXP "WAP" then "WAP"
		when b.regist_source_type in (0,4) then "PC"
		when b.regist_source_type = 1 then "WAP"
		when b.regist_source_type in (2,3) then "APP"
		else "PC" end type
		from
		(
				SELECT a.user_id uid,a.money
				from rz_account.rz_account_cash a
				where a.status in (0,1,3)  # 包含提交成功和审核通过
				and a.deleted = 0  # 记录没被删除
				and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
				and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
		) a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		LEFT JOIN rz_article.rz_channel q on b.utm_source = q.`code`
		GROUP BY a.uid
) a
GROUP BY a.type
;
