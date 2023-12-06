#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

mkdir -p manifests/${NS}/${NAME}/upstream

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami

helm template "${NAME}" bitnami/postgresql --version "${BITNAMI_POSTGRES_RELEASE}" \
  --set fullnameOverride="${NAME}" \
  --set nameOverride="${NAME}" \
  --set commonAnnotations."app\.uw\.systems\/description"="${OPSLEVEL_APP_DESCRIPTION}" \
  --set commonAnnotations."app\.uw\.systems\/tier"="${OPSLEVEL_APP_TIER}" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/postgresql" \
  --set master.resources.requests.cpu="500m" \
  --set master.resources.limits.cpu="1000m" \
  --set master.resources.requests.memory="1Gi" \
  --set master.resources.limits.memory="2Gi" \
  --set replica.resources.requests.cpu="500m" \
  --set replica.resources.limits.cpu="1000m" \
  --set replica.resources.requests.memory="1Gi" \
  --set replica.resources.limits.memory="2Gi" \
  --set backup.enabled="${WITH_BACKUP}" \
  --namespace "${NS}"  > "manifests/${NS}"/"${NAME}"/upstream/postgres.yaml
