#!/usr/bin/env bash

# Download Consul.
if ! curl -L \
  -o /tmp/consul.zip \
  https://releases.hashicorp.com/consul/0.9.2/consul_0.9.2_linux_amd64.zip
then
  echo "ERROR: Couldn't download Consul." >&2
  exit 1
fi
sudo unzip -d /usr/local/bin /tmp/consul.zip

# Verify that Consul was extracted and installed.
consul

# Delete our temp zip file.
rm /tmp/consul.zip
