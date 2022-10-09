#!/bin/bash

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

set -e

POSTGRES="psql -v ON_ERROR_STOP=1 --username ${POSTGRES_USER} "

#
# ALFRESCO
#
echo "Creating database: alfresco"
$POSTGRES <<-EOSQL
      CREATE DATABASE alfresco OWNER ${CONTENT_DB_USER};
EOSQL

#
# WORKFLOW
#
echo "Creating database: flowable"
$POSTGRES <<-EOSQL
      CREATE DATABASE flowable OWNER ${WORKFLOW_DB_USER};
EOSQL

#
# KEYCLOAK
#
echo "Creating database: keycloak"
$POSTGRES <<-EOSQL
      CREATE DATABASE keycloak OWNER ${KEYCLOAK_DB_USER};
EOSQL

#
# CORE
#
echo "Creating database: ipcore"
$POSTGRES <<-EOSQL
      CREATE DATABASE ipcore OWNER ${CORE_DB_USER};
EOSQL

#
# QUARTZ
#
echo "Creating database: quartz"
$POSTGRES <<-EOSQL
      CREATE DATABASE quartz OWNER ${QUARTZ_DB_USER};
EOSQL

#
# PASTELL CONECTOR
#
echo "Creating database: pastellconnector"
$POSTGRES <<-EOSQL
      CREATE DATABASE pastellconnector OWNER ${SECUREMAIL_DB_USER};
EOSQL
