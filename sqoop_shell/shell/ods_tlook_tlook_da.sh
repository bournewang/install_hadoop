# ods_tlook_tlook_da  
sqoop import   \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/tlook?useSSL=false   \
--username gt1206 --password gt1206@001 --table tlook   \
--hive-import --hive-table ods.ods_tlook_tlook_da   \
--target-dir ./tlook/$1 --hive-partition-key pt   \
--hive-partition-value $1 --delete-target-dir   \
--outdir /tmp/MysqlToHive --hive-overwrite   \
--null-non-string '\\N' --null-string '\\N'   \
--columns 'id,tlook_start_time,tlook_end_time,tlook_create_time,cdel_code,hdel_code,is_valied,data_source,type,agent_id,city_code,has_holder,create_time,update_time'   \
-m 1