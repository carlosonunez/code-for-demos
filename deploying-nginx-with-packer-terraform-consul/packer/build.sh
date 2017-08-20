#!/bin/bash
# Builds this image using a Docker container (so that we don't have to
# install packer ourselves).
usage() {
  echo "./build.sh <vpc_id>"
  echo "Builds a Packer image in the environment specified."
}

template="${1:?Please provide the Packer template to build from.}"
vpc_to_provision_image_in="${2:?Please provide the VPC ID from which our temporary instance will be hosted.}"
subnet_to_provision_image_in="${3:?Please provide the subnet ID from which our temporary instance will be hosted.}"

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

docker run --volume "$PWD:/packer" \
  --workdir "/packer" \
  "hashicorp/packer" build -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
    -var "aws_region=$AWS_REGION" \
    -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
    -var "vpc_id=$vpc_to_provision_image_in" \
    -var "subnet_id=$subnet_to_provision_image_in" \
    "$template"
