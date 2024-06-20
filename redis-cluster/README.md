# Redis Cluster

## TL;DR

- [Is this Redis right for you?](#flavour)
- [Example kustomization file deploying Redis](example)
- [Test it manually using redis-cli](#usage)
- [Grafana dashboards](#metrics)

## Source

This manifest is basing on multiple different manifests found over the internet.

## Flavour

This manifest is for clustered Redis.
This repository also contains the [manifest for standalone Redis](../redis)

Before using those manifests, consider whether clustered is suitable for your use.
There are following alternatives:

|                                                             | High availability                                            | Mulitple databases | Sharding | Amount of nodes        | Remarks                               |
|-------------------------------------------------------------|--------------------------------------------------------------|--------------------|----------|------------------------|---------------------------------------|
| Standalone                                                  | No                                                           | Yes                | No       | 1                      |                                       |
| [Replicated](https://redis.io/docs/management/replication/) | No (replica nodes are used e.g. to optimize read operations) | Yes                | No       | 1 master, n replicas   |                                       |
| [Sentinel](https://redis.io/docs/management/sentinel/)      | Yes (master election in case of failure)                     | Yes                | No       | 3+                     | Needs special handling on client side |
| [Cluster](https://redis.io/docs/management/scaling/)        | Yes (master election in case of failure)                     | No                 | Yes      | 3+ masters, n replicas | Needs special handling on client side |


If you are interested in using another flavour, let us know!
We can help you to set it up.

## Manifest details

- Redis is configured for persistence using `appendonly yes` this appends every record to the disk, making it fully
  durable.
- Redis by default will not have a password, if you would like to set a password please overwrite the empty secret.

## Usage

### Access Redis from console

In order to manually access the database (without locally installing redis-cli):

```bash
kubectl exec --tty --stdin=true  svc/redis-master -- redis-cli -u redis://localhost:6379 -a "password" 
```

For example, to get the list of all the keys, run

```redis
KEYS *
```

### Persistence

There are two persistence strategies available:

- Redis Database (RDB) - configured by `save` parameter in redis.conf file
- Append Only File (AOF) - configured by `appendonly` paremeter in redis.conf file.

Detailed difference between them together with recommended persistence strategy can be found in
[official redis docs](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/).

**Example kustomize file has no persistence options configured**

### Scaling

- Scaling up after initial setup will not affect the cluster but the new nodes will not join automatically.
- Scaling down could cause the cluster to fail if the keyset is not covered by the remaining nodes.

Currently, scaling after initial setup is impossible- you can contribute to change that!

### Lifecycle

#### Cluster Initialization

The cluster is initialised using a kubernetes job. The job runs by pinging each node until it is ready, once ready
it runs using redis-trib cli which creates a cluster using hostnames and configures the number of replicas.
If you need to recreate the Redis config you will have to delete the job before applying.

**Notes**

- The `podManagementPolicy` is `Parallel` so all nodes start at the same time and their IP addresses become available.
- The cluster is configured to use hostnames for communication, this is done in the start-node script.

#### Node Shutdown

When a node is shutdown gracefully for instance in statefulset roll it uses a PreStop hook to check if it is configured
as a master. If it is a master then it first failsover to the first replica before shutting down.

#### Readiness

The readiness probe only goes ready if both the local redis node is responsive and if the cluster is healthy.

### Metrics

There are Grafana dashboards prepared for the Redis.
They can be found using the name "redis overview",
e.g. [for `prod-aws`](https://grafana.prod.aws.uw.systems/goto/8N_RY8OSg?orgId=1).

### Backup/ migration

Sadly, we don't have the automatic backup functionality yet -
we would be the happiest if you would wish to contribute!
