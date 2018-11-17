#!/bin/bash

#Justin Gleba
#May 10, 2017
#FreeNAS CPU temperature monitoring. Email if CPU gets too hot. Too hot set in "CPUTOOHIGH"
#Schedule through cron
#Uses FreeNAS email system

CPUTOOHIGH="70"
CPUMAX="0"
destemail="a@a.com"

mapfile -t cputemps < <(sysctl -a | egrep -E "cpu\.[0-9]+\.temp" | awk -F " " '{print $2}' | awk -F "." '{print $1}')

for (( i=0; i<${#cputemps[@]}; i++ ));
do		
	if [ "${cputemps["$i"]}" -gt "$CPUMAX" ]
	then
		CPUMAX="${cputemps["$i"]}"
	fi
done

if [ "$CPUMAX" -gt "$CPUTOOHIGH" ]
then
	echo "CPU TEMPS 
	"> cputemp.txt
	sysctl -a | egrep -E "cpu\.[0-9]+\.temp" >> cputemp.txt
	cat cputemp.txt | /usr/bin/mail -s "CPU Temperature Issue" $destemail
	rm cputemp.txt
fi
