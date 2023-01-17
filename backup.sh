#!/usr/bin/env bash

#
# iparapheur
# Copyright (C) 2019-2023 Libriciel SCOP
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

CURRENT_DATE=$(date '+%Y%m%d-%H%M')
CURRENT_DATE=${CURRENT_DATE//:/-}
DUMP_PATH="backup_${CURRENT_DATE}"
DB_NAMES=("alfresco" "flowable" "keycloak" "ipcore" "quartz" "pastellconnector")

__main__() {
  printf "Shutting down iparapheur -\n"
  docker compose down -v

  printf "Starting databases -\n"
  docker compose up -d postgres matomo-db

  # TODO check if service is healthy
  printf "Waiting 10 seconds -\n"
  sleep 10s

  printf "Dumping MatomoDB databases -\n"
  docker compose exec matomo-db /usr/bin/mysqldump -u "${MATOMO_DB_USER}" --password="${MATOMO_DB_PASSWORD}" "${MATOMO_DB_DATABASE}" >"/tmp/${DUMP_PATH}_matomo_backup.sql"

  printf "Dumping PostgreSQL databases -\n"
  for DB_NAME in "${DB_NAMES[@]}"; do
    printf "Dumping %s -\n" "${DB_NAME}"
    docker compose exec postgres /bin/bash -c "export PGPASSWORD=${POSTGRES_PASSWORD} && /usr/bin/pg_dump -U ${POSTGRES_USER} ${DB_NAME}" >"/tmp/${DUMP_PATH}_${DB_NAME}.sql"
  done

  # The first --transform renames the /data directory to /backup_<current date>_data
  # The second --transform removes the /tmp directory that contains all the .sql dumps so they are at the same level at the /backup_<current date>_data directory
  #
  # Without the transforms :
  # backup_<current date>.tar.gz
  #   | tmp/
  #       | backup-2022-01-02_keycloak.sql
  #       | backup-2022-01-02_alfresco.sql
  #   | data/
  #
  # With the transforms :
  # backup_<current date>.tar.gz
  #   | backup-2022-01-02_keycloak.sql
  #   | backup-2022-01-02_alfresco.sql
  #   | backup-2022-01-02_data/

  printf "Shutting down databases -\n"
  docker compose down -v

  tar --transform="flags=r;s|data|${DUMP_PATH}_data|" --transform="flags=r;s|.env|.env_${DUMP_PATH}|" --transform="flags=r;s|tmp||" --exclude=data/alfresco/contentstore.deleted --exclude=data/pes-viewer --exclude=data/nginx --exclude=data/matomo-db --exclude=data/postgres -cf "${DUMP_PATH}".tar.gz .env data /tmp/${DUMP_PATH}*

  printf "DUMP complete -> %s -\n" "${DUMP_PATH}"
}

__main__ "${@}"
