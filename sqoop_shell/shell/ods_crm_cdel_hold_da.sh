# ods_crm_cdel_hold_da
sqoop import \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/crm?useSSL=false \
--username gt1206 --password gt1206@001 --table cdel_hold \
--hive-import \
--hive-table ods.ods_crm_cdel_hold_da \
--target-dir ./crm/$1 --hive-partition-key pt \
--hive-partition-value $1 \
--delete-target-dir --outdir /tmp/MysqlToHive \
--hive-overwrite --null-non-string '\\N' --null-string '\\N' \
--columns 'id,cdel_id,holder_id,shop_code,status,create_time,update_time' \
-m 1