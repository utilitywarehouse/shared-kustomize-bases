# shared-kubernetes-manifests

This repository contains kustomize bases for common tools.

Everyone is encouraged to use them and to contribute.

## Helm-based manifests

#### Why

In order to not maintain manifests on our own, we are looking for well maintained manifests
which can be adapted to our needs. They often exists in the form of Helm charts-
eg. [Bitnami charts](https://github.com/bitnami/charts/).

Since UW has policy to not use Helm charts directly, we are making manifests by
templating chart with UW specific values and are using them as Kustomize bases.

#### Structure

| Directory/ File    | Purpose                                                                               |
|--------------------|---------------------------------------------------------------------------------------|
| `Makefile`         | Targets with parameters to generate customized manifests                              |
| `{name}/example`   | Example of everything needed to deploy the generated chart                            |
| `{name}/gen-yaml`  | Everything needed to generate manifest from helm chart                                |
| `{name}/manifests` | Manifest- generated and ready to be referenced. Together with hand- crafted overlays. |
