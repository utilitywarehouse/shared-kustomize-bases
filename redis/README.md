# Redis

## Source

This manifest is build on the base of Bitnami Sentinel Redis Helm chart.

[Redis Sentinel](https://redis.io/docs/management/sentinel/) allows using multiple databases in one instance,
however- it doesn't provide sharding. This means, nodes
other than master are just failover replicas. This grants high availability.

[Redis cluster](https://github.com/bitnami/charts/tree/main/bitnami/redis-cluster) 
(we don't have our manifests for it yet) is alternative to Sentinel- it allows just
one database in one instance, but grants sharding. This might limit the availability of redis,
but allows vertical scalling- great for huge datasets.
