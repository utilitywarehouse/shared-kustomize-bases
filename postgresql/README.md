# Postgresql

## Source

These manifests provide a base for deploying a Postgres stateful-set using the official docker image and a backup cronjob using an [image](https://github.com/eeshugerman/postgres-backup-s3) for backing up to an S3 bucket.

## Usage
It is expected that these manifests would be used as a Kustomize base with patches applied to suit your particular use case and requirements. An example of a possible setup is provided in the [examples](./examples) folder
