INSERT INTO rzjf_bi.rzjf_first_invest_recorde (uid,first_time,first_account,bid,name,time_limit,apr,db)
SELECT  a.uid,a.time_h first_time,a.account first_account,a.bid,a.name,a.qixian time_limit,a.borrow_apr apr,a.db
from
(
		SELECT a1.user_id uid,a1.money account,a1.create_time time_h,
		case when t1.borrow_time_type!=0 then concat(t1.time_limit,"天") else concat(t1.time_limit,"月") end qixian,
		t1.name,t1.apr borrow_apr,a1.borrow_id bid,"老库" db
		from rz_borrow.rz_borrow_tender a1
		INNER JOIN rz_borrow.rz_borrow t1 on a1.borrow_id = t1.id
		where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
		union all
		SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h,
		case when t2.borrow_time_type!=0 then concat(t2.time_limit,"天") else concat(t2.time_limit,"月") end qixian,
		t2.name,t2.apr,a2.borrow_id,"众银宝" db
		from new_wd.borrow_tender a2
		INNER JOIN new_wd.borrow t2 on a2.borrow_id = t2.id
		where a2.status = 1
		union all
		SELECT a3.user_id uid,a3.real_amount account,a3.create_time time_h,
		case when t3.borrow_time_type!=0 then concat(t3.time_limit,"天") else concat(t3.time_limit,"月") end qixian,
		t3.name,t3.apr,a3.borrow_id,"新库" db
		from new_wd.rz_borrow_tender a3
		INNER JOIN new_wd.rz_borrow_big t3 on a3.borrow_id = t3.id
		where a3.`status` = 1
) a
INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
INNER JOIN
(
			SELECT h1.uid,min(h1.time_h) min_invest_time
			from
						(
							SELECT a1.user_id uid,a1.money account,a1.create_time time_h
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
) t on a.uid = t.uid and a.time_h = t.min_invest_time
LEFT JOIN rzjf_bi.rzjf_old_invest_uid c on a.uid = c.uid
where c.uid is null  # 剔除老系统投资的用户，这些用户肯定不能算作新增投资用户
and a.uid not in
(
SELECT uid
from rzjf_bi.rzjf_first_invest_recorde
GROUP BY uid
)