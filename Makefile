BITNAMI_REDIS_RELEASE=18.1.6
BITNAMI_ES_RELEASE=19.16.1

gen-redis-manifest:
	docker run -ti --rm \
		--volume $${PWD}/redis:/opt/manifests \
		--env BITNAMI_REDIS_RELEASE=${BITNAMI_REDIS_RELEASE} \
		--workdir=/opt/manifests \
		--entrypoint=./gen-yaml/gen.sh \
		alpine/helm

gen-es-manifest:
	docker run -ti --rm \
		--volume $${PWD}/elasticsearch:/opt/manifests \
		--env BITNAMI_ES_RELEASE=${BITNAMI_ES_RELEASE} \
		--workdir=/opt/manifests \
		--entrypoint=./gen-yaml/gen.sh \
		alpine/helm
