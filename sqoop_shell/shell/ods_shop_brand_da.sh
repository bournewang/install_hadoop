# ods_shop_brand_da
sqoop import  \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/shop?zeroDateTimeBehavior=CONVERT_TO_NULL  \
--username gt1206 --password gt1206@001 --table brand  \
--hive-import --hive-table ods.ods_shop_brand_da  \
--target-dir ./shop/$1 --hive-partition-key pt  \
--hive-partition-value $1 --delete-target-dir  \
--outdir /tmp/MysqlToHive --hive-overwrite  \
--null-non-string '\\N' --null-string '\\N'  \
--columns 'id,name,type,create_time,update_time'  \
-m 1