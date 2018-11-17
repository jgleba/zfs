#!/bin/sh

#08-14-18
#JGleba
#FreeNAS config db backup. Copies to pool util folder.
#Schedule through cron.

cp /data/freenas-v1.db /mnt/pool1/fnasutil/
