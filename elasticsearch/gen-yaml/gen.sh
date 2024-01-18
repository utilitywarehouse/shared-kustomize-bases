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
  --set master.replicaCount="3" \
  --set master.masterOnly="false" \
  --set data.replicaCount="0" \
  --set coordinating.replicaCount="0" \
  --set ingest.replicaCount="0" \
  --set master.resources.requests.cpu="250m" \
  --set master.resources.limits.cpu="2000m" \
  --set master.resources.requests.memory="4Gi" \
  --set master.resources.limits.memory="8Gi" \
  > "manifests/elasticsearch.yaml"
