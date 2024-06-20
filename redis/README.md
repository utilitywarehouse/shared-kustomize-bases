# Redis

## TL;DR

- [Is this Redis right for you?](#flavour)
- [Example kustomization file deploying Redis](example)
- [Test it manually using redis-cli](#usage)
- [Grafana dashboards](#metrics)

## Source

This manifest is build on the base
of [Bitnami Redis Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/redis).

## Flavour

This manifest is for standalone Redis.
This repository also contains the [manifest for Redis cluster](../redis-cluster)

Before using those manifests, consider whether standalone is suitable for your use.
There are following alternatives:

|                                                             | High availability                                            | Mulitple databases | Sharding | Amount of nodes        | Remarks                               |
|-------------------------------------------------------------|--------------------------------------------------------------|--------------------|----------|------------------------|---------------------------------------|
| Standalone                                                  | No                                                           | Yes                | No       | 1                      |                                       |
| [Replicated](https://redis.io/docs/management/replication/) | No (replica nodes are used e.g. to optimize read operations) | Yes                | No       | 1 master, n replicas   |                                       |
| [Sentinel](https://redis.io/docs/management/sentinel/)      | Yes (master election in case of failure)                     | Yes                | No       | 3+                     | Needs special handling on client side |
| [Cluster](https://redis.io/docs/management/scaling/)        | Yes (master election in case of failure)                     | No                 | Yes      | 3+ masters, n replicas | Needs special handling on client side |

If you are interested in using another flavour, let us know!
We can help you to set it up.

## Usage

In order to manually access the database (without locally installing redis-cli):

```bash
kubectl exec --tty --stdin=true  svc/redis-master -- redis-cli -u redis://localhost:6379 -a "password" 
```

For example, to get the list of all the keys, run

```redis
KEYS *
```

## Metrics

There are Grafana dashboards prepared for the Redis.
They can be found using the name "redis overview",
e.g. [for `prod-aws`](https://grafana.prod.aws.uw.systems/goto/8N_RY8OSg?orgId=1).

## Backup/ migration

Sadly, we don't have the automatic backup functionality yet -
we would be the happiest if you would wish to contribute!

There is,
however, [manual way to create backups and restore them](https://docs.bitnami.com/kubernetes/infrastructure/redis/administration/backup-restore/),
which can also be used to migrate database instances.
