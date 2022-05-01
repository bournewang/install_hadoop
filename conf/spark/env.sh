export JAVA_HOME=$JAVA_HOME
export SCALA_HOME=$SCALA_HOME
export HADOOP_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HIVE_HOME=$HIVE_HOME
export HIVE_CONF_DIR=$HIVE_HOME/conf
export SPARK_MASTER_IP=hadoop001
export SPARK_MASTER_HOST=hadoop001
#export SPARK_LOCAL_IP=hadoop001
export SPARK_WORKER_MEMORY=1g
export SPARK_WORKER_CORES=2
export SPARK_HOME=$SPARK_HOME
export SPARK_DIST_CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath`
