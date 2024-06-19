# redis cluster base manifests

This directory contains a redis base for setting up a redis cluster that is highly available and horizontally scales.
It will spin up a [redis cluster](https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/) with a number of
replicas allowing for nodes to rotate with no downtime. 

### Getting started
The simplest way to create a redis cluster is to reference the base in a kustomization file. 
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- ../base
```

This will create a redis cluster that uses the default names and values. 
- Nodes will be called `redis-x`
- Redis is configured for persistence using `appendonly yes` this appends every record to the disk, making it fully durable.
- Redis by default will not have a password, if you would like to set a password please overwrite the empty secret.

kustomization.yaml
```yaml
secretGenerator:
  - name: redis-password
    envs:
      - secrets/password
    behavior: replace
```
secrets/password
```
REDIS_PASSWORD=foobar
```

**Customising the base**
If you would like to customise the base you can do this by updating the two configs in the base. For example if you would
like to append a prefix to the names you can using the following example that:
- Prefixes name with `foo`
- Increases redis master replicas to 2.
- Changes config to be memory only.

kustomization.yaml
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../base

commonLabels:
  app: foo-redis

namePrefix: foo-

configMapGenerator:
  - name: redis-env
    envs:
      - config/redis-env
    behavior: replace
  - name: redis-config
    files:
      - config/redis.conf
    behavior: replace

replicas:
  - name: redis
    count: 9
```

redis.conf
```
dir /data

cluster-enabled yes
cluster-require-full-coverage no
cluster-node-timeout 15000
cluster-config-file /data/nodes.conf
cluster-migration-barrier 1
appendonly no
save ""
```

redis-env
```yaml
REDIS_NODE_NAME=foo-redis
REDIS_HEADLESS_SERVICE=foo-redis
NODE_REPLICA_COUNT=9
REDIS_REPLICA_COUNT=2
REDIS_PORT=6379
```


### How it works

**Cluster Initialization**
The cluster is initialised using a kubernetes job. The job runs by pinging each node until it is ready, once ready 
it runs using redis-trib cli which creates a cluster using hostnames and configures the number of replicas.
If you need to recreate the Redis config you will have to delete the job before applying.

**Notes**
- The `podManagementPolicy` is `Parallel` so all nodes start at the same time and their IP addresses become available.  
- The cluster is configured to use hostnames for communication, this is done in the start-node script.

**Node Shutdown**
When a node is shutdown gracefully for instance in statefulset roll it uses a PreStop hook to check if it is configured as
a master. If it is a master then it first failsover to the first replica before shutting down. 

**Readiness**
The readiness probe only goes ready if both the local redis node is responsive and if the cluster is healthy. 

### Notes:
- Scaling up after initial setup will not affect the cluster but the new nodes will not join automatically. 
- Scaling down could cause the cluster to fail if the keyset is not covered by the remaining nodes. 

### Future work:
- allow for scaling after initial setup
