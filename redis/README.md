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
MASTER_CPU_LIMIT="1000m" # master node k8s CPU limit
MASTER_CPU_REQUEST="500m" # master node k8s CPU request 
MASTER_MEMORY_LIMIT="5Gi" # master node k8s memory limit 
MASTER_MEMORY_REQUEST="2Gi" # master node k8s memory request 
REPLICA_CPU_LIMIT="1000m" # replica node k8s CPU limit
REPLICA_CPU_REQUEST="500m" # replica node k8s CPU request 
REPLICA_MEMORY_LIMIT="5Gi" # replica node k8s memory limit 
REPLICA_MEMORY_REQUEST="2Gi" # replica node k8s memory request 
```
