#!/bin/bash

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

set -e

POSTGRES="psql -v ON_ERROR_STOP=1 --username ${POSTGRES_USER} "

#
# ALFRESCO
#
echo "Creating database role: ${CONTENT_DB_USER}"
$POSTGRES <<-EOSQL
      CREATE USER ${CONTENT_DB_USER} WITH CREATEDB PASSWORD '${CONTENT_DB_PASSWORD}';
EOSQL

#
# WORKFLOW
#
echo "Creating database role: ${WORKFLOW_DB_USER}"
$POSTGRES <<-EOSQL
      CREATE USER ${WORKFLOW_DB_USER} WITH CREATEDB PASSWORD '${WORKFLOW_DB_PASSWORD}';
EOSQL

#
# KEYCLOAK
#
echo "Creating database role: ${KEYCLOAK_DB_USER}"
$POSTGRES <<-EOSQL
      CREATE USER ${KEYCLOAK_DB_USER} WITH CREATEDB PASSWORD '${KEYCLOAK_DB_PASSWORD}';
EOSQL

#
# CORE
#
echo "Creating database role: ${CORE_DB_USER}"
$POSTGRES <<-EOSQL
      CREATE USER ${CORE_DB_USER} WITH CREATEDB PASSWORD '${CORE_DB_PASSWORD}';
EOSQL

#
# QUARTZ
#
echo "Creating database role: ${QUARTZ_DB_USER}"
$POSTGRES <<-EOSQL
      CREATE USER ${QUARTZ_DB_USER} WITH CREATEDB PASSWORD '${QUARTZ_DB_PASSWORD}';
EOSQL

#
# PASTELL CONECTOR
#
echo "Creating database role: ${SECUREMAIL_DB_USER}"
$POSTGRES <<-EOSQL
      CREATE USER ${SECUREMAIL_DB_USER} WITH CREATEDB PASSWORD '${SECUREMAIL_DB_PASSWORD}';
EOSQL
