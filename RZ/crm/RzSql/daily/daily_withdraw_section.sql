# 提现区间
SELECT a.lei term,count(DISTINCT a.uid) tx_r,sum(a.money) tx_j
from
(
		SELECT a.user_id uid,sum(a.money) money,
		case when sum(a.money) < 100 then "A:小于100"
		when sum(a.money) >= 100 and sum(a.money) < 1000 then "B:100-1千"
		when sum(a.money) >= 1000 and sum(a.money) < 5000 then "C:1千-5千"
		when sum(a.money) >= 5000 and sum(a.money) < 10000 then "D:5千-1万"
		when sum(a.money) >= 10000 and sum(a.money) < 50000 then "E:1万-5万"
		when sum(a.money) >= 50000 and sum(a.money) < 200000 then "F:5万-20万"
		else "G:20万及以上" end lei
		from rz_account.rz_account_cash a
		INNER JOIN rz_user.rz_user_base_info b on a.user_id = b.user_id
		INNER JOIN rz_user.rz_user c on a.user_id = c.uid
		where c.user_type in (1,3) # 投资人
		and a.status in (0,1,3)  # 包含提交成功和审核通过
		and a.deleted = 0  # 记录没被删除
		and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
		GROUP BY a.user_id
) a
GROUP BY a.lei
;