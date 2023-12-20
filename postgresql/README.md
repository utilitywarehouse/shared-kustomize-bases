# Postgresql

> [!WARNING]
> This is still a wip so it not ready for general use.
> - TODO need to fix an issue upstream where the backup directory is not set.
> - TODO test the restore process.
> - TODO create a nice manifest for doing a restore.

## Source

These manifests provide a base for deploying a Postgres stateful-set using the official docker image and a backup cronjob using an [image](https://github.com/eeshugerman/postgres-backup-s3) for backing up to an S3 bucket.

## Usage
It is expected that these manifests would be used as a Kustomize base with patches applied to suit your particular use case and requirements. An example of a possible setup is provided in the [examples](./examples) folder
