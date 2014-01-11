#!/bin/bash

SUBNETS=(subnet1 subnet2)
USERDATA="file://path/to/file"
KEY="Your Key"
AMI="AMI id"
SECURITY_GROUP="Your Security Key"

for i in `seq 1 2`
do
  for SUBNET in ${SUBNETS[@]}
  do
    id=`aws ec2 run-instances \
    --image-id ${AMI} \
    --count 1 \
    --instance-type t1.micro \
    --key-name ${KEY} \
    --security-group-ids ${SECURITY_GROUP} \
    --subnet-id ${SUBNET} \
    --associate-public-ip-address \
    --user-data ${USERDATA} | jq '.Instances[]|.InstanceId' | sed 's/"//g'`
    # regist to tag
    aws ec2 create-tags --resources $id --tags Key=Name,Value=param${i}
    echo ${id}
  done
done
