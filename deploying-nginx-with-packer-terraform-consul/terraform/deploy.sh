#!/bin/bash

usage() {
  echo "./deploy.sh <environment_to_target> <aws_s3_tfstate_bucket> <terraform_action> [options]"
  echo
  echo "NOTE: [options] are the same as those provided by terraform."
}

download_and_compare_tfvars() {
  # Downloads terraform.tfvars from S3.
  # It also ensures that terraform.tfvars in S3 is authoritative using a
  # MD5 comparison.
  s3_bucket="$1"
  environment="$2"
  tfvars_to_find="s3://$s3_bucket/tfvars/$environment/terraform.tfvars"
  if ! aws s3 cp "$tfvars_to_find" "$PWD/terraform.tfvars.remote"
  then
    echo "ERROR: Couldn't retrieve terraform.tfvars from S3." >&2
    return 1
  fi

  if [ -f "terraform.tfvars" ]
  then
    remote_tfvars_md5_hash=$(md5sum "${PWD}"/terraform.tfvars.remote | awk '{print $1}')
    local_tfvars_md5_hash=$(md5sum "${PWD}"/terraform.tfvars | awk '{print $1}')
    if [ "$remote_tfvars_md5_hash" != "$local_tfvars_md5_hash" ]
    then
      rm "terraform.tfvars.remote"
      echo "ERROR: Your remote Terraform tfvars are out of date. Please update them." >&2
      return 1
    fi
    rm "terraform.tfvars"
  fi
  mv "terraform.tfvars.remote" "terraform.tfvars"
  return 0
}

_run_terraform_action() {
  # Runs Terraform in Docker with arguments.
    docker run --volume "$PWD:/terraform" \
      --workdir /terraform \
      --env AWS_ACCESS_KEY_ID \
      --env AWS_SECRET_ACCESS_KEY \
      --env AWS_REGION \
      "hashicorp/terraform" "$@"
}

environment_to_target="$1"
aws_s3_bucket="$2"
terraform_action="$3"
arguments_to_terraform_action="${4:---}"

if [ -z "$environment_to_target" ] ||
  [ -z "$aws_s3_bucket" ]
then
  usage
  echo "ERROR: You need an environment to target or S3 bucket." >&2
  exit 1
fi

if [ -z "$terraform_action" ]
then
  usage
  echo "ERROR: You need a Terraform action to give to Terraform." >&2
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

if ! download_and_compare_tfvars "$aws_s3_bucket" "$environment_to_target"
then
  exit 1
fi

# Always initialize our Terraform configuration before proceeding.
tfstate_key_name="tfstate/${environment_to_target}"
if ! _run_terraform_action "init" \
  -backend-config="bucket=$aws_s3_bucket" \
  -backend-config="key=${tfstate_key_name}" \
  -backend-config="region=${AWS_REGION}"
then
  # Error message will be shown above.
  exit 1
fi

if ! _run_terraform_action "get"
then
  # Error message will be shown above.
  exit 1
fi

case "$terraform_action" in
  plan|apply|destroy|refresh)
    _run_terraform_action "$terraform_action" -var "aws_s3_tfstate_bucket_name=$aws_s3_bucket" \
        -var "environment_name=$environment_to_target" \
        -var "aws_region=$AWS_REGION" \
        -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
        -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
        "$arguments_to_terraform_action"
        ;;
  *)
    _run_terraform_action "$terraform_action" "$arguments_to_terraform_action"
    ;;
esac

