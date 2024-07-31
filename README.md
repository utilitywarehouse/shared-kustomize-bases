# shared-kubernetes-manifests

This repository contains kustomize bases for common tools.

Everyone is encouraged to use them and to contribute.

## Versioning

This repo uses tags to manage versions, these tags have two components:

- The version of the software image the manifests are using
- An internal version to track changes to manifests other than version upgrade

These tags are of the form `<image-version>-<manifest-version>`, for example: 
`cockroachdb/v23.1.10-2` is the 2nd internal version of these manifests supporting `cockroachdb/cockroachv:23.1.10`

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
| `components`       | Reusable kustomize components                                                         |
| `{name}/example`   | Example of everything needed to deploy the generated chart                            |
| `{name}/gen-yaml`  | Everything needed to generate manifest from helm chart                                |
| `{name}/manifests` | Manifest- generated and ready to be referenced. Together with hand- crafted overlays. |
