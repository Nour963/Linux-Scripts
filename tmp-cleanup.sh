#!/bin/bash
#if partition /dev/sda2 exceeds 9% of Use, 
#then remove only files (and not directories) in TMP_DIRS variable tmp directories that was last modified 1h ago
#and if done, log a message with date and time when it was done to syslog

USAGE=$(df -H | grep '/dev/sda2' | awk '{ print $5 }' | cut -d "%" -f1) #percentage of disk use, then remove '%' sign
#USAGE=$(df -H | grep '/dev/sda2' | awk '{ print $4 }' | sed 's/.$//') "removes last caracter, no matter what it is

TMP_DIRS="/tmp /var/tmp /usr/src/tmp /mnt/tmp"

if [[ "$USAGE" -gt 9 ]]
then
  find $TMP_DIRS -type f -mmin +60 -exec rm -f {} \;
  logger "cleaned up at `date`"
fi

#Make it a cronjob every 3 days
#crontab -e
#0 */3 * * * /bin/bash /opt/script/tmp-cleanup.sh
