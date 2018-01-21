INSERT INTO rzjf_bi.rzjf_invest_rank (uid,time_h,rank)
SELECT a.uid,a.time_h,a.rank
from
(
		SELECT niu.uid,niu.time_h,count(*) as rank
		FROM
		(
		SELECT user_id uid,create_time time_h
		from rz_borrow.rz_borrow_tender  where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6) and deleted = 0 and user_id in ({uid})
		UNION ALL
		SELECT user_id,add_time from new_wd.borrow_tender  where user_id in ({uid})
		UNION ALL
		SELECT user_id,create_time from new_wd.rz_borrow_tender where user_id in ({uid})
		) niu
		JOIN (
		SELECT user_id uid,create_time time_h
		from rz_borrow.rz_borrow_tender where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6) and deleted = 0 and user_id in ({uid})
		UNION ALL
		SELECT user_id,add_time from new_wd.borrow_tender where user_id in ({uid})
		UNION ALL
		SELECT user_id,create_time from new_wd.rz_borrow_tender where user_id in ({uid})
		) bi ON niu.uid = bi.uid AND niu.time_h >= bi.time_h
		GROUP BY niu.time_h, niu.uid
		ORDER BY niu.time_h asc,niu.uid desc
) a
where a.time_h >= DATE_SUB(CURDATE(),INTERVAL 1 day)
and a.time_h < CURDATE()