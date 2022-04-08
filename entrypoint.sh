#!/bin/sh

set -e

if [ -z "$INPUT_S3_BUCKET" ]; then
  echo "S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$INPUT_S3_ACCESS_KEY_ID" ]; then
  echo "S3_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$INPUT_S3_SECRET_ACCESS_KEY" ]; then
  echo "S3_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$INPUT_S3_REGION" ]; then
  echo "S3_REGION is not set. Quitting."
  exit 1
fi

if [ -z "$INPUT_S3_ENDPOINT_URL" ]; then
  echo "S3_ENDPOINT_URL is not set. Quitting."
  exit 1
fi

# Override default AWS endpoint if user sets S3_STORAGE_CLASS.
if [ -n "$INPUT_S3_STORAGE_CLASS" ]; then
  STORAGE_CLASS_APPEND="--storage-class $INPUT_S3_STORAGE_CLASS"
fi

aws configure set plugins.endpoint awscli_plugin_endpoint

aws configure <<-EOF > /dev/null 2>&1
${INPUT_S3_ACCESS_KEY_ID}
${INPUT_S3_SECRET_ACCESS_KEY}
${INPUT_S3_REGION}
text
EOF

rm ~/.aws/config

cat <<'EOF' >> ~/.aws/config
[plugins]
endpoint = awscli_plugin_endpoint
[default]
region = ${INPUT_S3_REGION}
s3 =
  endpoint_url = https://s3.fr-par.scw.cloud
  signature_version = s3v4
  max_concurrent_requests = 100
  max_queue_size = 1000
  multipart_threshold = 50MB
  # Edit the multipart_chunksize value according to the file sizes that you want to upload. The present configuration allows to upload files up to 10 GB (1000 requests * >
  multipart_chunksize = 10MB
s3api =
  endpoint_url = https://s3.fr-par.scw.cloud
EOF

aws --storage-class=GLACIER s3 cp ${INPUT_SOURCE_DIR} s3:// --recursive

rm -r ~/.aws
