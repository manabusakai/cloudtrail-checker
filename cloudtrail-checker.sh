#!/bin/bash

regions=()
regions[0]="ap-northeast-1"
regions[1]="ap-southeast-1"
regions[2]="ap-southeast-2"
regions[3]="eu-central-1"
regions[4]="eu-west-1"
regions[5]="sa-east-1"
regions[6]="us-east-1"
regions[7]="us-west-1"
regions[8]="us-west-2"

for region in "${regions[@]}"; do
    common_command="aws cloudtrail --region ${region} --output text"

    trail_name=$(${common_command} describe-trails --query "trailList[].Name")
    if [ -z "${trail_name}" ]; then
        echo "${region}: CloudTrail is disabled."
        continue
    fi

    is_logging=$(${common_command} get-trail-status --name ${trail_name} --query "IsLogging")
    if [ "${is_logging}" != "True" ]; then
        echo "${region}: CloudTrail is enabled, but logging is turned off."
        continue
    fi

    echo "${region}: OK"
done
