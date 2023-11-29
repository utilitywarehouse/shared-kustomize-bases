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
		--env REDIS_REPLICA_COUNT=1 \
		--workdir=/opt/manifests \
		--entrypoint=/bin/sh \
		alpine/helm ./gen-yaml/gen.sh
