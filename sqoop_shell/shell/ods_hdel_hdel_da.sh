# ods_hdel_hdel_da  
sqoop import  \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/hdel?useSSL=false  \
--username gt1206 --password gt1206@001 --table hdel  \
--hive-import --hive-table ods.ods_hdel_hdel_da  \
--target-dir ./hdel/$1 --hive-partition-key pt  \
--hive-partition-value $1 --delete-target-dir  \
--outdir /tmp/MysqlToHive --hive-overwrite  \
--null-non-string '\\N' --null-string '\\N'  \
--columns 'id,house_id,status,listing_price,tlook_date,listing_time,hold_agent,typing_agent,entrust_time,create_time,update_time'  \
-m 1
