#!/bin/sh

if [ $# -ne 1 ];then
	echo "Usage: $0 node_id"
	exit 1
fi

src=/opt
etc=/etc
#etc=/usr/local/etc
#src=.
#etc=.
software=$src/software
profile=$etc/profile
profile_bk=$etc/profile.bk
cur_id=$1
dest=$src/module
nodes="hadoop001 hadoop002 hadoop003"

declare -a apps
apps[0]="jdk JAVA_HOME"
apps[1]="hadoop HADOOP_HOME"
apps[2]="apache-hive HIVE_HOME"
apps[3]="apache-zookeeper ZOOKEEPER_HOME"
apps[4]="sqoop SQOOP_HOME"
apps[5]="scala SCALA_HOME"
apps[6]="spark SPARK_HOME"
apps[7]="kafka KAFKA_HOME"

if [ ! -d $dest ]; then
	mkdir $dest
fi

if [ ! -d $profile_bk ]; then
	cp $profile $profile_bk
fi

init_jdk(){
	echo ""
}
init_hadoop(){
	echo -e "\tappend export PATH=\$PATH:\$HADOOP_HOME/sbin to $profile"
	echo export PATH=\$PATH:\$HADOOP_HOME/sbin >> $profile

	dst_conf=etc/hadoop
	src_conf=$src/conf/hadoop
	sed -i 's#JAVA_HOME=.*#JAVA_HOME='$JAVA_HOME'#' $dst_conf/hadoop-env.sh
	sed -i 's#export HADOOP_CONF_DIR=.*#export HADOOP_CONF_DIR='$HADOOP_HOME'/etc/hadoop#' $dst_conf/hadoop-env.sh

	echo > $dst_conf/slaves
	keeper=''
	for n in $nodes
	do
		echo $n >> $dst_conf/slaves
		keeper=${keeper}${n}:2181,
	done
	keeper=${keeper%,}

	# core_site=${core_site//HADOOP_HOME/$1}
	# core_site=${core_site//KEEPER/$keeper}
	cat $src_conf/core-site.xml |sed 's#HADOOP_HOME#'$1'#' | sed -r 's#KEEPER#'$keeper'#' > $dst_conf/core-site.xml
	# sed -i 's/HADOOP_HOME/'$1'/' $dst_conf/core-site.xml
	# sed -i 's/KEEPER/'$keeper'/' $dst_conf/core-site.xml

	cat $src_conf/hdfs-site.xml |sed 's#HADOOP_HOME#'$1'#' > $dst_conf/hdfs-site.xml
	# sed -i 's/HADOOP_HOME/'$1'/' $dst_conf/hdfs-site.xml

	cp $src_conf/yarn-site.xml $dst_conf/yarn-site.xml
}
init_apache_hive(){
	echo "export HIVE_CONF_DIR=\$HIVE_HOME/conf" >> $profile
	cd conf
	cp hive-default.xml.template hive-site.xml

	# sed -i 's#\${system:user.name}#root#g;s#\${system:java.io.tmpdir}#'$1'/tmp#g' hive-site.xml
	src_conf=$src/conf/hive
	cp $src_conf/hive-site.xml .

	cp hive-env.sh.template hive-env.sh

	echo export JAVA_HOME=$JAVA_HOME 				>> hive-env.sh
	echo export HADOOP_HOME=$HADOOP_HOME			>> hive-env.sh
	echo export HIVE_HOME=$HIVE_HOME				>> hive-env.sh
	echo export HIVE_CONF_DIR=$HIVE_HOME/conf		>> hive-env.sh
	echo export HIVE_AUX_JARS_PATH=$HIVE_HOME/lib	>> hive-env.sh
	# echo "export HIVE_AUX_JARS_PATH=$HIVE_HOME/lib" >> hive-env.sh

	cp $software/mysql-connector-java*.jar $1/lib/
}

init_sqoop(){
#  cd conf
  sqoop_env=conf/sqoop-env.sh
  cp conf/sqoop-env-template.sh $sqoop_env
  echo export HADOOP_COMMON_HOME=${HADOOP_HOME} >> $sqoop_env
  echo export HADOOP_MAPRED_HOME=${HADOOP_HOME} >> $sqoop_env
  echo export HIVE_HOME=${HIVE_HOME} >> $sqoop_env

  cp $software/mysql-connector-java-8*.jar lib/
  cp $HIVE_HOME/lib/hive-common*.jar lib/
}

# $1: home dir
# $2: myid
init_apache_zookeeper()
{
	zkdir=$1/zkdata
	myid=$2
	echo -e "\tmkdir $zkdir"
	mkdir $zkdir
	echo -e "\techo $myid > $zkdir/myid"
	echo $myid > $zkdir/myid
	cd conf
	conf=zoo.cfg
	cp zoo_sample.cfg $conf
	sed -i 's#^dataDir=.*#dataDir='$zkdir'#' $conf

	n=1
	for node in $nodes
	do
		echo "server.${n}=${node}:2888:3888" >> $conf
		let n++
	done
}

init_scala(){
  echo
}

init_spark(){
  echo
  cp conf/spark-env.sh.template conf/spark-env.sh
  while read -r line;
  do
    eval echo $line >> conf/spark-env.sh
  done < $src/conf/spark/env.sh

  for n in $nodes
  do
    echo $n >> conf/slaves
  done
}

init_kafka(){
  echo
  conf=config/server.properties

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
  echo "server: "$server
  sed -ri "s#log.dirs=.*#log.dirs=$1/logs#"           $conf
  sed -ri 's#(num.partitions)=.*#\1=2#'               $conf
  sed -ri 's/^#(log.flush.interval.messages=.*)/\1/'  $conf
  sed -ri 's/^#(log.flush.interval.ms=.*)/\1/'        $conf
  sed -ri "s/(zookeeper.connect)=.*/\1=$server/"      $conf
  let index=$cur_id-1
  sed -ri "s/(broker.id)=.*/\1=$index/"               $conf
  echo host.name=`hostname` >> $conf

  mkdir logs
}
# init_sqoop(){}
i=0
path_str="\$PATH"
while [ $i -lt ${#apps[*]} ]
do
	line=${apps[$i]}
	app=${line%% *}
	HOME=${line##* }
	echo "installing $app";
  #	let i++; continue;
	#echo name $app, home $HOME
	echo -e "\textract $app"
	tar xf $software/$app*gz -C $dest
	cd $dest/$app*
	home=`pwd`
	echo -e "\tappend export $HOME=$home to $profile"
	export $HOME=$home
	echo export $HOME=$home >> $profile
	echo -e "\tappend export PATH=\$PATH:\$$HOME/bin to $profile"
#	echo export PATH=\$PATH:\$$HOME/bin >> $profile
  path_str=${path_str}:\$$HOME/bin

	echo -e "\tinit $app"
	init_${app//-/_} $home $cur_id

	let i++
	cd $src
	echo -e "\tdone, i: $i"
done

echo export PATH=$path_str >> $profile

