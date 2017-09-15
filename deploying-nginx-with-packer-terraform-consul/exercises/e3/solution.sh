#!/usr/bin/env bash

# Download Terraform.
if ! curl -L \
  -o /tmp/terraform.zip \
  https://releases.hashicorp.com/terraform/0.9.2/terraform_0.10.0_linux_amd64.zip
then
  echo "ERROR: Couldn't download Terraform." >&2
  exit 1
fi
sudo unzip -d /usr/local/bin /tmp/terraform.zip

# Verify that Terraform was extracted and installed.
terraform

# Delete our temp zip file.
rm /tmp/terraform.zip
