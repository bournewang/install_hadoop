#!/bin/bash
if [ -z "$1" ];then
  echo "请输入日期参数：yyyyMMdd."
  exit 1
else

  while read line
  do
    sh ../shell/$line $1
    echo "----------已执行完成："$line"---------------"
  done < ./sqoop_list.data

fi