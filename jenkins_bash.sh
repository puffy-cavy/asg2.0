#!/usr/bin/env bash

export PATH=/usr/local/bin:$PATH


echo ${STACK_NAME}
fullStackName=`aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text | grep -m 1 ${STACK_NAME}`
aws cloudformation list-stack-resources --stack-name $fullStackName --query 'StackResourceSummaries[*].{ResourceType: ResourceType,PhysicalId: PhysicalResourceId, Status: ResourceStatus, LastUpdated: LastUpdatedTimestamp}'
groupName=`aws cloudformation list-stack-resources --stack-name $fullStackName --query 'StackResourceSummaries[*].[ResourceType,PhysicalResourceId]' --output text | grep AWS::AutoScaling::AutoScalingGroup | awk '{print $2}'`
if [[ $groupName =~ " " ]] || [[ $groupName = "" ]]; then
	echo 'ABORTED: no match autoscaling group found'
	exit -1
fi

echo 'The details of the auto scaling group:'
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $groupName
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $groupName --min-size $MIN_SIZE --max-size $MAX_SIZE --desired-capacity $DESIRED_CAPACITY