BITNAMI_REDIS_RELEASE=18.1.6



.PHONY: gen-dev-enablement-redis-shared
gen-dev-enablement-redis-shared:
	docker run -ti --rm \
		--volume $${PWD}:/opt/manifests \
		--env BITNAMI_REDIS_RELEASE=${BITNAMI_REDIS_RELEASE} \
		--env NS="dev-enablement" \
		--env NAME="redis-shared" \
		--env OPSLEVEL_APP_DESCRIPTION="cache for opslevel-k8s-deployer" \
		--env OPSLEVEL_APP_TIER="tier_4" \
		--env REDIS_SECRET_NAME="redis" \
		--env MASTER_CPU_LIMIT="1000m" \
		--env MASTER_CPU_REQUEST="500m" \
		--env MASTER_MEMORY_LIMIT="5Gi" \
		--env MASTER_MEMORY_REQUEST="2Gi" \
		--env REPLICA_CPU_LIMIT="1000m" \
		--env REPLICA_CPU_REQUEST="500m" \
		--env REPLICA_MEMORY_LIMIT="5Gi" \
		--env REPLICA_MEMORY_REQUEST="2Gi" \
		--workdir=/opt/manifests \
		--entrypoint=/bin/sh \
		alpine/helm ./gen-yaml/gen
