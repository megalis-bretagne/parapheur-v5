#!/bin/bash
set -e

IFS=', ' read -r -a db_to_create <<< "$DB_TO_CREATE"

POSTGRES="psql --username ${POSTGRES_USER}"

for i in "${db_to_create[@]}"
do
    echo "Creating database: ${i}"
    $POSTGRES <<-EOSQL
CREATE DATABASE ${i} OWNER ${i};
EOSQL
done
