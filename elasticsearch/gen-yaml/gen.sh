#!/bin/bash

set -o errexit -o pipefail -o nounset

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch
helm repo add bitnami https://charts.bitnami.com/bitnami

helm template "elasticsearch" bitnami/elasticsearch --version "${BITNAMI_ES_RELEASE}" \
  --set fullnameOverride="elasticsearch" \
  --set nameOverride="elasticsearch" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/elasticsearch" \
  --set auth.existingSecret="elasticsearch" \
  --set global.kibanaEnabled="true" \
  --set metrics.enabled="true" \
  --set master.persistence.size="10Gi" \
  --set master.resources.requests.cpu="500m" \
  --set master.resources.limits.cpu="1000m" \
  --set master.resources.requests.memory="1Gi" \
  --set master.resources.limits.memory="2Gi" \
  --set data.resources.requests.cpu="500m" \
  --set data.resources.limits.cpu="1000m" \
  --set data.resources.requests.memory="1Gi" \
  --set data.resources.limits.memory="2Gi" \
  > "manifests/elasticsearch.yaml"
