SELECT a.qdate,a.term,sum(a.tz_r) tz_r,sum(a.tz_j) tz_j,AVG(a.mb_ys) mb_ys
from
(
SELECT qdate,case when term < 10 then "A:1-10天"
when term >= 10 and term < 30 then "B:10-30天"
when term >= 30 and term < 60 then "C:1月标"
when term >= 60 and term < 90 then "D:2月标"
when term >= 90 and term < 180 then "E:3月标"
else "F:6月标及以上"
end term,tz_r,tz_j,mb_ys
from rzjf_asset_info
where unix_timestamp(qdate) >= unix_timestamp("{qdate}") - {section} * 86400 + 86400
and unix_timestamp(qdate) < unix_timestamp("{qdate}")+86400
and asset_type = "R计划"
) a
GROUP BY a.qdate,a.term
ORDER BY a.qdate