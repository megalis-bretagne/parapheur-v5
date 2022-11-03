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

DUMP_PATH=$1
DATE=$2
DB_NAMES=("alfresco" "flowable" "keycloak" "ipcore" "quartz" "pastellconnector")

__main__() {
  printf "Shutting down iparapheur -\n"
  docker compose down -v

  printf "Starting databases -\n"
  docker compose up -d postgres matomo-db

  # TODO check if service is healthy
  printf "Waiting 10 seconds -\n"
  sleep 10s

  printf "Exporting .env -\n"
  set -a && source .env && set +a

  printf "Loading MatomoDB database dump -\n"
  docker compose exec -i matomo-db /usr/bin/mysqldump -u "${MATOMO_DB_USER}" --password="${MATOMO_DB_PASSWORD}" "${MATOMO_DB_DATABASE}" <"${DUMP_PATH}/backup_${DATE}_matomo_backup.sql"

  printf "Loading PostgresSQL databases dumps -\n"
  for DB_NAME in "${DB_NAMES[@]}"; do
    printf "Loading dump %s -\n" "${DB_NAME}"
    docker compose exec -i postgres /bin/bash -c "PGPASSWORD=${POSTGRES_PASSWORD} psql --username ${POSTGRES_USER} ${DB_NAME}" <"${DUMP_PATH}/backup_${DATE}_${DB_NAME}.sql"
  done

  printf "Restoration complete -\n"
}

__main__ "${@}"
