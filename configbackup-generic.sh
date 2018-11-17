#!/bin/bash

#JGleba
#08-15-2018
#Backs up FreeNAS config db to util folder within pool

#Grabs path from pool, run this or dataset command below, uncomment to use
poolpath=( $(zpool list | grep -v freenas-boot | grep -v NAME | awk '{print $1}') )
#Grabs path from dataset with name containing word 'data', run this or pool command above, uncomment to use
#poolpath=( $(zfs list | grep mnt | grep data | awk '{print $1}') )

for i in "${poolpath[@]}"
do
   cp /data/freenas-v1.db "/mnt/"."$i"."/util/"
done

