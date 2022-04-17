# ods_hdel_hdel_prospect_da
sqoop import  \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/hdel?zeroDateTimeBehavior=CONVERT_TO_NULL  \
--username gt1206 --password gt1206@001 --table hdel_prospect  \
--hive-import --hive-table ods.ods_hdel_hdel_prospect_da  \
--target-dir ./hdel/$1 --hive-partition-key pt  \
--hive-partition-value $1 --delete-target-dir  \
--outdir /tmp/MysqlToHive --hive-overwrite  \
--null-non-string '\\N' --null-string '\\N'  \
--columns 'id,hdel_id,prospect_time,prospect_agent_id,create_time,update_time'  \
-m 1
