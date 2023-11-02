BITNAMI_REDIS_RELEASE=18.1.6
VALUES_TLS="config/values-tls.yaml"
VALUES_NON_TLS="config/values-non-tls.yaml"

.PHONY: gen-dev-enablement-redis-shared
gen-dev-enablement-redis-shared:
	docker run -ti --rm \
  -v $${PWD}:/opt/manifests \
  -e BITNAMI_REDIS_RELEASE=${BITNAMI_REDIS_RELEASE} \
  -e NS="dev-enablement" \
  -e NAME="redis-shared" \
  --workdir=/opt/manifests \
  --entrypoint=/bin/sh \
  alpine/helm ./gen-yaml/gen
