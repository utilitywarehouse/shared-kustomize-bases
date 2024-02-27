#!/bin/bash

set -o errexit -o pipefail -o nounset

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/redis
helm repo add bitnami https://charts.bitnami.com/bitnami

curDir="$(dirname "$0")"

helm template "redis" bitnami/redis --version "${BITNAMI_REDIS_RELEASE}" --namespace dev-enablement --values "$curDir"/values.yaml \
  > "manifests/redis.yaml"
