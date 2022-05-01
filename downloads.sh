#!/bin/sh
if [ ! -d software ]; then
  mkdir software
fi
cd software
echo "downloading packages"
i=1
while read url
do
  echo $i download $url
  let i=$i+1
  wget $url
done < ../urls.txt
