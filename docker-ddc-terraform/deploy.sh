#!/bin/bash

usage() {
  echo "./infra (plan|apply) [terraform_options]"
  echo "Runs a Terraform plan or deployment while fetching the latest terraform.tfvars."
  echo "**NOTE**: S3_INFRASTRUCTURE_BUCKET must be defined for your environment. \
Set it to the location of the terraform.tfvars file in S3."
  echo "**NOTE**: awscli must be installed. Install it with \"pip install awscli\"."
}

our_current_ip=$(curl -Ls http://canihazip.com/s | cut -f1 -d, | tr -d ' ')
our_current_region=$AWS_REGION

if [ "$1" != "plan" ] && [ "$1" != "apply" ]
then
  echo "ERROR: You can only run 'plan' or 'apply' with this script."
  echo "Use 'terraform' for any other Terraform subcommands"
  usage
  return 1
elif [ "$1" == "help" ]
then
  usage
  return 0
fi

if [ "$S3_INFRASTRUCTURE_BUCKET" == "" ]
then
  echo "ERROR: You must define S3_INFRASTRUCTURE_BUCKET before running this script."
  usage
  return 1
fi

if [ "$(which aws)" == "" ]
then
  echo "ERROR: awscli must be installed for this script to work."
  usage
  return 1
fi

if [ 
