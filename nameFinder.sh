#!/usr/bin/env bash

export PATH=/usr/local/bin:$PATH

STACK_LIST=($(aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text | grep -w ${ENV_NAME}.*${APP_NAME}.*cluster))
echo ${STACK_LIST[*]}

