#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/8
# for i in range(32):
#     f = open("temp/rz_borrow_tender_{i}.sql".format(i=i), "w")
#     f.write("""insert into rz_borrow_tender_{i} select * from new_wd.rz_borrow_tender_{i}
# where create_time > "2017-09-20 23:30:00 " and create_time <= "2017-09-21 23:30:00";
# """.format(i=i))
#     f.close()


for i in range(32):
    print("""insert into rz_borrow_tender_{i} select * from new_wd.rz_borrow_tender_{i}
where create_time > "2017-09-20 23:30:00" and create_time <= "2017-09-21 23:30:00";
""".format(i=i))
