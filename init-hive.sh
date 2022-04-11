#!/bin/sh
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod -R 777 /user/hive/warehouse
hdfs dfs -mkdir -p /tmp/hive
hdfs dfs -chmod -R 777 /tmp/hive
cd $HIVE_HOME
mkdir tmp
chmod 777 tmp

schematool -dbType mysql -initSchema
hive --service metastore