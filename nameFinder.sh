#!/usr/bin/env bash

export PATH=/usr/local/bin:$PATH

aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text | grep -w ${ENV_NAME}.*${APP_NAME}.*cluster
