#!/bin/bash
# Builds this image using a Docker container (so that we don't have to
# install packer ourselves).
usage() {
  echo "./build.sh <environment_to_target>"
  echo "Builds a Packer image in the environment specified."
}

locate_vpc_by_environment() {
  # Uses awscli to find a VPC in a given environment.
  environment="$1"
  vpcs_found=$( aws ec2 describe-vpcs \
    --filter "Name=tag:Environment,Values=$environment" | \
    jq '.Vpcs[].VpcId' | \
    tr -d '"' | \
    awk 'NF'
  )
  number_of_vpcs_found=$(echo "$vpcs_found" | wc -l | tr -d ' ')
  if [ "$number_of_vpcs_found" -gt 1 ]
  then
    echo "ERROR: Environment is ambiguous: ${environment}." >&2
    echo ""
  else
    echo "$vpcs_found"
  fi
}

environment_to_target="$1"
if [ -z "$environment_to_target" ]
then
  usage
  echo "ERROR: Please provide the environment to target." >&2
  exit 1
fi

if [ -z "$AWS_REGION" ] ||
  [ -z "$AWS_ACCESS_KEY_ID" ] ||
  [ -z "$AWS_SECRET_ACCESS_KEY" ]
then
  echo "ERROR: Ensure that AWS_REGION, AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY \
are set before running this script." >&2
  echo "ERROR: What we found:" >&2
  export | grep AWS >&2
  exit 1
fi

vpc_to_provision_image_in=$(locate_vpc_by_environment "$environment_to_target")
if [ -z "$vpc_to_provision_image_in" ]
then
  echo "ERROR: VPC matching environment [$environment_to_target] not found." >&2
  exit 1
fi

docker run --volume "$PWD:/packer" \
  --workdir "/packer" \
  "hashicorp/packer" build -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
    -var "aws_region=$AWS_REGION" \
    -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
    -var "vpc_id=$vpc_to_provision_image_in" \
    -var "environment=$environment_to_target" \
    "centos_7_x86-64.json"
