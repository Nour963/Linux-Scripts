#!/bin/bash
ping google.com -c2 > /dev/null
if [ $? -eq 0 ]; 
then 
  echo Successful ; 
else 
  echo Failure 
fi 
