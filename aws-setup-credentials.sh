#!/usr/bin/env bash

pip install json
echo echo "============================================================================="
echo " Setting up credentials with profile: ${Profile} . ."
echo echo "============================================================================="

### SET PROFILE FOR TARGET ROLE ###
if [ "${ENV}" != "local" ] ; then
    mkdir -p ${PWD}/aws/config/
    touch ${PWD}/aws/config/config_file
    AWS_CONFIG_FILE=${PWD}/aws/config/config_file
    export AWS_CONFIG_FILE
    echo "Running setup-work-role-credentials.py ${Profile}"
    python setup-work-role-credentials.py ${Profile}
fi