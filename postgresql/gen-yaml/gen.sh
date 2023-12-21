
#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

mkdir -p manifests/upstream

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami

helm template "${NAME}" bitnami/postgresql --version "${BITNAMI_POSTGRES_RELEASE}" \
  --set fullnameOverride="${NAME}" \
  --set nameOverride="${NAME}" \
  --set commonAnnotations."app\.uw\.systems\/description"="" \
  --set commonAnnotations."app\.uw\.systems\/tier"="" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/postgresql" \
  --set master.resources.requests.cpu="0" \
  --set master.resources.limits.cpu="1000m" \
  --set master.resources.requests.memory="0" \
  --set master.resources.limits.memory="1Gi" \
  --set backup.enabled="false" > "manifests/upstream/postgres.yaml"
