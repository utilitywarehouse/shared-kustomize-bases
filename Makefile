BITNAMI_REDIS_RELEASE=18.6.1

gen-redis-manifest:
	docker run -ti --rm \
		--volume $${PWD}/redis:/opt/manifests \
		--env BITNAMI_REDIS_RELEASE=${BITNAMI_REDIS_RELEASE} \
		--workdir=/opt/manifests \
		--entrypoint=./gen-yaml/gen.sh \
		alpine/helm
