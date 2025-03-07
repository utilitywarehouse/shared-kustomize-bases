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

### Changing the deployment name

If you have an existing cluster that has names that overlap with the ones in this manifests, you can
work around that by doing the following:

- Use `- nameSuffix: $suffix` in the kustomization file where you import the base. This
  will suffix the names of all services, deployments, etc with `$suffix`.
- Patch the `KIBANA_ELASTICSEARCH_URL` in the kibana deployment so that it points to the service
  with the applied suffix. For example, if you used `-v2` in the above, `KIBANA_ELASTICSEARCH_URL`
  should be `http://elasticsearch-v2:9200`.
- Patch the configmap so that the `elasticsearch.hosts` points to the same url as the one in the
  kibana deployment.
- Patch `ELASTICSEARCH_CLUSTER_HOSTS`, `ELASTICSEARCH_CLUSTER_MASTER_HOSTS` and
  `ELASTICSEARCH_ADVERTISED_HOSTNAME` in the elastic statefulset in the same way as you patched the
  kibana deployment.

You can use [this](https://github.com/utilitywarehouse/kubernetes-manifests/tree/d9cf6e952751b708910c9cfed795357df8f59e1f/dev-merit/cbc/elastic-v2) as an example

### Scaling

In order to add nodes to cluster, first scale down to 0 replicas
in order to avoid inconsistencies in the configuration.

## Metrics

There are Grafana dashboards prepared for the ElasticSearch instances installed via shared kustomize base.
They can be found using the name "elasticsearch overview",
e.g. [for `dev-merit`](https://grafana.dev.merit.uw.systems/d/4yyL6dBMk/elasticsearch-overview?orgId=1).

## Alerts
There are stock alerts for ElasticSearch, which runs for every team that [subscribed to stock alerts](https://github.com/utilitywarehouse/system-alerts/tree/main/common/stock#usage).
They can be found [here](https://github.com/utilitywarehouse/system-alerts/blob/main/common/stock/elasticsearch.yaml.tmpl).

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
   - both bucket and user can be configured with [system-terraform-modules](https://github.com/utilitywarehouse/system-terraform-modules).
   - sadly, we must use AWS user instead of role, which means that we must deal with static set of credentials instead of
     rolling them automatically with Vault. This is due to the fact that ElasticSearch supports either static credentials
     or IAM role token created by OIDC (available only in EKS)
     ([source](https://www.elastic.co/guide/en/elasticsearch/reference/8.11/repository-s3.html#iam-kubernetes-service-accounts)).
     We created an [issue about that](https://github.com/elastic/elasticsearch/issues/106484) in Elasticsearch repository.
     Once you have run `make plan` and `make apply` you can capture the outputs you need using command
     `make show ARGS="-json"`.


2. Patch the ElasticSearch manifest in order to provide the credentials
   Example patch can be found [here](example/env-patch.yaml). Real life example of patch can be found [here](https://github.com/utilitywarehouse/kubernetes-manifests/blob/master/dev-merit/dev-enablement/elasticsearch/env-patch.yaml).
   This patch modifies the ElasticSearch container, so that on start it runs a process that adds the credentials to the
   keystore, and startup probe ensures credentials are correctly picked up.

   
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
