# Redis

## TL;DR
- [Is this Redis right for you?](#flavour)
- [How to install](../README.md#how)
- [Install parameters](#parameters)
- [Example kustomization file deploying Redis](example)
- [Test it manually using redis-cli](#usage)

## Source

This manifest is build on the base of [Bitnami Sentinel Redis Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/redis).

## Flavour
Before using those manifests, consider whether Sentinel is suitable for your use:

- [Redis Sentinel](https://redis.io/docs/management/sentinel/) allows using multiple databases in one instance,
however- it doesn't provide sharding. It is possible to add additional nodes, however, nodes other than master are just read-only replicas.
[It is possible to grant high availability by enabling Sentinel failover](https://github.com/bitnami/charts/tree/main/bitnami/redis#master-replicas-with-sentinel)- in this case, master failure would cause 
election of the new master from replica nodes. However, this would demand client library querying the master address.
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
REDIS_REPLICA_COUNT=1 # Amount of read-only replicas 
```

## Usage
In order to manually access the database:
1. [Install redis-cli](https://redis.io/docs/install/install-redis/) (it comes together with server installation)
2. port-forward to Redis service running in the cluster:
    ```bash
    kubectl port-forward svc/redis-shared-master 6379
    ```
3. Connect redis-cli to service:
    ```bash
    redis-cli -u redis://localhost:6379 -a "password" 
    ```
4. Use Redis console. For example, to get the list of all the keys, run
    ```redis
    KEYS *
    ```
