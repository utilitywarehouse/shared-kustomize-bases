# Cockroachdb 

## TL;DR

- [Which manifest should I choose?](#flavour)
- [Example how to deploy Cockroach](example)
- [Runbooks, how to test it manually, access the admin panel](#usage)
- [Grafana dashboards](#metrics)

## Flavour

There are two manifest directories - `manifests-cfssl`, and `manifests-cert-manager`.

- `manifests-cert-manager` are using Kubernetes cert-manager controller,
  for generating and renewing certificates to secure communication between nodes and clients.
  For more information, see [CERT MANAGER REDME](manifests-cert-manager/CERT_MANAGER_README.  md).
- `manifests-cfssl` are **not recommended** for fresh install - they contain the manifests that demand
  certificate authority deployed within the namespace. For more information,
  see [CFSSL README](manifests-cfssl/CFSSL_README.md)

## Usage

There are runbooks in [docs](docs) directory, covering following topics:
- [backup](docs/backup.md)
- [pvc resize](docs/pvc-resize.md)
- [scaling](docs/scaling.md)
- [upgrade](docs/upgrade.md)

### Client

- The base provides a client deployment that bootstraps the Cockroach sql command.
- The client deployment is useful for debugging issues and communicating with Cockroach.
- An example command for starting a sql shell is `kubectl exec -it deployment/cockroachdb-client -c cockroachdb-client -- cockroach sql`

### Admin UI

In order to access admin UI, Port forward port 8080 on one of the cockroachdb- pods,
then navigate to https://localhost:8080/

### DB Console

CockroachDB has a DB console [user interface](https://www.cockroachlabs.com/docs/stable/ui-overview.html).
To log into the DB console you will require a database user.
This can be achieved by:
- Start a SQL shell using the client `kubectl exec -it deployment/cockroachdb-client -c cockroachdb-client -- cockroach sql`
- You may need to change the replica count of the client (see above)
- Create a user using SQL `CREATE USER foo WITH PASSWORD 'changeme';`
- Assign admin role to the user with the SQL command `GRANT admin TO foo;`
- This allows full access within the UI.
- Port forward any node `kubectl port-forward cockroachdb-0 8080`
- Use a browser to navigate to https://localhost:8080.
- It will warn you that the certificate is not trusted, this is expected.

## Metrics

There are Grafana dashboards prepared for the Cockroachdb.
They can be found using the name "cockroach overview",
e.g. [for `prod-aws`](https://grafana.prod.aws.uw.systems/d/ddnrjgg8eby80e/cockroachdb-overview?orgId=1).

## Backup/ migration

Our CockroachDB is configured with backup by default.
This requires a Service Account to be configured, see [configure backup](#configure-backup)
For more information, see [backup doc](docs/backup.md).

### Disable backup
Backup can be disabled using [disable backup component](manifests-cert-manager/disable-backup) - see [example](example/cert-manager/kustomization.yaml)
for instructions.

### Configure backup
In order to configure backup, you must create Service Account ([example](example/cert-manager/sa.yaml)) referencing AWS 
role with given bucket access. Role with bucket access should be configured in the Terraform repository - [example](https://github.com/utilitywarehouse/terraform/blob/ec6116c08335f27237ae94038a5aa12de0dcc8fe/aws/dev/dev-enablement/test-backups-s3-bucket.tf#L15).

AWS credentials are injected via [vault](https://github.com/utilitywarehouse/documentation/blob/master/infra/vault/vault-aws.md)

## Architecture

We recommend creating one instance of CockroachDB cluster per namespace instead of creating new cluster instance
for each of applications.
Data can be separated by creating different databases, and having one, bigger cluster instead of multiple smaller ones
reduces infrastructure costs and maintenance overhead.

### Single namespace - multiple CockroachDB clusters

While the preference is to have a single CockroachDB cluster per namespace, in some cases this isn't ideal.

An example of this is in the Energy team where they have recently split into three squads but currently still share use of the `energy-platform` namespace.

In order to deploy multiple CockroachDB clusters within a single namespace whilst avoiding naming conflicts we can make use of the `namePrefix` and/or `nameSuffix` ability of Kustomize.
This will automagically update the names of resources within a Kustomization as well as the selectors and labels.

One part of this that Kustomize is not able to help with is with the CockroachDB specific commands that are used to create and join nodes to the cluster.
For this two environment variables have been added `COCKROACH_INIT_HOST` and `COCKROACH_JOIN_STRING`.

- `COCKROACH_INIT_HOST` is used by the `init-job.yaml` manifest to initialise the first node in the cluster
- `COCKROACH_JOIN_STRING` is in the `statefulset.yaml` manifest to define which nodes will be joining the cluster.

There are sensible defaults for these environment variables to ensure that a single cluster within a namespace can be brought up without overriding any environment variables. 
