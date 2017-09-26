#!/bin/bash

usage() {
  error_message="${@:1}"
  cat <<EOF
USAGE: lint.sh [-h|--help] <playbooks-path>
Lints Ansible playbooks with Docker.

  -h, --help:       Show this usage information.
  <playbooks-path>: The path to your playbooks (default: ansible-playbooks)
EOF
  if [ ! -z "$error_message" ]
  then
    echo "ERROR: $error_message" >&2
    exit 1
  fi
  return 0
}

show_help="$(echo "$@" | grep -Eq "\-h|\-\-help"; echo $?)"
if [ "$show_help" -eq 0 ]
then
  usage
  exit 0
fi

directory_to_lint="$(echo "${@:1}" | sed 's#\(-h\|--help\)##')"
if [ -z "$directory_to_lint" ]
then
  echo "INFO: No directory detected; using default"
  directory_to_lint="ansible_playbooks"
fi

docker build -t ansible-lint -f ansible-lint.dockerfile .
docker run --rm -v "$directory_to_lint:/src" ansible-lint
