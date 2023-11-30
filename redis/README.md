# Redis

## Source

This manifest is build on the base of [Bitnami Sentinel Redis Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/redis).

Before using those manifests, consider whether Sentinel is suitable for your use:

- [Redis Sentinel](https://redis.io/docs/management/sentinel/) allows using multiple databases in one instance,
however- it doesn't provide sharding. This means, nodes
other than master are just failover replicas. This grants high availability.

- [Redis cluster](https://github.com/bitnami/charts/tree/main/bitnami/redis-cluster)
(we don't have our manifests for it yet) is alternative to Sentinel- it allows just
one database in one instance, but grants sharding. This might limit the availability of redis,
but allows vertical scalling- great for huge datasets.

## Parameters

While writing the Makefile target to generate your customized Redis manifest, you'll stumble upon
following parameters:

```bash
NS="dev-enablement" # Your namespace
NAME="redis-shared" # Name of your Redis instance
OPSLEVEL_APP_DESCRIPTION="cache for opslevel-k8s-deployer" # Description of your Redis in OpsLevel
OPSLEVEL_APP_TIER="tier_4" # Tier of your Redis in OpsLevel- see https://wiki.uw.systems/posts/ops-level-nz4v4ka0#h1u0u-app-uw-systems-tier
REDIS_SECRET_NAME="redis" # Name of the secret with your Redis password. See secret created in directory `example`.
REDIS_REPLICA_COUNT=1 # Amount of failover replicas 
```
