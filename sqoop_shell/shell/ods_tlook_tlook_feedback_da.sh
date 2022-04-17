# ods_tlook_tlook_feedback_da
sqoop import   \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/tlook?zeroDateTimeBehavior=CONVERT_TO_NULL   \
--username gt1206 --password gt1206@001 --table tlook_feedback   \
--hive-import --hive-table ods.ods_tlook_tlook_feedback_da   \
--target-dir ./tlook/$1 --hive-partition-key pt   \
--hive-partition-value $1 --delete-target-dir   \
--outdir /tmp/MysqlToHive --hive-overwrite   \
--null-non-string '\\N' --null-string '\\N'   \
--columns 'id,tlook_id,tlook_feedback,create_time,update_time'   \
-m 1
