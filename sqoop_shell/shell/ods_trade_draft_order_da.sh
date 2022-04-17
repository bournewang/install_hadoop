# ods_trade_draft_order_da 
sqoop import   \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/trade?useSSL=false   \
--username gt1206 --password gt1206@001 --table draft_order   \
--hive-import --hive-table ods.ods_trade_draft_order_da   \
--target-dir ./tlook/$1 --hive-partition-key pt   \
--hive-partition-value $1 --delete-target-dir   \
--outdir /tmp/MysqlToHive --hive-overwrite  \
--null-non-string '\\N' --null-string '\\N'  \
--columns 'order_id,agent_id,onjob_status,shop_code,draft_time,create_time,update_time'  \
-m 1
