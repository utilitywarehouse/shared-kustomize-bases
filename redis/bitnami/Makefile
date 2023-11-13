BITNAMI_REDIS_RELEASE=18.1.6

.PHONY: gen-dev-enablement-redis-shared
gen-dev-enablement-redis-shared:
	docker run -ti --rm \
  -v $${PWD}:/opt/manifests \
  -e BITNAMI_REDIS_RELEASE=${BITNAMI_REDIS_RELEASE} \
  -e NS="dev-enablement" \
  -e NAME="redis-shared" \
  -e REDIS_SECRET_NAME="redis" \
  -e MASTER_CPU_LIMIT="1000m" \
  -e MASTER_CPU_REQUEST="500m" \
  -e MASTER_MEMORY_LIMIT="5Gi" \
  -e MASTER_MEMORY_REQUEST="2Gi" \
  -e REPLICA_CPU_LIMIT="1000m" \
  -e REPLICA_CPU_REQUEST="500m" \
  -e REPLICA_MEMORY_LIMIT="5Gi" \
  -e REPLICA_MEMORY_REQUEST="2Gi" \
  --workdir=/opt/manifests \
  --entrypoint=/bin/sh \
  alpine/helm ./gen-yaml/gen
