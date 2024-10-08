#!/usr/bin/env bash

#
# iparapheur
# Copyright (C) 2019-2024 Libriciel SCOP
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

IP_CURRENT_INSTALL_DIR=/opt/iparapheur/current/

cd ${IP_CURRENT_INSTALL_DIR}
set -a && source .env && set +a

set -o errexit
set -o errtrace
set -o functrace
set -o nounset
set -o pipefail

# Use xtrace ?
if [ "$(getopt --longoptions xtrace -- x "$@" 2>/dev/null | grep --color=none "\(^\|\s\)\(\-x\|\-\-xtrace\)\($\|\s\)")" != "" ]; then
  set -o xtrace
fi

CURRENT_DATE=$(date '+%Y-%m-%d_%H-%M')
CURRENT_DATE=${CURRENT_DATE//:/-}
CURRENT_SAVE_FOLDER_NAME="/backup_${CURRENT_DATE}"
DB_NAMES=("alfresco" "flowable" "keycloak" "ipcore" "quartz" "pastellconnector")

# The tar command poorly manages the double slashes in paths.
# We remove the trailing ones.
DATA_ROOT_DIR=${DATA_ROOT_DIR%%+(/)}

__main__() {

  mkdir --parents "${BACKUPS_ROOT_DIR:?}"

  printf "Shutting down iparapheur -\n"
  cd ${IP_CURRENT_INSTALL_DIR}
  docker compose down --volumes --remove-orphans

  printf "Starting database -\n"
  docker compose up --detach postgres

  # TODO check if service is healthy
  #  using some kind of docker inspect?
  printf "Waiting 10 seconds -\n"
  sleep 10s

  printf "Dumping PostgreSQL databases -\n"
  for DB_NAME in "${DB_NAMES[@]}"; do
    printf "Dumping %s -\n" "${DB_NAME}"
    docker compose exec postgres /bin/bash -c \
        "export PGPASSWORD=${POSTGRES_PASSWORD:?}"
    docker compose exec postgres /bin/bash -c \
          "pg_dump --username ${POSTGRES_USER:?} ${DB_NAME}" > "/tmp/${CURRENT_SAVE_FOLDER_NAME}_${DB_NAME}.sql"
  done

  cp ${IP_CURRENT_INSTALL_DIR}.env /tmp/${CURRENT_SAVE_FOLDER_NAME}.env

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

  tar --transform="flags=r;s|data|${CURRENT_SAVE_FOLDER_NAME}_data|" \
      --transform="flags=r;s|tmp||" \
      --exclude=${DATA_ROOT_DIR:?}/alfresco/contentstore.deleted \
      --exclude=${DATA_ROOT_DIR:?}/pes-viewer \
      --exclude=${DATA_ROOT_DIR:?}/nginx \
      --exclude=${DATA_ROOT_DIR:?}/postgres \
      --create --gzip --file "${BACKUPS_ROOT_DIR:?}/${CURRENT_SAVE_FOLDER_NAME}"_pending.tar.gz \
      --add-file /tmp/${CURRENT_SAVE_FOLDER_NAME}.env \
      --add-file ${DATA_ROOT_DIR:?} \
      --add-file /tmp/${CURRENT_SAVE_FOLDER_NAME}*

  printf "DUMP complete -> %s -\n" "${BACKUPS_ROOT_DIR:?}/${CURRENT_SAVE_FOLDER_NAME}"

  printf "Clean up temp & old files -\n"
  rm /tmp/${CURRENT_SAVE_FOLDER_NAME}*
  mv "${BACKUPS_ROOT_DIR:?}/${CURRENT_SAVE_FOLDER_NAME}_pending.tar.gz" "${BACKUPS_ROOT_DIR:?}/${CURRENT_SAVE_FOLDER_NAME}.tar.gz"
}

__main__ "${@}"
