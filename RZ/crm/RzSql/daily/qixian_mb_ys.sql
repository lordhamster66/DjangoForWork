SELECT DATE(t1.max_time) qdate,t1.qixian term,avg(t1.time) mb_ys
from
(
	SELECT h.name,h.time,h.max_time,
	case when h.qixian < 30 then "A:短标"
	when h.qixian = 30 then "B:1月标"
	when h.qixian > 30 and h.qixian <= 60 then "C:2月标"
	when h.qixian > 60 and h.qixian <= 90 then "D:3月标"
	when h.qixian > 90 and h.qixian <= 180 then "E:6月标"
	else "F:10月标" end qixian
	from
		(
						SELECT t.name,t.bid,
            case when t.days!=0 then t.days else t.borrow_period*30 end qixian,
						(UNIX_TIMESTAMP(max(a.time_h))-UNIX_TIMESTAMP(t.verify_time))/3600 time, -- 计算满标用时
						max(a.time_h) max_time                                                   -- 最后一笔投资时间近似为满标时间
						from 05b_0base t                                                         -- 投资报表
						LEFT JOIN  05b_1tenderfinal a on a.bid=t.bid                             -- 标的详情表
						LEFT JOIN 05b_0base_run m on a.bid=m.bid                                 -- 标的完成进度表
						where a.bid <> 10000                                                     -- 剔除体验标
						and a.orguid = 0                                                         -- 剔除债券转让
						and a.status in(1,3)
						and m.borrow_account_scale = 100                                         -- 完成率100表示满标
						and t.status <> 2                                                        -- 剔除初审失败
						and t.status <> 4                                                        -- 剔除复审失败
						and t.status <> 5                                                        -- 剔除用户自行撤销
						GROUP BY t.bid
						UNION ALL
						SELECT t.name,t.id,
            case when t.borrow_time_type!=0 then t.time_limit else t.time_limit*30 end qixian,
						(UNIX_TIMESTAMP(max(a.add_time))-UNIX_TIMESTAMP(min(t.put_start_time)))/3600 time, -- 计算满标用时
						max(a.add_time) max_time                                                     -- 最后一笔投资时间近似为满标时间
						from new_wd.borrow t                                                         -- 投资报表
						LEFT JOIN  new_wd.borrow_tender a on a.borrow_id=t.id                        -- 标的详情表
						where t.scales = 100                                                     -- 完成率100表示满标
						and t.status <> 2                                                        -- 剔除初审失败
						and t.status <> 4                                                        -- 剔除复审失败
						and t.status <> -1                                                       -- 剔除已撤回
						and t.status <> 5                                                        -- 剔除用户自行撤销
						and a.status = 1
						GROUP BY t.id
						UNION ALL
						SELECT t.name,t.id,
						case when t.borrow_time_type!=0 then t.time_limit else t.time_limit*30 end qixian,
						(UNIX_TIMESTAMP(max(a.create_time))-UNIX_TIMESTAMP(min(t.put_start_time)))/3600 time, -- 计算满标用时
						max(a.create_time) max_time                                                      -- 满标时间
						from new_wd.rz_borrow_big t                                                     -- 投资报表
						LEFT JOIN  new_wd.rz_borrow_tender a on a.borrow_id=t.id                        -- 标的详情表
						where t.scales = 100                                                     -- 完成率100表示满标
						and t.status <> 2                                                        -- 剔除初审失败
						and t.status <> 4                                                        -- 剔除复审失败
						and t.status <> -1                                                       -- 剔除已撤回
						and t.status <> 5                                                        -- 剔除用户自行撤销
						and a.status = 1
						GROUP BY t.id
		) h
) t1
where DATE(t1.max_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
GROUP BY DATE(t1.max_time),t1.qixian
HAVING avg(t1.time) <> 0
;

