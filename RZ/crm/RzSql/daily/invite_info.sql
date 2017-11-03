SELECT
sum(z.邀请人) invite_r,sum(z.被邀请人) invited_r,sum(z.首投人数) invited_st_r,sum(z.首投金额) invited_st_j,sum(z.发放现金) 首投花费,
sum(z.投资金额) 总投资,sum(z.红包使用金额)+sum(z.发放现金) 总花费,sum(z.当月总投资人数) 7月总投资人数,sum(z.当月总投资金额) 7月总投资金额,
sum(z.红包发放张数) 红包发放张数,sum(z.红包发放金额) hb_f,sum(z.红包使用金额) hb_s,
sum(z.发放现金) cash_f,sum(z.领取现金) cash_l,sum(z.投资人数) 投资人数,sum(z.新增投资人数) 新增投资人数,sum(z.新增投资金额)
from
(
			SELECT count(DISTINCT(a.uid)) 首投人数,sum(a.account) 首投金额,0 红包金额,0 发放现金,0 领取现金,
			0 投资人数,0 投资金额,0 红包使用张数,0 红包使用金额,0 邀请人,0 被邀请人,0 红包发放张数,0 红包发放金额,0 当月总投资人数,0 当月总投资金额,0 新增投资人数,0 新增投资金额
			from
			(
							SELECT uid,time_h,account
							from 05b_1tenderfinal
							where orguid=0 and bid <> 10000 and status in (1,3)
							and DATE(time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT user_id,add_time,real_amount
							from new_wd.borrow_tender
							where status = 1
							and DATE(add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT user_id,create_time,real_amount
							from new_wd.rz_borrow_tender
							where `status` = 1
							and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			) a
			LEFT JOIN (
							SELECT h1.uid,min(h1.time_h) min_time
								from
								(
									SELECT a1.uid,a1.account,a1.time_h
									from 05b_1tenderfinal a1
									where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
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
			) t on a.uid = t.uid
			LEFT JOIN
			(
					SELECT a.uid
					from  01u_9tjr a
					where DATE(a.time_h) < DATE(curdate())
			) z on a.uid = z.uid
			where a.time_h = t.min_time
			and a.uid = z.uid

union all

			SELECT
			0,0,0,
			sum(a.money ) 发放现金,
			0,0,0,0,0,0,0,0,0,0,0,0,0
			from rz_inviter_record  a
			where a.inviter_id in
					(
							SELECT a.uid_tjr
							from  01u_9tjr a
							where DATE(a.time_h) < DATE(curdate())
							UNION
							SELECT a.uid
							from  01u_9tjr a
							where DATE(a.time_h) < DATE(curdate())
					)
			and a.name not in( "人脉王金奖",'人脉王银奖','人脉王铜奖')
			and  a.is_status=0
			and FROM_UNIXTIME(a.create_time,"%Y-%m-%d") = DATE_SUB(curdate(),INTERVAL 1 DAY)
union all
				SELECT
				0,0,0,
				0,
				sum( a.money ) 领取现金,0,0,0,0,0,0,0,0,0,0,0,0
				from rz_inviter_record  a
				where a.inviter_id in
				(
				SELECT a.uid_tjr
				from  01u_9tjr a
				where DATE(a.time_h) < DATE(curdate())
				UNION
				SELECT a.uid
				from  01u_9tjr a
				where DATE(a.time_h) < DATE(curdate())
				)
				and a.is_status=2
				and a.name not in( "人脉王金奖",'人脉王银奖','人脉王铜奖')
				and FROM_UNIXTIME(a.update_time,"%Y-%m-%d") = DATE_SUB(curdate(),INTERVAL 1 DAY)
union all

			SELECT 0,0,0,0,0,count(DISTINCT(a.uid)) 投资人数,sum(a.account) 投资金额,0,0,0,0,0,0,0,0,0,0
			from
			(
							SELECT uid,time_h,account
							from 05b_1tenderfinal
							where orguid=0 and bid <> 10000 and status in (1,3)
							and DATE(time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT user_id,add_time,real_amount
							from new_wd.borrow_tender
							where status = 1
							and DATE(add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT a3.user_id,a3.create_time,a3.real_amount
							from (
									(SELECT * FROM new_wd.rz_borrow_tender_0 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_1 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_2 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_3 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_4 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_5 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_6 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_7 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_8 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_9 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_10 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_11 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_12 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_13 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_14 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_15 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_16 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_17 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_18 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_19 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_20 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_21 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_22 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_23 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_24 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_25 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_26 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_27 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_28 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_29 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_30 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))  union all
									(SELECT * FROM new_wd.rz_borrow_tender_31 where `status` = 1 and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY))
								) a3
			) a
			LEFT JOIN
			(
			SELECT a.uid
			from  01u_9tjr a
			where DATE(a.time_h) < DATE(curdate())
			) z on a.uid = z.uid
			where a.uid = z.uid


union all

			SELECT 0,0,0,0,0,0,0,count( a.uid)红包使用张数 ,sum(money) 红包使用金额,0,0,0,0,0,0,0,0
			from  21h_0hongbao a
			LEFT JOIN
			(
			SELECT a.uid
			from  01u_9tjr a
			where DATE(a.time_h) < DATE(curdate())
			) z on a.uid = z.uid
			WHERE a.money_ty=0
			and a.uid=z.uid
			and a.ispay=1
			and DATE(a.time_use) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			-- and UNIX_TIMESTAMP(DATE_FORMAT(a.time_use,"%Y-%m-%d")) - UNIX_TIMESTAMP(z.time_h) < 86400*29
			and  a.flag   in (1901,1902,1903,2074,2075,2076)

union all

			SELECT 0,0,0,0,0,0,0,0,0,count(DISTINCT(a.uid_tjr)) 邀请人,count(DISTINCT(a.uid)) 被邀请人,0,0,0,0,0,0
			from  01u_9tjr a
			where  DATE(a.time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)

union all

			SELECT 0,0,0,0,0,0,0,0,0,0,0,count(*) 红包发放张数,SUM(a.money) 红包发放金额,0,0,0,0
			from 21h_0hongbao  a
			LEFT JOIN
			(
			SELECT a.uid
			from  01u_9tjr a
			where DATE(a.time_h) < DATE(curdate())
			) z on a.uid = z.uid
			where a.money_ty = 0
			and a.uid=z.uid
			and DATE(a.time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			and  a.flag   in (2074,2075,2076)

union all

		SELECT 0,0,0,0,0,0,0,0,0,0,0,0,0,count(DISTINCT(a.uid)) 当月总投资人数,sum(a.account) 当月总投资金额,0,0
		from
			(
							SELECT uid,time_h,account
							from 05b_1tenderfinal
							where orguid=0 and bid <> 10000 and status in (1,3)
							and DATE(time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT user_id,add_time,real_amount
							from new_wd.borrow_tender
							where status = 1
							and DATE(add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT user_id,create_time,real_amount
							from new_wd.rz_borrow_tender
							where `status` = 1
							and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
			 ) a
			LEFT JOIN
			(
					SELECT a.uid
					from  01u_9tjr a
					where DATE(a.time_h) < DATE(curdate())
			) z on a.uid = z.uid
			LEFT JOIN
			(
								SELECT h1.uid,min(h1.time_h) min_time
								from
								(
									SELECT a1.uid,a1.account,a1.time_h
									from 05b_1tenderfinal a1
									where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
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
			) t on a.uid = t.uid
		where a.uid = z.uid
    and MONTH(t.min_time)  >= MONTH(curdate())

union all

				SELECT 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,count(DISTINCT(a.uid)) 新增投资人数,sum(a.account) 新增投资金额
				from
				(
							SELECT uid,time_h,account
							from 05b_1tenderfinal
							where orguid=0 and bid <> 10000 and status in (1,3)
							and DATE(time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT user_id,add_time,real_amount
							from new_wd.borrow_tender
							where status = 1
							and DATE(add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
							UNION ALL
							SELECT user_id,create_time,real_amount
							from new_wd.rz_borrow_tender
							where `status` = 1
							and DATE(create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
				) a
				LEFT JOIN (
										SELECT h1.uid,ifnull(min(h1.time_h),0) min_time
										from
										(
											SELECT a1.uid,a1.account,a1.time_h
											from 05b_1tenderfinal a1
											LEFT JOIN 05b_0base t1 on a1.bid = t1.bid
											where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
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
								 ) t on a.uid = t.uid
				LEFT JOIN 01u_0info b on a.uid = b.uid
						 LEFT JOIN
											(
														SELECT a.uid
														from  01u_9tjr a
														where DATE(a.time_h) < DATE(curdate())
											) z on a.uid = z.uid
				where DATE_FORMAT(a.time_h,"%Y-%m-%d") = DATE_FORMAT(t.min_time,"%Y-%m-%d")
				AND a.uid=z.uid

) z

