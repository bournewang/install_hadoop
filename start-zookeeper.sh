#!/bin/sh
nodes="hadoop001
hadoop002
hadoop003"
remote_exec(){
  host=$1
  cmd=$2
  echo ssh $host $cmd
  ssh $host "source /etc/profile; $cmd"
}
# start zookeeper in all nodes
echo "--- start zookeepers on all of the nodes"
for node in $nodes; do
  remote_exec $node "zkServer.sh start; zkServer.sh status;"
done
