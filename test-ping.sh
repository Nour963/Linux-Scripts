#!/bin/bash
# ' $? ' is the exit status code, it it's 0 then the command is successful
ping google.com -c2 > /dev/null
if [ $? -eq 0 ]; 
then 
  echo Successful ; 
else 
  echo Failure 
fi 
