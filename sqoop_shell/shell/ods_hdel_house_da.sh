# ods_hdel_house_da  
sqoop import  \
--connect jdbc:mysql://rm-2ze9z87x15p0qa7bgfo.mysql.rds.aliyuncs.com:3306/hdel?useSSL=false  \
--username gt1206 --password gt1206@001 --table house  \
--hive-import --hive-table ods.ods_hdel_house_da  \
--target-dir ./hdel/$1 --hive-partition-key pt  \
--hive-partition-value $1 --delete-target-dir  \
--outdir /tmp/MysqlToHive --hive-overwrite  \
--null-non-string '\\N' --null-string '\\N'  \
--columns 'id,resblockl,unit_ID,over_floor_umt,eletor_num,floor_area,build_year,build_struct,parlor_num,bedroom_num,has_balcony,create_time,update_time'  \
-m 1