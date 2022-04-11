#!/bin/sh
#sqoop list-databases --connect jdbc:mysql://localhost:3306/ --username root --password
sqoop import \
  --connect jdbc:mysql://localhost:3306/test --username root --password Yukun@2022 \
  --table stu \
  --hive-import \
  --hive-overwrite \
  --create-hive-table \
  --delete-target-dir \
  --hive-database default \
  --hive-table ods_test_stu -m 1