BITNAMI_POSTGRES_RELEASE=13.2.24

.PHONY: gen-energy-platform-postgresql
gen-energy-platform-postgresql:
	docker run -ti --rm \
			--volume $${PWD}:/opt/manifests \
			--env BITNAMI_POSTGRES_RELEASE=${BITNAMI_POSTGRESQL_RELEASE} \
			--env NS="energy-platform" \
			--env NAME="postgresql" \
			--env WITH_BACKUP="true" \
			--env BACKUP_SCHEDULE="@daily" \
			--env OPSLEVEL_APP_DESCRIPTION="postgresql for energy platform" \
			--env OPSLEVEL_APP_TIER="tier_1" \
			--workdir=/opt/manifests \
			--entrypoint=/bin/sh \
			alpine/helm ./gen-yaml/gen.sh
