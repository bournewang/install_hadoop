# ods_crm_cust_manage_da
sqoop import  \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/crm?zeroDateTimeBehavior=CONVERT_TO_NULL  \
--username gt1206 --password gt1206@001 --table cust_manage  \
--hive-import  \
--hive-table ods.ods_crm_cust_manage_da  \
--target-dir ./crm/$1 --hive-partition-key pt  \
--hive-partition-value $1 --delete-target-dir  \
--outdir /tmp/MysqlToHive --hive-overwrite  \
--null-non-string '\\N' --null-string '\\N'  \
--columns 'id,cust_name,telephone1,telephone2,sex,age,city_code,create_time,update_time'  \
-m 1
