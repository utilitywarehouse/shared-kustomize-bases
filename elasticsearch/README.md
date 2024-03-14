# Elasticsearch

## TL;DR

- [Is this Elasticsearch right for you?](#cluster-topology)
- [Example kustomization file deploying Elasticsearch](example)
- [Operations](#usage)
- [Grafana dashboards](#metrics)

## Source

This manifest is build on the base
of [Bitnami Elasticsearch Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch).

## Cluster topology

### Multipurpose nodes

This Elasticsearch manifest deploys cluster with multipurpose nodes.
This is the simplest topology, which is suitable for small clusters.

This means, all the nodes can be elected as master,
used for data storage and for operations.

### Nodes with dedicated roles

For bigger clusters, it is recommended to use dedicated master and data nodes,
optionally also ingest and coordinating nodes. Read more about node roles
in [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html).

Manifest with dedicated node roles can be generated the same way as multipurpose one, by providing
appropriate values to parameters like `data.replicaCount` in [gen.sh script](gen-yaml/gen.sh).

If you need cluster with dedicated node roles, please contact us at #help-dev-enablement,
we will be happy to help you add its manifest to the shared-kustomize-bases.

## Usage

### Scaling

In order to add nodes to cluster, first scale down to 0 replicas
in order to avoid inconsistencies in the configuration.

## Metrics

There are Grafana dashboards prepared for the ElasticSearch instances installed via shared kustomize base.
They can be found using the name "elasticsearch overview",
e.g. [for `dev-merit`](https://grafana.dev.merit.uw.systems/d/4yyL6dBMk/elasticsearch-overview?orgId=1).

## Backup

TODO
