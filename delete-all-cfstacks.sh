#!/bin/bash
##how to run
## either ./script.sh   to delete all stacks
## or ./script.sh "LBL-CNT1-4555-1"        to exclude a stack from deletion
## or ./script.sh "LBL-CNT1-4555-1\|LBL-CNT1-4555-2"    to exclude multiple stacks from deletion
export AWS_RETRY_MODE=standard; export AWS_MAX_ATTEMPTS=1000
aws cloudformation list-stacks --query 'StackSummaries[]|[?StackStatus != `DELETE_COMPLETE`].[StackName]' --output text > stacknames.txt.tmp
if [[ "$1" != '' ]]; then cp stacknames.txt.tmp stacknames.txt.tmp2;  grep -v "$1" stacknames.txt.tmp2 > stacknames.txt.tmp; fi
STACKNAMES=$(cat stacknames.txt.tmp | xargs)
for s in $STACKNAMES; do
  echo $s
  for Id in $(aws ec2 describe-instances --filters Name=tag:Name,Values=$s --query 'Reservations[].Instances[?State.Name != `terminated`].[InstanceId]'  --output text); do aws ec2 modify-instance-attribute --no-disable-api-termination --instance-id $Id; done
  stackid=$(aws cloudformation list-stacks --query 'StackSummaries[?StackName==`'"$s"'`]|[?StackStatus != `DELETE_COMPLETE`].[StackId]' --output text)
  aws cloudformation delete-stack --stack-name $stackid
done
