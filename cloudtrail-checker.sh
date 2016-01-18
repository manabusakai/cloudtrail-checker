#!/bin/bash

regions=(
    "ap-northeast-1"
    "ap-northeast-2"
    "ap-southeast-1"
    "ap-southeast-2"
    "eu-central-1"
    "eu-west-1"
    "sa-east-1"
    "us-east-1"
    "us-west-1"
    "us-west-2"
)

common_command="aws cloudtrail --output text"

is_multi_region=$(${common_command} describe-trails --query "trailList[].IsMultiRegionTrail")
if [ "${is_multi_region}" == "True" ]; then
    echo "Multi Region: OK"
    exit 0
fi

for region in "${regions[@]}"; do
    trail_name=$(${common_command} describe-trails --region ${region} --query "trailList[].Name")
    if [ -z "${trail_name}" ]; then
        echo "${region}: CloudTrail is disabled."
        continue
    fi

    is_logging=$(${common_command} get-trail-status --region ${region} --name ${trail_name} --query "IsLogging")
    if [ "${is_logging}" != "True" ]; then
        echo "${region}: CloudTrail is enabled, but logging is turned off."
        continue
    fi

    echo "${region}: OK"
done
