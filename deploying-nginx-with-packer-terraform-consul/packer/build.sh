# Builds this image using a Docker container (so that we don't have to
# install packer ourselves).

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
    -var "region=$AWS_REGION" \
    -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
    "centos_7_x86-64.json"
