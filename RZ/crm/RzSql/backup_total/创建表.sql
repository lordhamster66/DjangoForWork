CREATE TABLE 01u_0info_compay like wd.01u_0info_compay;
insert into 01u_0info_compay select * from wd.01u_0info_compay WHERE establishment_data <= DATE_SUB(curdate(),INTERVAL 1 DAY);


CREATE TABLE 11_auth like wd.11_auth;
insert into 11_auth select * from wd.11_auth;


CREATE TABLE 01u_0base like wd.01u_0base;
insert into 01u_0base select * from wd.01u_0base WHERE time_h <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

CREATE TABLE 05b_7dsbid like wd.05b_7dsbid;
insert into 05b_7dsbid select * from wd.05b_7dsbid WHERE time_h <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table zzz_ctlog_c_uid like wd.zzz_ctlog_c_uid;
insert into zzz_ctlog_c_uid select * from wd.zzz_ctlog_c_uid WHERE time_h <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow like new_wd.rz_borrow;
insert into rz_borrow select * from new_wd.rz_borrow WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");


create table rz_loan_open_data like wd.rz_loan_open_data;
insert into rz_loan_open_data select * from wd.rz_loan_open_data WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender like new_wd.rz_borrow_tender;
insert into rz_borrow_tender select * from new_wd.rz_borrow_tender WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");


create table rz_borrow_big like new_wd.rz_borrow_big;
insert into rz_borrow_big select * from new_wd.rz_borrow_big WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");


CREATE TABLE 01u_0info like wd.01u_0info;
insert into 01u_0info select * from wd.01u_0info WHERE time_h <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_0 like new_wd.rz_borrow_tender_0;
insert into rz_borrow_tender_0 select * from new_wd.rz_borrow_tender_0 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_1 like new_wd.rz_borrow_tender_1;
insert into rz_borrow_tender_1 select * from new_wd.rz_borrow_tender_1 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_2 like new_wd.rz_borrow_tender_2;
insert into rz_borrow_tender_2 select * from new_wd.rz_borrow_tender_2 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_3 like new_wd.rz_borrow_tender_3;
insert into rz_borrow_tender_3 select * from new_wd.rz_borrow_tender_3 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_4 like new_wd.rz_borrow_tender_4;
insert into rz_borrow_tender_4 select * from new_wd.rz_borrow_tender_4 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_5 like new_wd.rz_borrow_tender_5;
insert into rz_borrow_tender_5 select * from new_wd.rz_borrow_tender_5 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_6 like new_wd.rz_borrow_tender_6;
insert into rz_borrow_tender_6 select * from new_wd.rz_borrow_tender_6 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_7 like new_wd.rz_borrow_tender_7;
insert into rz_borrow_tender_7 select * from new_wd.rz_borrow_tender_7 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_8 like new_wd.rz_borrow_tender_8;
insert into rz_borrow_tender_8 select * from new_wd.rz_borrow_tender_8 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_9 like new_wd.rz_borrow_tender_9;
insert into rz_borrow_tender_9 select * from new_wd.rz_borrow_tender_9 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_10 like new_wd.rz_borrow_tender_10;
insert into rz_borrow_tender_10 select * from new_wd.rz_borrow_tender_10 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_11 like new_wd.rz_borrow_tender_11;
insert into rz_borrow_tender_11 select * from new_wd.rz_borrow_tender_11 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_12 like new_wd.rz_borrow_tender_12;
insert into rz_borrow_tender_12 select * from new_wd.rz_borrow_tender_12 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_13 like new_wd.rz_borrow_tender_13;
insert into rz_borrow_tender_13 select * from new_wd.rz_borrow_tender_13 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_14 like new_wd.rz_borrow_tender_14;
insert into rz_borrow_tender_14 select * from new_wd.rz_borrow_tender_14 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_15 like new_wd.rz_borrow_tender_15;
insert into rz_borrow_tender_15 select * from new_wd.rz_borrow_tender_15 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_16 like new_wd.rz_borrow_tender_16;
insert into rz_borrow_tender_16 select * from new_wd.rz_borrow_tender_16 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_17 like new_wd.rz_borrow_tender_17;
insert into rz_borrow_tender_17 select * from new_wd.rz_borrow_tender_17 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_18 like new_wd.rz_borrow_tender_18;
insert into rz_borrow_tender_18 select * from new_wd.rz_borrow_tender_18 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_19 like new_wd.rz_borrow_tender_19;
insert into rz_borrow_tender_19 select * from new_wd.rz_borrow_tender_19 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_20 like new_wd.rz_borrow_tender_20;
insert into rz_borrow_tender_20 select * from new_wd.rz_borrow_tender_20 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_21 like new_wd.rz_borrow_tender_21;
insert into rz_borrow_tender_21 select * from new_wd.rz_borrow_tender_21 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_22 like new_wd.rz_borrow_tender_22;
insert into rz_borrow_tender_22 select * from new_wd.rz_borrow_tender_22 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_23 like new_wd.rz_borrow_tender_23;
insert into rz_borrow_tender_23 select * from new_wd.rz_borrow_tender_23 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_24 like new_wd.rz_borrow_tender_24;
insert into rz_borrow_tender_24 select * from new_wd.rz_borrow_tender_24 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_25 like new_wd.rz_borrow_tender_25;
insert into rz_borrow_tender_25 select * from new_wd.rz_borrow_tender_25 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_26 like new_wd.rz_borrow_tender_26;
insert into rz_borrow_tender_26 select * from new_wd.rz_borrow_tender_26 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_27 like new_wd.rz_borrow_tender_27;
insert into rz_borrow_tender_27 select * from new_wd.rz_borrow_tender_27 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_28 like new_wd.rz_borrow_tender_28;
insert into rz_borrow_tender_28 select * from new_wd.rz_borrow_tender_28 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_29 like new_wd.rz_borrow_tender_29;
insert into rz_borrow_tender_29 select * from new_wd.rz_borrow_tender_29 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_30 like new_wd.rz_borrow_tender_30;
insert into rz_borrow_tender_30 select * from new_wd.rz_borrow_tender_30 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");

create table rz_borrow_tender_31 like new_wd.rz_borrow_tender_31;
insert into rz_borrow_tender_31 select * from new_wd.rz_borrow_tender_31 WHERE create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00");