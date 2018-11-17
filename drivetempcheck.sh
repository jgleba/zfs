#!/bin/sh

#Justin Gleba
#April 18, 2017
#FreeNAS device temperature check. Email if devices are too hot. Too hot set in "DriveTooHot"
#Schedule through cron
#Uses FreeNAS email system

DriveTooHot="60"
IsTooHot="0"
destemail="a@a.com"

echo "DRIVE TEMPERATURE ISSUE
" > temptmp.txt

for i in $(sysctl -n kern.disks)
do
        DevTempCel="N/A"

	DevTemp=`smartctl -a /dev/$i | awk '/Temperature_Celsius/{print $0}' | awk '{print $10}'`	
	DevSerNum=`smartctl -a /dev/$i | awk '/Serial Number:/{print $0}' | awk '{print $3}'`
        DevName=`smartctl -a /dev/$i | awk '/Device Model:/{print $0}' | awk '{print $3}'`

	if [ -n "$DevTemp" ]
	then
		DevTempCel=$DevTemp"C"
		
		if [ "$DevTemp" -gt "$DriveTooHot" ]
		then
			IsTooHot="1"
		fi
	fi
	echo $i "|" $DevTempCel "|" $DevSerNum "|" $DevName >> temptmp.txt
done

if [ "$IsTooHot" == "1" ]
then 
	cat temptmp.txt | /usr/bin/mail -s "Drive Temperature Issue" $destemail
fi

rm temptmp.txt
