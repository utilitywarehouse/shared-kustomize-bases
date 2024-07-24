# Redis

## TL;DR

- [Which manifest should I choose?](#flavour)

- [Example kustomization file deploying Redis](example)
- [Test it manually using redis-cli](#usage)
- [Grafana dashboards](#metrics)

## Flavour

There are two manifest directories - `manifests-cfssl`, and `manifests-cert-manager`.

- `manifests-cfssl` are **not recommended** for fresh install - they contain the manifests that demand
  certificate authority deployed within the namespace. For more information,
  see [CFSSL README](manifests-cfssl/CFSSL_README.md)
  They are kept here for backwards compatibility reasons.
- `manifests-cert-manager` are using Kubernetes cert-manager controller, which
  makes them easier to set up and maintain. For more information,
  see [CERT MANAGER REDME](manifests-cert-manager/CERT_MANAGER_README.md).

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
