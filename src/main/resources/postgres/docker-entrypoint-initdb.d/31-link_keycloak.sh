#!/bin/bash

# i-Parapheur
# Copyright (C) 2019-2020 Libriciel-SCOP
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -e

psql -v ON_ERROR_STOP=1 --dbname "ipcore" <<-EOSQL

    DROP SERVER IF EXISTS keycloak CASCADE;

    CREATE SERVER keycloak
      FOREIGN DATA WRAPPER postgres_fdw
      OPTIONS (dbname 'keycloak', host 'postgres', port '5432');

    CREATE USER MAPPING FOR ipcore
      SERVER keycloak
      OPTIONS (user 'keycloak', password 'keycloak');


    CREATE FOREIGN TABLE user_entity(
        id VARCHAR(36),
        email VARCHAR(255),
        enabled BOOLEAN,
        first_name VARCHAR(255),
        last_name VARCHAR(255),
        realm_id VARCHAR(255),
        username VARCHAR(255)
      )
      SERVER keycloak
      OPTIONS (schema_name 'public', table_name 'user_entity');

    CREATE FOREIGN TABLE keycloak_role(
        id VARCHAR(36),
        description VARCHAR(255),
        name VARCHAR(255),
        realm_id VARCHAR(255)
      )
      SERVER keycloak
      OPTIONS (schema_name 'public', table_name 'keycloak_role');

    ALTER FOREIGN TABLE user_entity OWNER TO ipcore;
    ALTER FOREIGN TABLE keycloak_role OWNER TO ipcore;

EOSQL

echo "Core-Keycloak linked data set"
