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
		where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
		and a.user_id not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
		and a.status in (1,3)  # 包含提交成功和审核通过
		and a.deleted = 0  # 记录没被删除
		and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
		GROUP BY a.user_id
) a
GROUP BY a.lei
;