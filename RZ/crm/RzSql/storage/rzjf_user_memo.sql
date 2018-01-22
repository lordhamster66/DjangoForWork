SELECT a.user_id uid,
if(
q.name is null,
case when a.regist_source_type in (0,4) then "PC 官网"
when a.regist_source_type = 1 then "WAP 官网"
when a.regist_source_type in (2,3) then "APP 官网"
else "PC 官网" end
,q.name
)
from rz_user.rz_user_base_info a
LEFT JOIN (SELECT `code`,name from rz_article.rz_channel GROUP BY `code`) q on a.utm_source = q.`code`
where a.user_id not in
(
  SELECT uid
  from rzjf_bi.rzjf_user_memo
  GROUP BY uid
)


