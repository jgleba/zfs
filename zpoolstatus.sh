#!/bin/bash

#Justin Gleba
#April 18, 2017
#FreeNAS daily zpool status run. Runs a bunch of ZFS info and status commands, outputs to a text file, emails contents of file and deletes file.
#Schedule through cron
#Uses FreeNAS email system

#Get pool name
poolname=$(zpool list | grep -v freenas-boot | grep -v NAME | awk '{print $1}')

touch /tmp/zpooltemp.txt
zpool list >> /tmp/zpooltemp.txt
echo " " >> /tmp/zpooltemp.txt
zfs get all $poolname | grep usedbydataset >> /tmp/zpooltemp.txt
zfs get all $poolname | grep usedbysnapshots >> /tmp/zpooltemp.txt
echo " " >> /tmp/zpooltemp.txt
zpool status >> /tmp/zpooltemp.txt
echo " " >> /tmp/zpooltemp.txt
glabel status >> /tmp/zpooltemp.txt
echo " " >> /tmp/zpooltemp.txt
geom disk list | grep -e descr -e Name -e ident >> /tmp/zpooltemp.txt
cat /tmp/zpooltemp.txt | /usr/bin/mail -s "daily zpool status" a@a.com

rm /tmp/zpooltemp.txt
