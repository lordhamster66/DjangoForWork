# 各端投资
SELECT a.type geduan,sum(a.account) account
from
(
		SELECT a.uid,sum(a.account) account,
		case when q.name REGEXP "APP" then "APP"
		when q.name REGEXP "PC" then "PC"
		when q.name REGEXP "WAP" then "WAP"
		when b.regist_source_type in (0,4) then "PC"
		when b.regist_source_type = 1 then "WAP"
		when b.regist_source_type in (2,3) then "APP"
		else "PC" end type
		from
		(
				SELECT a1.user_id uid,a1.money account,a1.create_time time_h
				from rz_borrow.rz_borrow_tender a1
				where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
				and a1.create_time >= "{qdate}"
				and a1.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				union all
				SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
				from new_wd.borrow_tender a2
				where a2.status = 1
				and a2.add_time >= "{qdate}"
				and a2.add_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				union all
				SELECT a3.user_id uid,a3.real_amount account,a3.create_time time_h
				from
				(
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_0 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_1 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_2 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_3 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_4 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_5 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_6 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_7 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_8 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_9 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_10 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_11 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_12 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_13 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_14 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_15 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_16 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_17 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_18 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_19 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_20 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_21 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_22 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_23 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_24 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_25 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_26 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_27 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_28 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_29 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_30 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_31 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))
				) a3
		) a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		LEFT JOIN (SELECT `code`,name from rz_article.rz_channel GROUP BY `code`) q on b.utm_source = q.`code`
		GROUP BY a.uid
) a
GROUP BY a.type
;
