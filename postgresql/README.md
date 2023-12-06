# Postgresql

## Source

This manifest if built on the base of [Bitnami Postgresql Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)

This includes an automated backup using `pg_dumpall` than can be run on a configurable cronjob.

## Parameters

| Name                     | Purpose                                       | Example                                                       |
|--------------------------|-----------------------------------------------|---------------------------------------------------------------|
| NS                       | The namespace to deploy                       | dev-enablement                                                |
| NAME                     | The name of the postgresql instance             | "dev-enablement-developer-bonus-postgres"                     |
| OPSLEVEL_APP_DESCRIPTION | the description of your Postgresql for Opslevel | "projection of developers bonuses paid for by dev-enablement" |
| OPSLEVEL_APP_TIER        | How application tier level for Opslevel       | "tier_4"                                                              |



