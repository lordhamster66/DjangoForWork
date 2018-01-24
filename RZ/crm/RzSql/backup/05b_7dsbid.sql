insert into 05b_7dsbid (`bid`,
`uid`,
`cid`,
`time_h`,
`isxs`,
`opentime`,
`opentimeds`,
`STATUS`,
`verify_time`
) select `bid`,
`uid`,
`cid`,
`time_h`,
`isxs`,
`opentime`,
`opentimeds`,
`STATUS`,
`verify_time`
 from wd.05b_7dsbid
where time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 2 DAY),"%Y-%m-%d 23:59:59") and time_h <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:59:59");
