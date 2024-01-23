#!/bin/bash

set -o errexit -o pipefail -o nounset

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch
helm repo add bitnami https://charts.bitnami.com/bitnami

curDir="$(dirname "$0")"

helm template "elasticsearch" bitnami/elasticsearch --version "${BITNAMI_ES_RELEASE}"  --values "$curDir"/values.yaml \
  >"manifests/elasticsearch.yaml"
