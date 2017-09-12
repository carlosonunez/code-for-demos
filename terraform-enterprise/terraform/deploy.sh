#!/bin/bash

usage() {
  echo "./deploy.sh <environment_to_target> <terraform_action> [options]"
  echo "Manage Terraform and perform Terraform Enterprise runs."
  echo
  echo "NOTE: [options] are the same as those provided by terraform."
}

_run_terraform_action() {
  # Runs Terraform in Docker with arguments.
    docker run --attach STDIN \
      --attach STDOUT \
      --attach STDERR \
      --volume "$PWD:/terraform" \
      --volume "$HOME/.ssh:/root/.ssh" \
      --workdir /terraform \
      --env ATLAS_TOKEN \
      "hashicorp/terraform" "$@"
}

environment_to_target="$1"
terraform_action="$2"
arguments_to_terraform_action="${3:---}"

if [ -z "$ATLAS_TOKEN" ]
then
  usage
  echo "ERROR: You'll need to define ATLAS_TOKEN before proceeding." >&2
  exit 1
fi

if [ -z "$environment_to_target" ]
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

# Always initialize our Terraform configuration before proceeding.
tfstate_key_name="tfstate/${environment_to_target}"
if ! _run_terraform_action "init" \
  -backend-config="access_token=$ATLAS_TOKEN" > /dev/null
then
  # Error message will be shown above.
  exit 1
fi

if ! _run_terraform_action "get" > /dev/null
then
  # Error message will be shown above.
  exit 1
fi

case "$terraform_action" in
  apply|destroy)
    echo "ERROR: The '$terraform_action' action is not supported by this script. \
To execute a run, use 'push' instead." >&2
    exit 1
    ;;
  plan|refresh|push)
    _run_terraform_action "$terraform_action" \
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

