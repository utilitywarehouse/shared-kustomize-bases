# shared-kubernetes-manifests

This repository contains kustomize bases for common tools.

Everyone is encouraged to use them and to contribute.

## Helm-based manifests

#### Why

In order to not maintain manifests on our own, we are looking for well maintained manifests
which can be adapted to our needs. They often exists in the form of Helm charts-
eg. [Bitnami charts](https://github.com/bitnami/charts/).

Since UW has policy to not use Helm charts directly, we are making manifests by
templating chart with team specific values and are using them as Kustomize bases.

#### How

In order to generate manifests which your team will be able to use:

1. Go to directory of your chosen tool
2. Add Makefile target with parameters suitable for the tool you need
3. Run Makefile target in order to generate manifests
4. Create and merge PR with your changes
5. Reference this repository from the Kustomize file in your directory
   in [Kubernetes-manifests](https://github.com/utilitywarehouse/kubernetes-manifests)

#### Structure

| Directory/ File | Purpose                                                    |
|-----------------|------------------------------------------------------------|
| `example`       | Example of everything needed to deploy the generated chart |
| `gen-yaml`      | Everything needed to generate manifest from helm chart     |
| `manifests`     | Manifests- generated and ready to use                      |
| `Makefile`      | Targets with parameters to generate customized manifests   | 
