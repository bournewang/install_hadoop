# ods_agent_agent_change_log_da  
sqoop import   \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/agent?useSSL=false   \
--username gt1206 --password gt1206@001 --table agent_change_log   \
--hive-import --hive-table ods.ods_agent_agent_change_log_da   \
--target-dir ./agent/$1 --hive-partition-key pt   \
--hive-partition-value $1 --delete-target-dir     \
--outdir /tmp/MysqlToHive --hive-overwrite   \
--null-non-string '\\N' --null-string '\\N'   \
--columns 'id,create_time,update_time,agent_id,original_org_code,new_org_code,org_type,change_date'   \
-m 1


