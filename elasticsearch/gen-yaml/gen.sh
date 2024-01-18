#!/bin/bash

set -o errexit -o pipefail -o nounset

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch
helm repo add bitnami https://charts.bitnami.com/bitnami


echo "generate master-only ES manifest"
helm template "elasticsearch" bitnami/elasticsearch --version "${BITNAMI_ES_RELEASE}" \
  --set fullnameOverride="elasticsearch" \
  --set nameOverride="elasticsearch" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/elasticsearch" \
  --set auth.existingSecret="elasticsearch" \
  --set global.kibanaEnabled="true" \
  --set metrics.enabled="true" \
  --set master.replicaCount="1" \
  --set master.masterOnly="true" \
  --set data.replicaCount="0" \
  --set coordinating.replicaCount="0" \
  --set ingest.replicaCount="0" \
  > "manifests/masterOnly/elasticsearch.yaml"

echo "generate ES manifest with specialized node roles"
helm template "elasticsearch" bitnami/elasticsearch --version "${BITNAMI_ES_RELEASE}" \
  --set fullnameOverride="elasticsearch" \
  --set nameOverride="elasticsearch" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/elasticsearch" \
  --set auth.existingSecret="elasticsearch" \
  --set global.kibanaEnabled="true" \
  --set metrics.enabled="true" \
  --set master.replicaCount="1" \
  --set data.replicaCount="1" \
  --set coordinating.replicaCount="1" \
  --set ingest.replicaCount="1" \
  > "manifests/roles/elasticsearch.yaml"
