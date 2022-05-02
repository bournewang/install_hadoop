#!/bin/sh

if [ $# -ne 1 ];then
	echo "Usage: $0 node_id"
	exit 1
fi

src=`pwd`
#etc=/etc
etc=/usr/local/etc
#src=.
software=$src/software
profile=$etc/profile
profile_bk=$etc/profile.bk
cur_id=$1
dest=/opt
module=$dest/module
nodes="hadoop001 hadoop002 hadoop003"

echo "This script will install hadoop and following packages into $module"
if [ `which awk> /dev/null;echo $?` -eq 0 ];then
  awk '{print $1}' packages.txt
fi
#exit 1;
if [ ! -d $module ]; then
	mkdir $module
fi

if [ ! -d $profile_bk ]; then
	cp $profile $profile_bk
fi

exec1(){
  echo "    $1"
  eval $1
}

init_jdk(){
#  do nothing
	install_jdk=1
}
init_hadoop(){
  exec1 "echo export HADOOP_COMMON_LIB_NATIVE_DIR=\${HADOOP_HOME}/lib/native  >> $profile"
  exec1 "echo export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib\"  >> $profile"

	src_conf=$src/conf/hadoop
	exec1 "cd etc/hadoop"
	exec1 "sed -i 's#JAVA_HOME=.*#JAVA_HOME=$JAVA_HOME#' hadoop-env.sh"
	exec1 "sed -i 's#export HADOOP_CONF_DIR=.*#export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop#' hadoop-env.sh"

	exec1 "echo > slaves"
	keeper=''
	for n in $nodes
	do
		exec1 "echo $n >> slaves"
		keeper=${keeper}${n}:2181,
	done
	keeper=${keeper%,}

	exec1 "cat $src_conf/core-site.xml |sed 's#HADOOP_HOME#$1#' | sed -r 's#KEEPER#$keeper#' > core-site.xml"
	exec1 "cat $src_conf/hdfs-site.xml |sed 's#HADOOP_HOME#$1#' > hdfs-site.xml"
	exec1 "cp $src_conf/yarn-site.xml yarn-site.xml"
}
init_apache_hive(){
	exec1 "export HIVE_CONF_DIR=\$HIVE_HOME/conf >> $profile"
	exec1 "cd conf"
	exec1 "cp hive-default.xml.template hive-site.xml"
	src_conf=$src/conf/hive
	exec1 "cp $src_conf/hive-site.xml ."
	exec1 "cp hive-env.sh.template hive-env.sh"
	exec1 "echo export JAVA_HOME=$JAVA_HOME              >> hive-env.sh"
	exec1 "echo export HADOOP_HOME=$HADOOP_HOME          >> hive-env.sh"
	exec1 "echo export HIVE_HOME=$HIVE_HOME              >> hive-env.sh"
	exec1 "echo export HIVE_CONF_DIR=$HIVE_HOME/conf     >> hive-env.sh"
	exec1 "echo export HIVE_AUX_JARS_PATH=$HIVE_HOME/lib >> hive-env.sh"
	exec1 "cp $software/mysql-connector-java*.jar $1/lib/"
}

init_sqoop(){
  exec1 "cd conf"
  sqoop_env=sqoop-env.sh
  exec1 "cp sqoop-env-template.sh $sqoop_env"
  exec1 "echo export HADOOP_COMMON_HOME=${HADOOP_HOME} >> $sqoop_env"
  exec1 "echo export HADOOP_MAPRED_HOME=${HADOOP_HOME} >> $sqoop_env"
  exec1 "echo export HIVE_HOME=${HIVE_HOME} >> $sqoop_env"
  exec1 "cd .."
  exec1 "cp $software/mysql-connector-java-8*.jar lib/"
  exec1 "cp $HIVE_HOME/lib/hive-common*.jar lib/"
}

# $1: home dir
# $2: myid
init_apache_zookeeper()
{
	zkdir=$1/zkdata
	myid=$2
	exec1 "mkdir $zkdir"
	exec1 "echo $myid > $zkdir/myid"
	exec1 "cd conf"
	conf=zoo.cfg
	exec1 "cp zoo_sample.cfg $conf"
	exec1 "sed -i 's#^dataDir=.*#dataDir='$zkdir'#' $conf"

	n=1
	for node in $nodes
	do
		exec1 "echo server.${n}=${node}:2888:3888 >> $conf"
		let n++
	done
}

init_scala(){
#  do nothing
  install_scala=1
}

init_spark(){
  exec1 "cd conf"
  exec1 "cp spark-env.sh.template spark-env.sh"
  while read -r line;
  do
    exec1 "echo $line >> spark-env.sh"
  done < $src/conf/spark/env.sh

  exec1 "echo export SPARK_LOCAL_IP=hadoop00${cur_id} >> spark-env.sh"

  for n in $nodes
  do
    exec1 "echo $n >> slaves"
  done
}

init_hbase(){
#  echo
  exec1 "cd conf"
  exec1 "cp $src/conf/hbase/hbase-site.xml ."
  exec1 "cp $HADOOP_HOME/etc/hadoop/core-site.xml ."
  exec1 "cp $HADOOP_HOME/etc/hadoop/hdfs-site.xml ."
  exec1 "echo export JAVA_HOME=$JAVA_HOME   >> hbase-env.sh"
  exec1 "echo export HBASE_MANAGES_ZK=false >> hbase-env.sh"

  for n in $nodes
  do
    exec1 "echo $n >> regionservers"
  done
}

init_apache_flume(){
  exec1 "cd conf"
  exec1 "cp flume-env.sh.template flume-env.sh"
  exec1 "echo export JAVA_HOME=$JAVA_HOME >> flume-env.sh"
}
init_kafka(){
  conf=server.properties

  server=""
  for node in $nodes
  do
    if [ ! $server ]
    then
      server=${node}:2181
    else
      server=$server",${node}:2181"
    fi
  done
#  echo "server: "$server
  exec1 "cd config"
  exec1 "sed -ri 's#log.dirs=.*#log.dirs=$1/logs#'          $conf"
  exec1 "sed -ri 's#(num.partitions)=.*#\1=2#'              $conf"
  exec1 "sed -ri 's/^#(log.flush.interval.messages=.*)/\1/' $conf"
  exec1 "sed -ri 's/^#(log.flush.interval.ms=.*)/\1/'       $conf"
  exec1 "sed -ri 's/(zookeeper.connect)=.*/\1=$server/'     $conf"
  let index=$cur_id-1
  exec1 "sed -ri 's/(broker.id)=.*/\1=$index/'              $conf"
  exec1 "echo host.name=`hostname` >> $conf"

  exec1 "mkdir logs"
}

init_flink(){
#  echo
  exec1 "cd conf"
  exec1 "sed -ri 's/^(jobmanager.rpc.address:) .*/\1 hadoop003/'  flink-conf.yaml"
  exec1 "echo hadoop003:8081 > masters"
  exec1 "echo hadoop001 > workers"
  exec1 "echo hadoop002 >> workers"
}
# init_sqoop(){}
i=1
path_str=""
while read line
do
	app=${line%% *}
	HOME=${line##* }
	echo "------------------------------------------------------------------"
	echo "installing package $i: $app";
	exec1 "tar xf $software/$app*gz -C $module"
	exec1 "cd $module/$app*"
	home=`pwd`
#	cmd="export $HOME=$home"
#	exec1 '$cmd
	export $HOME=$home
	exec1 "echo export $HOME=$home >> $profile"
#	if [ $i -gt 2 ]; then
#	  exit 1
#	fi
  if [ ! $path_str ]; then
    path_str=\$$HOME/bin
  else
    path_str=${path_str}:\$$HOME/bin
  fi
  if [ -d `pwd`/sbin ]; then
    path_str=${path_str}:\$$HOME/sbin
  fi

#	echo "init $app"
	init_${app//-/_} $home $cur_id
  echo
	let i++
	cd $src
#	echo "done, i: $i"
done < packages.txt

exec1 "echo export PATH=\$PATH:$path_str >> $profile"

echo "------------------------------------------------------------------"
echo "copy clear and init script to $dest"
exec1 "cp clear.sh start-zookeeper.sh init-hive.sh start.sh $dest"

echo
echo "------------------------------------------------------------------"
echo "install completely! "
echo "go to $dest, and run start.sh on hadoop001 to start services."
echo

