#!/usr/bin/env bash

export PATH=/usr/local/bin:$PATH

# outputStacks=`aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text | grep -w ${ENV_NAME}.*${APP_NAME}.*cluster`
# STACK_LIST=($(aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text | grep -w ${ENV_NAME}.*cluster))
echo ($(aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text | grep -w ${ENV_NAME}.*cluster))

