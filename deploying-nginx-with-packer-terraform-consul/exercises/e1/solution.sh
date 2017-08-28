#!/usr/bin/env bash

# Download Packer.
if ! curl -L \
  -o /tmp/packer.zip \
  https://releases.hashicorp.com/packer/0.9.2/packer_0.9.2_linux_amd64.zip
then
  echo "ERROR: Couldn't download Packer." >&2
  exit 1
fi
sudo unzip -d /usr/local/bin /tmp/packer.zip

# Verify that Packer was extracted and installed.
packer

# Delete our temp zip file.
rm /tmp/packer.zip
