INSERT INTO rzjf_bi.rzjf_invest_rank (uid,time_h,rank)
SELECT a.uid,a.time_h,a.rank
from
(
		SELECT niu.uid,niu.time_h,count(*) as rank
		FROM
		(
		SELECT uid,time_h
		from 05b_1tenderfinal where orguid=0 and bid <> 10000 and `status` in (1,3) and uid in ({uid})
		UNION ALL
		SELECT user_id,add_time from new_wd.borrow_tender  where user_id in ({uid})
		UNION ALL
		SELECT user_id,create_time from new_wd.rz_borrow_tender where user_id in ({uid})
		) niu
		JOIN (
		SELECT uid,time_h
		from 05b_1tenderfinal where orguid=0 and bid <> 10000 and `status` in (1,3) and uid in ({uid})
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