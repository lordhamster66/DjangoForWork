# 01u_0info_compay
insert into 01u_0info_compay (`uid`,
`name`,
`buslicence`,
`orgcode`,
`legalname`,
`legalpersionid`,
`linkman`,
`linkmanmobile`,
`yewuyuan`,
`yewuid`,
`registration_place`,
`registration_money`,
`establishment_data`,
`main_business`
)
select
id											`uid`,
company_name						`name`,
company_reg_no					`buslicence`,
tax_reg_no							`orgcode`,
frdb_name								`legalname`,
frdb_no									`legalpersionid`,
frdb_name								`linkman`,
company_phone						`linkmanmobile`,
''											`yewuyuan`,
'0'											`yewuid`,
reg_address							`registration_place`,
actual_capital					`registration_money`,
founding_time						`establishment_data`,
industry								`main_business`
from rz_user.rz_company WHERE create_time > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 2 DAY),"%Y-%m-%d 23:59:59")
and create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:59:59");