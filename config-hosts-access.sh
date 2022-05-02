#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Usage: $0 hosts"
  echo "hosts seperated by space"
  echo example: $0 \"10.10.10.1 10.10.10.2 10.10.10.3\"
  exit 1
fi

user=root
array=$1
cmd="ssh-keygen -t rsa -q -P '' -f ~/.ssh/id_rsa"

for ip in ${array[@]}
do
   echo $ip
   echo "create ssh keys in $ip"
   ssh $user@$ip $cmd
   echo "copy key back from $ip"
   scp $user@$ip:~/.ssh/id_rsa.pub key-$ip
done

echo "merging keys to keys"
cat key-* > keys
rm -f key-*

for ip in ${array[@]}
do
   echo "dispatching keys to $ip"

#   echo "copy key back from $ip"
   scp keys $user@$ip:~/keys
   ssh $user@$ip "cat keys >> .ssh/authorized_keys; rm -f keys"
done
#
rm -f keys

