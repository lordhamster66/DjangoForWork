SELECT t2.uid,
			 case when (t2.qudao is null or t2.qudao="") and t2.register_url like "%app%" then "APP 官网"
			 when (t2.qudao is null or t2.qudao="") and t2.register_url not like "%app%" and t2.register_url not like "%wx%" and t2.way=3 then "APP 官网"
			 when (t2.qudao is null or t2.qudao="") and t2.register_url not like "%app%" and t2.register_url not like "%wx%" and t2.way=1 then "PC 官网"
			 when (t2.qudao is null or t2.qudao="") and t2.register_url not like "%app%" and (t2.register_url  like "%wx%" or t2.way=2) then "WAP 官网"
			 when (t2.qudao is null or t2.qudao="") and (t2.way is null or t2.way="") then "其他"
			 when (t2.qudao is null or t2.qudao="") and (t2.register_url is null or t2.register_url="") and  t2.way=3 then "APP 官网"
			 when (t2.qudao is null or t2.qudao="") and (t2.register_url is null or t2.register_url="") and  t2.way=2 then "WAP 官网"
			 when (t2.qudao is null or t2.qudao="") and (t2.register_url is null or t2.register_url="") and  t2.way=1 then "PC 官网"
			 else t2.qudao end memo
		from
		(
									 SELECT t1.uid,t1.un,t1.uname,t1.tjr,t1.mobile,t1.personid,t1.time_h,
									 case when (t1.qudao is null or t1.qudao="")
									 and(t1.register_url like "%www.51rz.com/ind/registerTg.html%"
									 or t1.register_url like "%www.51rz.com/ind/h5/registerTg.html%"
									 or t1.register_url like "%www.51rz.com/ind/wx/tg/qd_welfare.html%"
									 or t1.register_url like "%www.51rz.com/ind/active/zzw.html%"
									 or t1.register_url like "%www.51rz.com/ind/wx/actie/reg_zzw.html%"
									 or t1.register_url like "%www.51rz.com/ind/wx/actie/programmer/ans_step01.html%"
									 or t1.register_url like "%www.51rz.com/ind/wx/actie/channelReg/spread_register.html%"
									 or t1.register_url like "%www.51rz.com/ind/PC/bwb_reg.html%") then "PC 官网"
									 when t1.mobile in (18006817722,15957187705,15088718671,15618685415,17706527053,13750801989,13735801391,15158065171,15925636863) then "PC 官网"
									 else t1.qudao end qudao,t1.qdtype,t1.register_url,t1.way,t1.site_name,t1.from_site,t1.所属部门
						from
						(
											SELECT a.uid,b.un,a.uname,a.tjr,a.mobile,concat("`",a.personid) personid,a.time_h,
											case when q.name="pc-gw" then ""
											when q.name in ("wap-fwh","wap-fwh-zy","wap-fwh2")  and bu.所属部门 not in ("APP运营部","PC运营部","WAP运营部") then "wap-fwhq"
											else q.name end qudao,
											q.qdtype,z.register_url,a.way,z.site_name,z.from_site,bu.所属部门
											from wd.01u_0info a
											INNER JOIN wd.01u_0base b on a.uid=b.uid
											LEFT JOIN wd.01u_0info d on a.uid_kefu=d.uid
											LEFT JOIN wd.01u_0qudao q on a.uid=q.uid
											LEFT JOIN wd.01u_0other z on a.uid=z.uid
											INNER JOIN (SELECT max(uid) max_uid from rzjf_bi.rzjf_user_memo) t1 on a.uid > t1.max_uid
											LEFT JOIN
											(select b1.uid 用户ID,"APP运营部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "YY"
											union all
											select b1.uid 用户ID,"PC运营部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "PY"
											union all
											select b1.uid 用户ID,"WAP运营部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "WY"
											union all
											select b1.uid 用户ID,"上海" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "SH"
											union all
											select b1.uid 用户ID,"江苏" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "JS"
											union all
											select b1.uid 用户ID,"杭州一部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 3 ) = "HZ1"
											union all
											select b1.uid 用户ID,"杭州二部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 3 ) = "HZ2"
											union all
											select b1.uid 用户ID,"杭州三部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 3 ) = "HZ3"
											union all
											select b1.uid 用户ID,"杭州四部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 3 ) = "HZ4"
											union all
											select b1.uid 用户ID,"杭州五部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 3 ) = "HZ5"
											union all
											select b1.uid 用户ID,"杭州六部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 3 ) = "HZ6"
											union all
											select b1.uid 用户ID,"地推部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "DT"
											union all
											select b1.uid 用户ID,"平台总部" 所属部门 FROM wd.01u_0base b1 JOIN wd.02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "ZZ") bu
											on a.uid_kefu=bu.用户ID
						) t1
		) t2