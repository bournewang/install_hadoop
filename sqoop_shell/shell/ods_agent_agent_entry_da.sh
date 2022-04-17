# ods_agent_agent_entry_da
sqoop import   \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/agent?zeroDateTimeBehavior=CONVERT_TO_NULL   \
--username gt1206 --password gt1206@001 --table agent_entry   \
--hive-import --hive-table ods.ods_agent_agent_entry_da   \
--target-dir ./agent/$1 --hive-partition-key pt   \
--hive-partition-value $1 --delete-target-dir    \
--outdir /tmp/MysqlToHive --hive-overwrite   \
--null-non-string '\\N' --null-string '\\N'   \
--columns 'id,agent_id,entry_date,shop_code'   \
-m 1


