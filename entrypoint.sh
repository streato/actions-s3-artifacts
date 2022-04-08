#!/bin/sh

set -e

aws configure set plugins.endpoint awscli_plugin_endpoint

aws configure <<-EOF > /dev/null 2>&1
SCWBBWNPAD48GCCVTW66
8e2a0f85-0f44-45ee-92b4-0ea9dd2dc170
fr-par
text
EOF

rm .aws/config

cat <<'EOF' >> ~/.aws/config
[plugins]
endpoint = awscli_plugin_endpoint
[default]
region = fr-par
s3 =
  endpoint_url = https://streato.s3.fr-par.scw.cloud
  signature_version = s3v4
  max_concurrent_requests = 100
  max_queue_size = 1000
  multipart_threshold = 50MB
  # Edit the multipart_chunksize value according to the file sizes that you want to upload. The present configuration allows to upload files up to 10 GB (1000 requests * >
  multipart_chunksize = 10MB
s3api =
  endpoint_url = https://streato.s3.fr-par.scw.cloud
EOF

aws --storage-class=GLACIER s3 cp public/logo.png s3://test

rm -r .aws
