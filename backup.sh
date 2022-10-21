#!/usr/bin/env bash

#
# iparapheur
# Copyright (C) 2019-2022 Libriciel SCOP
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

# ----------------------------------------------------------------------------------------------------------------------
# "Bootstrap"
# ----------------------------------------------------------------------------------------------------------------------

set -o errexit
set -o errtrace
set -o functrace
set -o nounset
set -o pipefail

# Use xtrace ?
if [ "$(getopt --longoptions xtrace -- x "$@" 2>/dev/null | grep --color=none "\(^\|\s\)\(\-x\|\-\-xtrace\)\($\|\s\)")" != "" ]; then
  set -o xtrace
fi

POSTGRES_USER=$1
POSTGRES_PASSWORD=$2
MATOMO_DB_USER=$3
MATOMO_DB_PASSWORD=$4
MATOMO_DB_DATABASE=$5

printf "POSTGRES_USER : %s\n" POSTGRES_USER
printf "POSTGRES_PASSWORD : %s\n" POSTGRES_PASSWORD

CONTAINER_NAME="iparapheur-postgres-1"

DB_NAMES=("alfresco" "flowable" "keycloak" "ipcore" "quartz" "pastellconnector")

# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# Main function
# ----------------------------------------------------------------------------------------------------------------------
__main__() {
  CURRENT_DATE=$(date "+%F_%T")
  CURRENT_DATE=${CURRENT_DATE//:/-}
  DUMP_PATH="data_${CURRENT_DATE}"

  mkdir -m 757 "${DUMP_PATH}"

  rsync -av --exclude=data/matomo-db --exclude=data/postgres  ./data "${DUMP_PATH}"

  printf "Dumping MatomoDB databases"
  docker exec iparapheur-matomo-db-1 /usr/bin/mysqldump -u "${MATOMO_DB_USER}" --password="${MATOMO_DB_PASSWORD}" "${MATOMO_DB_DATABASE}" | gzip -9 >"${DUMP_PATH}/matomo-backup.sql.gz"

  printf "Dumping PostgreSQL databases"

  for DB_NAME in "${DB_NAMES[@]}"; do
    printf "Dumping %s...\n" "${DB_NAME}"
    docker exec ${CONTAINER_NAME} /bin/bash -c "export PGPASSWORD=${POSTGRES_PASSWORD} && /usr/bin/pg_dump -U ${POSTGRES_USER} ${DB_NAME}" | gzip -9 >"${DUMP_PATH}/postgres-backup-${DB_NAME}.sql.gz"
  done

  printf "Shutting down iparapheur..."
  docker compose down -v

  tar -czf "${DUMP_PATH}".tar.gz "${DUMP_PATH}"
  rm -r "${DUMP_PATH}"

  chown 6789:6789 "${DUMP_PATH}".tar.gz

  printf "DUMP complete -> %s.\n" "${DUMP_PATH}"
}

__main__ "${@}"
