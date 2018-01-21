#新增内容
SELECT  count(DISTINCT(a.uid)) xztz_r,sum(a.account) xztz_j
from
(
    SELECT user_id uid,create_time time_h,real_amount account
    from rz_borrow.rz_borrow_tender
    where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6) and deleted = 0
    and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
    and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
    UNION ALL
    SELECT user_id,add_time,real_amount
    from new_wd.borrow_tender
    where status = 1
    and add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
    and add_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
    UNION ALL
    SELECT user_id,create_time,real_amount
    from new_wd.rz_borrow_tender
    where `status` = 1
    and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
    and create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
) a
INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
LEFT JOIN rzjf_bi.rzjf_old_invest_uid c on a.uid = c.uid
INNER JOIN
(
      SELECT h1.uid,min(h1.time_h) min_invest_time
      from
            (
              SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
              from rz_borrow.rz_borrow_tender a1
              where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
              union all
              SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
              from new_wd.borrow_tender a2
              where a2.status = 1
              union all
              select a3.user_id uid,a3.real_amount account,a3.create_time time_h
              from new_wd.rz_borrow_tender a3
              where a3.status = 1
            ) h1
      GROUP BY h1.uid
) t on a.uid = t.uid and DATE(a.time_h) = DATE(t.min_invest_time)  # 限定新增
where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and c.uid is null
;
