#!/bin/bash

#JGleba
#08-15-2018
#Snapshot date check, get current date, check current snapshot date, if older than stalesnapshot value in seconds, email, also emails last n snapshots set in latestsnapshotquantity
#reverse array loop from: https://unix.stackexchange.com/questions/412868/bash-reverse-an-array

destemail="a@a.com"
stalesnapshot="10800"
latestsnapshotquantity="10"
currentdateseconds=$(date +%s)

i=0
j=0

#Grabs snapshots from pool, run this or dataset command below, uncomment to use
poolpath=( $(zpool list | grep -v freenas-boot | grep -v NAME | awk '{print $1}') )
#Grabs snapshots from dataset with name containing word 'data', run this or pool command above, uncomment to use
#poolpath=( $(zfs list | grep mnt | grep data | awk '{print $1}') )

for i in "${poolpath[@]}"
do
     snapshots=( $(zfs list -r -t snapshot -H -o name $i | awk -F'@' '{print $2}' | awk -F'-' '{print $2}') )       

     totalsnapshotcount="${#snapshots[@]}"
     latestsnapshot=${snapshots[-1]}
     latestsnapshotdateseconds=$(date -j -f "%Y%m%d.%H%M" "$latestsnapshot" +"%s")
     snapdatecurrentdatediff=$(expr "$currentdateseconds" - "$latestsnapshotdateseconds")
     
     latestsnapshotcount=$(expr "$totalsnapshotcount" - "$latestsnapshotquantity")    
     latestsnapshotlist=( $(echo ${snapshots[@]:$latestsnapshotcount:$totalsnapshotcount}) )

     min=0
     max=$(( ${#latestsnapshotlist[@]} -1 ))
     while [[ min -lt max ]]
     do
         x="${latestsnapshotlist[$min]}"
         latestsnapshotlist[$min]="${latestsnapshotlist[$max]}"
         latestsnapshotlist[$max]="$x"
         (( min++, max-- ))
     done

     if [ "$snapdatecurrentdatediff" -gt "$stalesnapshot" ]
     then
          echo "Pool" $'\n' $i $'\n' $'\n' "Latest $latestsnapshotquantity Snapshots" $'\n' "${latestsnapshotlist[@]}" | /usr/bin/mail -s "Snapshot Alert" $destemail
     fi
done
