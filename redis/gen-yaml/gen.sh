#!/bin/bash

set -o errexit -o pipefail -o nounset

mkdir -p manifests/${NS}/${NAME}/upstream

if [ "$USE_TLS" == "true" ]; then
  CONFIG="config/values-tls.yaml"
else
  CONFIG="config/values-non-tls.yaml"
fi

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/redis
helm repo add bitnami https://charts.bitnami.com/bitnami

helm template "${NAME}" bitnami/redis --version "${BITNAMI_REDIS_RELEASE}" \
  --set fullnameOverride="${NAME}" \
  --set nameOverride="${NAME}" \
  --set commonAnnotations."app\.uw\.systems\/description"="${OPSLEVEL_APP_DESCRIPTION}" \
  --set commonAnnotations."app\.uw\.systems\/tier"="${OPSLEVEL_APP_TIER}" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/redis" \
  --set auth.existingSecret="${REDIS_SECRET_NAME}" \
  --set replica.replicaCount="${REDIS_REPLICA_COUNT}" \
  --set master.resources.requests.cpu="500m" \
  --set master.resources.limits.cpu="1000m" \
  --set master.resources.requests.memory="1Gi" \
  --set master.resources.limits.memory="2Gi" \
  --set replica.resources.requests.cpu="500m" \
  --set replica.resources.limits.cpu="1000m" \
  --set replica.resources.requests.memory="1Gi" \
  --set replica.resources.limits.memory="2Gi" \
  --namespace "${NS}" > "manifests/${NS}"/"${NAME}"/upstream/redis.yaml \
  --values $CONFIG

cp gen-yaml/clean-upstream-kustomize-template.yaml manifests/"${NS}"/"${NAME}"/upstream/kustomization.yaml

if [ ! -f "${NS}"/"${NAME}"/kustomization.yaml ]; then
cp gen-yaml/namespace-kustomize-template.yaml manifests/"${NS}"/"${NAME}"/kustomization.yaml
fi
