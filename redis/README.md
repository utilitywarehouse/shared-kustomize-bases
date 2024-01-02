# Redis

## TL;DR
- [Is this Redis right for you?](#flavour)
- [How to install](../README.md#how)
- [Install parameters](#parameters)
- [Example kustomization file deploying Redis](example)
- [Test it manually using redis-cli](#usage)
- [Grafana dashboards](#metrics)

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
In order to manually access the database (without locally installing redis-cli):
```bash
kubectl exec --tty --stdin=true  svc/redis-shared-master -- redis-cli -u redis://localhost:6379 -a "password" 
```
For example, to get the list of all the keys, run
```redis
KEYS *
```

## Metrics
There are Grafana dashboards prepared for the Redis instances installed via shared kustomize base.
They can be found using the name "redis overview", e.g. [for `prod-aws`](https://grafana.prod.aws.uw.systems/goto/8N_RY8OSg?orgId=1).


## Backup/ migration
Sadly, we don't have the automatic backup functionality yet -
we would be the happiest if you would wish to contribute!

There is, however, [manual way to create backups and restore them](https://docs.bitnami.com/kubernetes/infrastructure/redis/administration/backup-restore/)
, which can also be used to migrate database instances.
