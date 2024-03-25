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

ElasticSearch comes with an option to backup the data to S3 bucket.
In order to enable it, you need to:

- have an S3 bucket together with user that has access to it,
- provide the bucket user credentials to ElasticSearch keystore, and
- configure the backup via API or with the Kibana Stack Management UI.

### Steps

1. Create bucket and user via Terraform
   Example bucket and user configuration can be
   found [here](https://github.com/utilitywarehouse/terraform/blob/master/aws/dev/dev-enablement/test-backups-s3-bucket.tf).
- both bucket and user can be configured with (
  system-terraform-modules)[https://github.com/utilitywarehouse/system-terraform-modules]
- sadly, we must use AWS user instead of role, which means that we must deal with static set of credentials instead of
  rolling them automatically with Vault. This is due to the fact that ElasticSearch supports either static credentials
  or IAM role token created by OIDC (available only in EKS)
  ([source](https://www.elastic.co/guide/en/elasticsearch/reference/8.11/repository-s3.html#iam-kubernetes-service-accounts)).

2. Patch the ElasticSearch manifest in order to provide the credentials
   Example patch can be found [here](example/env-patch.yaml).
   This patch modifies the ElasticSearch container, so that on start it runs a process that adds the credentials to the
   keystore.
   The process runs as a part of the container to ensure that it will run after the ES initialization, and that it will
   run every time the container is restarted.

   
3. Configure backup with Kibana UI
    - Go to Stack Management -> Snapshot and Restore
    - Add repository
    - Provide the repository name and type (S3)
    - Provide the bucket name and region
    - Provide the credentials (access key and secret key)
    - Save the repository
    - Verify the repository- it should have status `connected`
    - Create snapshot lifecycle policy
    - Run policy to test it 
