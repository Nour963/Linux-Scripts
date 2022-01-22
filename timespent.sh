#calculate time spent on server by ubuntu user from 'last' command output
#!/bin/bash
if [ "$(last ubuntu | grep ubuntu )" == "" ]; then echo 0; exit 0; fi
if [ "$(last ubuntu | grep still )" != "" ]; then
   if [ "$(cat /usr/support/.still)" -eq "0" ]; then tail -1 /var/log/kpis.log | jq -r .timespent | tee /usr/support/.oldts ; echo "1" > /usr/support/.still; exit 0; fi 
   oldts=$(cat /usr/support/.oldts); ; echo "$oldts+$(cat /usr/support/.still)" | bc
   newstill="$(echo $(cat /usr/support/.still)+1 | bc)"; echo $newstill > /usr/support/.still
   exit 0
fi
echo "0" > /usr/support/.still; last ubuntu | grep ubuntu | grep '-' | tac > /usr/support/.last.txt
#preprocessing
#if start_time<=23:59 and end_time>=00:00; add 24h to end_time
lines="$(wc -l < /usr/support/.last.txt)"
i=1; while [ $i -le $lines ]; do
  v1="$(sed ''"$i"'!d' /usr/support/.last.txt| awk '{print $7}' | tr -d ':')"
  v2="$(sed ''"$i"'!d' /usr/support/.last.txt| awk '{print $9}' | tr -d ':')"
  if [ $v1 -gt $v2 ]; then 
    val=$(echo $v2 | sed 's/^0*//'); val=$((val+2400))
    newv2="$(echo ${val:0:2}:${val:2:2})"
    oldv2="$(echo ${v2:0:2}:${v2:2:2})"
    sed -i "${i}s/$oldv2/$newv2/g" /usr/support/.last.txt
  fi
  i=$((i+1))
done
#separate each group of tabs apart
lines="$(wc -l < /usr/support/.last.txt)"
a=1; i=1
while [ $i -le $lines ]; do
  sed ''"$i"'!d' /usr/support/.last.txt  > /usr/support/.tabgrp_$a.txt
  z=$(( i+1 )); 
  if [ $z -gt $lines ]; then break; fi
  end_time="$(sed ''"$i"'!d' /usr/support/.last.txt| awk '{print $9}' | tr -d ':')"
  start_time="$(sed ''"$z"'!d' /usr/support/.last.txt| awk '{print $7}' | tr -d ':')"
  while [ $start_time -le $end_time ]; do
     sed ''"$z"'!d' /usr/support/.last.txt  >> /usr/support/.tabgrp_$a.txt
     end_time="$(sed ''"$z"'!d' /usr/support/.last.txt| awk '{print $9}' | tr -d ':')" 
     z=$(( z+1 ))
     start_time="$(sed ''"$z"'!d' /usr/support/.last.txt| awk '{print $7}' | tr -d ':')"
     if [ "$(echo $start_time)" == "" ]; then break 2; fi
  done
  a=$(( a+1 )); i=$z
done
#due to preprocessing step, if file contains one time > 2359, then add 24h to the whole group
filesname="$(awk '$9 > "23:59" || $7 > "23:59" { print FILENAME }' /usr/support/.tabgrp_*.txt | uniq | xargs)"
for f in ${filesname}; do
  ref="$(head -n 1 $f | awk '{print $7}' | tr -d ':')"
  values="$(cat $f | awk '{print $7, $9}' | tr -d ':' | xargs | uniq)"
  for v in ${values}; do
   if [ $v -lt $ref ]; then
      val=$(echo $v | sed 's/^0*//'); val=$((val+2400))
      newv="$(echo ${val:0:2}:${val:2:2})"
      oldv="$(echo ${v:0:2}:${v:2:2})"
      sed -i "s/$oldv/$newv/g" $f 
   fi
  done
done
#count timespent from each group of tabs
lines="$(ls -l /usr/support/.tabgrp_*.txt | wc -l)" ; i=1 ; sum=0
while [ $i -le $lines ]; do
  max=$(cat /usr/support/.tabgrp_$i.txt | awk '{print $7, $9}' | xargs | tr " " "\n" | sort -r -n | head -n 1)
  min=$(cat /usr/support/.tabgrp_$i.txt | awk '{print $7, $9}' | xargs | tr " " "\n" | sort -n | head -n 1)
  if [ $(echo $max | tr -d ':') -gt 2359 ]; then 
    max=$(echo $max | tr -d ':'); max=$((max-2400)); if [ $(echo $max | wc -c) -lt 5 ]; then max=$(printf "%04d" $max); fi
    max="$(echo +1 days ${max:0:2}:${max:2:2})"
  fi
  Starttime=$(date -u -d "$min" +"%s")
  Finaltime=$(date -u -d "$max" +"%s")
  val=$(date -u -d "0 $Finaltime sec - $Starttime sec" +"%H:%M" | awk -F: '{ if (NF == 1) {print $NF} else if (NF == 2) {print $1 * 60 + $2} else if (NF==3) {print $1 * 3600 + $2 * 60 + $3} }')
  sum=$(( $sum+$val )) ; i=$(( i+1 ))
done
echo $sum
