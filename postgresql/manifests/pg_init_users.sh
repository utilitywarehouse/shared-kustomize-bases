#!/bin/bash
# Initial user setup for postgres database
# includes setting up an application users and exporter user.

[ -z "$DB_ROOT" ] && echo "Error not set DB_ROOT" && exit 1
[ -z "$DB_NAME" ] && echo "Error not set DB_NAME" && exit 1
[ -z "$POSTGRES_PASSWORD" ] && echo "Error not set POSTGRES_PASSWORD" && exit 1
[ -z "$APP_PASSWORD" ] && echo "Error not set APP_PASSWORD" && exit 1
[ -z "$EXPORTER_PASSWORD" ] && echo "Error not set EXPORTER_PASSWORD" && exit 1

set -x

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
CREATE DATABASE ${DB_NAME};

\c ${DB_NAME};

CREATE USER app WITH PASSWORD '${APP_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO app;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO app;

CREATE USER exporter WITH PASSWORD '${EXPORTER_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO exporter;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO exporter;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO exporter;
EOSQL
