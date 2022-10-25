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

ARCHIVE_PATH=$1

POSTGRES_CONTAINER_NAME="iparapheur-postgres-1"
MATOMO_DB_CONTAINER_NAME="iparapheur-matomo-db-1"

DB_NAMES=("alfresco" "flowable" "keycloak" "ipcore" "quartz" "pastellconnector")

# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# Main function
# ----------------------------------------------------------------------------------------------------------------------
__main__() {
  printf "Shutting down iparapheur...\n"
  docker compose down -v

  DUMP_PATH=${ARCHIVE_PATH::-7}

  printf "Unzipping backup...\n"
  mkdir "${DUMP_PATH}"
  tar -xf "${ARCHIVE_PATH}" -C "${DUMP_PATH}"

  printf "Replacing .env...\n"
  ENV_BACKUP_NAME=.env.backup."$(date '+%Y%m%d-%H%M')"
  cp .env "${ENV_BACKUP_NAME}"
  printf "Created .env file backup : %s\n" "${ENV_BACKUP_NAME}"

  cp "${DUMP_PATH}/.env_${DUMP_PATH}" .env

  printf "Replacing data folder...\n"
  rm -r data
  mv "${DUMP_PATH}/${DUMP_PATH}_data" data

  docker compose up -d postgres matomo-db

  # TODO check if service is healthy
  sleep 5s

  set -a && source .env && set +a
  printf "Loading MatomoDB databases dumps\n"
  docker exec -i "${MATOMO_DB_CONTAINER_NAME}" /usr/bin/mysqldump -u "${MATOMO_DB_USER}" --password="${MATOMO_DB_PASSWORD}" "${MATOMO_DB_DATABASE}" <"${DUMP_PATH}/${DUMP_PATH}_matomo_backup.sql"

  printf "Loading PostgresSQL databases dumps\n"

  for DB_NAME in "${DB_NAMES[@]}"; do
    printf "Loading dump %s...\n" "${DB_NAME}"
    printf "--------------------------------------------------------------------------------------------------------\n"
    docker exec -i "${POSTGRES_CONTAINER_NAME}" /bin/bash -c "PGPASSWORD=${POSTGRES_PASSWORD} psql --username ${POSTGRES_USER} ${DB_NAME}" <"${DUMP_PATH}/${DUMP_PATH}_${DB_NAME}.sql"
  done

  rm -R "${DUMP_PATH}"
  printf "Restoration complete."
}

__main__ "${@}"
