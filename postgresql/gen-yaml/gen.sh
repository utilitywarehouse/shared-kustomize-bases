
#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

mkdir -p manifests/upstream
rm manifests/upstream/*

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami

helm template "postgres" bitnami/postgresql --version "${BITNAMI_POSTGRES_RELEASE}" \
  --set fullnameOverride="postgres" \
  --set nameOverride="postgres" \
  --set commonAnnotations."app\.uw\.systems\/description"="" \
  --set commonAnnotations."app\.uw\.systems\/tier"="" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/postgresql" \
  --set master.resources.requests.cpu="0" \
  --set master.resources.limits.cpu="1000m" \
  --set master.resources.requests.memory="0" \
  --set master.resources.limits.memory="1Gi" \
  --set backup.enabled="false" > manifests/upstream/postgres.yaml

cp gen-yaml/kustomization.yaml manifests/upstream/kustomization.yaml
cp gen-yaml/delete-secret.yaml manifests/upstream/delete-secret.yaml
