#!/bin/bash
#if partition /dev/sda2 exceeds 9 Go, 
#then remove files only in TMP_DIRS variable tmp directories that was last modified 1h ago
#and if done, log a message with date and time when it was done to syslog

USAGE=$(df -H | grep '/dev/sda2' | awk '{ print $5 }' | cut -c1)
TMP_DIRS="/tmp /var/tmp /usr/src/tmp /mnt/tmp"

if [[ "$USAGE" -gt 9 ]]
then
  find $TMP_DIRS -type f -mmin +60 -exec rm -f {} \;
  logger "cleaned up at `date`"
fi

