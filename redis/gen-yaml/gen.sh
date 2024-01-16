#!/bin/bash

set -o errexit -o pipefail -o nounset

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/redis
helm repo add bitnami https://charts.bitnami.com/bitnami

helm template "redis" bitnami/redis --version "${BITNAMI_REDIS_RELEASE}" \
  --namespace 'change-me' \
  --set fullnameOverride="redis" \
  --set nameOverride="redis" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/redis" \
  --set auth.existingSecret="redis" \
  --set architecture=standalone \
  --set metrics.enabled="true" \
  --set master.disableCommands="" \
  --set master.resources.requests.cpu="500m" \
  --set master.resources.limits.cpu="1000m" \
  --set master.resources.requests.memory="1Gi" \
  --set master.resources.limits.memory="2Gi" \
  --set replica.resources.requests.cpu="500m" \
  --set replica.resources.limits.cpu="1000m" \
  --set replica.resources.requests.memory="1Gi" \
  --set replica.resources.limits.memory="2Gi" \
  > "manifests/redis.yaml"
