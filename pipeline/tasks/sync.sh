#!/bin/bash

set -e

mkdir out

# Run `helm init` before using any helm commands.
# https://github.com/kubernetes/helm/issues/1732#issuecomment-268093699
helm init --client-only

# Create all the helm packages
pushd ci/stable > /dev/null
for dir in *
do
  helm dep update $dir
  helm package $dir -d ../../out/
done
popd > /dev/null

# Get the old index yaml from S3
aws s3 cp s3://$BUCKET/index.yaml index.yaml --region eu-central-1

# Update the index
helm repo index --url https://kubernetes-charts.suse.com/ --merge index.yaml out

# Ensure s3 urls are properly escaped
cat out/index.yaml | awk '{ if (/^\s+- https/) { gsub(/\+/,"%2B"); print } else print }' > index.yaml.escaped
mv index.yaml.escaped out/index.yaml

# Now sync everything on AWS S3.
# IMPORTANT: When making changes to this script, make sure you use the --dryrun
# flag on this command before you actually let it write stuff on S3.
aws s3 sync out/ s3://$BUCKET/ --region eu-central-1
