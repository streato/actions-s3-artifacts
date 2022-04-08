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

if [ -z "$INPUT_FOLDER" ]; then
  INPUT_FOLDER=""
fi

if [ -z "$INPUT_S3_STORAGE_CLASS" ]; then
  INPUT_S3_STORAGE_CLASS="STANDARD"
fi

aws configure <<-EOF > /dev/null 2>&1
${INPUT_S3_ACCESS_KEY_ID}
${INPUT_S3_SECRET_ACCESS_KEY}
${INPUT_S3_REGION}
text
EOF

aws --endpoint-url=${INPUT_S3_ENDPOINT_URL} --storage-class=${INPUT_S3_STORAGE_CLASS} s3 cp ${INPUT_SOURCE_DIR} s3://${INPUT_S3_BUCKET} ${INPUT_FOLDER}

rm -r ~/.aws
