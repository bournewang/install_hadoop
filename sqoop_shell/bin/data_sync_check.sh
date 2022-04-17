#!/bin/bash
if [ -z "$1" ];then
  echo "请输入日期参数：yyyyMMdd."
  exit 1
else
  hive -hiveconf pt=$1 -f data_sync_check.hql
fi



