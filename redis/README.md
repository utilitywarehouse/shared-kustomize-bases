# Redis

## Run

## Source

This manifest is build on the base of Bitnami Redis Helm chart.

To generate manifests out of Helm chart from the
[Bitnami source](https://github.com/bitnami/charts/tree/main/bitnami/redis),
run following commands from the Helm chart directory:

```bash
helm dependency build
helm template . --output-dir <output-dir>
```
