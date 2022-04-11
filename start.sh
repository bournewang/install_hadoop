#!/bin/sh
nodes="hadoop001
hadoop002
hadoop003"
remote_exec(){
  host=$1
  cmd=$2
  echo ssh $host $cmd
  echo ssh $host $cmd >> start.log
  ssh $host "source /etc/profile; $cmd" >> start.log 2>&1
}
# start zookeeper in all nodes
echo "--- start zookeepers on all of the nodes"
for node in $nodes; do
  remote_exec $node "zkServer.sh start; zkServer.sh status;"
done

echo "--- format zookeeper"
remote_exec hadoop001 "hdfs zkfc -formatZK"

echo "--- start journalnode on all of the nodes"
for node in $nodes; do
  remote_exec $node "hadoop-daemon.sh start journalnode"
done

echo "--- namenode format"
remote_exec hadoop001 "hadoop namenode -format; hadoop-daemon.sh start namenode"

echo "--- namenode standby"
remote_exec hadoop002 "hadoop namenode -bootstrapStandBy; hadoop-daemon.sh start namenode"

echo "--- start datanode on all of the nodes"
for node in $nodes; do
  remote_exec $node "hadoop-daemon.sh start datanode"
done

echo "--- start fail over control on 01/02 node"
for node in hadoop001 hadoop002; do
  remote_exec $node "hadoop-daemon.sh start zkfc"
done

echo "--- start yarn on 03 node"
remote_exec hadoop003 "start-yarn.sh"

echo "--- start resrouce manager on 01 node"
remote_exec hadoop001 "yarn-daemon.sh start resourcemanager"