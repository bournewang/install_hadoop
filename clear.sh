#!/bin/sh

echo "clear apps"
etc=/etc
#etc=/usr/local/etc
dest=/opt/module
for app in $dest/*
do
    echo "remove $app"
    rm -rf $app*
done

if [ -f $etc/profile.bk ];
then
    echo "resotre $etc/profile"
    cp $etc/profile.bk $etc/profile
fi

echo "done!"
echo
