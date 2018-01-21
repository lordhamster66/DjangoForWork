# 非R计划续投回款详情
SELECT sum(a.recover_account) unRplan_xt_hk_j
from
(
# 没债转的回款
SELECT a1.user_id uid,a1.repayment_amount recover_account,a1.repayment_time recover_times
from rz_borrow.rz_borrow_collection a1
where a1.borrow_id <> 10000 and a1.status in (0,1,2) and a1.deleted = 0  # 记录没被删除
and a1.bond_capital = 0 and a1.bond_interest = 0  # 剔除债转的
and a1.repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
and a1.repayment_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
UNION ALL
# 债转换了个人回款
SELECT a1.user_id uid,a1.collection_amount recover_account,a1.collection_time recover_times
from rz_borrow.rz_bond_collection a1
where a1.borrow_id <> 10000 and a1.status in (0,1) and a1.deleted = 0  # 记录没被删除
and a1.bond_capital = 0 and a1.bond_interest = 0  # 剔除再债转的
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
SELECT a3.user_id uid,a3.repayment_amount recover_account,a3.repayment_time recover_times
from new_wd.rz_borrow_collection a3
where a3.status in (0,1,66)
and a3.repayment_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
and a3.repayment_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
) a
;