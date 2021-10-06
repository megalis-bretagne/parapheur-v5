#!/bin/bash

#
# i-Parapheur
# Copyright (C) 2019-2021 Libriciel SCOP
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

psql -v ON_ERROR_STOP=1 --dbname "ipcore" <<-EOSQL

    CREATE EXTENSION IF NOT EXISTS postgres_fdw;

    GRANT USAGE ON FOREIGN DATA WRAPPER postgres_fdw TO PUBLIC;

EOSQL

echo "Core linked data set"
