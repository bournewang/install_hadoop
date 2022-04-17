# ods_trade_trade_order_da  
sqoop import   \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/trade?useSSL=false   \
--username gt1206 --password gt1206@001 --table trade_order   \
--hive-import --hive-table ods.ods_trade_trade_order_da   \
--target-dir ./trade/$1 --hive-partition-key pt   \
--hive-partition-value $1 --delete-target-dir    \
--outdir /tmp/MysqlToHive --hive-overwrite   \
--null-non-string '\\N' --null-string '\\N'   \
--columns 'id,status,typing_type,city_code,price,buyer_telephone,seller_telephone,seal_time,draft_time,transfer_time,invalid_time,sign_time,revoke_time,finish_time,create_time,update_time,cdel_id,hdel_id,agent_id'   \
-m 1
