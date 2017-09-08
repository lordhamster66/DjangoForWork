CREATE TABLE `05b_0base_run` (
	`pk_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `bid` int(11) unsigned NOT NULL,
  `account` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '[rongyu]',
  `tender_num` int(11) NOT NULL DEFAULT '0' COMMENT '投资人个数',
  `tender_times` int(11) NOT NULL DEFAULT '0' COMMENT '投标的次数',
  `hits` int(11) NOT NULL DEFAULT '0',
  `time_h` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `borrow_account_yes` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '已借到的金额',
  `borrow_account_wait` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '还差多少',
  `borrow_account_scale` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '借贷的完成率',
  `borrow_times` int(5) NOT NULL DEFAULT '0' COMMENT '借款的次数',
  `dj_bzj` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '当前还未解冻的保证金数额',
  `dj_sq` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '当前还未解冻的首期冻结金数额',
  `attrv` int(11) NOT NULL DEFAULT '0' COMMENT '标属性',
  `autorepay` int(11) NOT NULL DEFAULT '0' COMMENT '易宝自动还款协议',
  PRIMARY KEY (`pk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;




insert into 05b_0base_run
(`bid`, `account`, `tender_num`, `tender_times`, `hits`, `time_h`, `borrow_account_yes`,
`borrow_account_wait`, `borrow_account_scale`, `borrow_times`, `dj_bzj`, `dj_sq`, `attrv`, `autorepay`)
select `bid`, `account`, `tender_num`, `tender_times`, `hits`, `time_h`, `borrow_account_yes`,
`borrow_account_wait`, `borrow_account_scale`, `borrow_times`, `dj_bzj`, `dj_sq`, `attrv`, `autorepay`
from wd.05b_0base_run
WHERE time_h <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");


