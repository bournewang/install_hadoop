
# ods_agent_agent_da
sqoop import \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/agent?useSSL=false     \
--username gt1206 --password gt1206@001  --table agent     \
--hive-import  \
--hive-table ods.ods_agent_agent_da     \
--target-dir ./agent/$1 --hive-partition-key pt      \
--hive-partition-value $1                 \
--delete-target-dir --outdir /tmp/MysqlToHive     \
--hive-overwrite      \
--null-non-string '\\N'  --null-string '\\N'  \
--columns 'id,account,email,sex,birth_date,nation,marriage,cert_type,shop_code,cert_no,nationality,name,status,create_time,update_time'  \
-m 1