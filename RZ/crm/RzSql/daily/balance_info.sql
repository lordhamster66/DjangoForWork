# 站岗内容
SELECT SUM(a.balance) zg_j,COUNT(DISTINCT a.objid) zg_r
from
(
		SELECT a.objid,sum(a.balance) balance
		from rz_account.rz_account a
		INNER JOIN rz_user.rz_user_base_info b on a.objid = b.user_id
		LEFT JOIN (SELECT uid from rz_user.rz_user where reg_mobile like "JM%") j on a.objid = j.uid      # 机密借款人注册
		where a.type = 1  # 投资人
		and a.atid = 1  # 限定现金账户
		and j.uid is null  # 剔除机密借款人
		and a.deleted = 0  # 记录没被删除
		and a.objtype = "uid"
		GROUP BY a.objid
		HAVING sum(a.balance) > 0
) a
;
