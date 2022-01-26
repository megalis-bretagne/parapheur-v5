#!/bin/bash

#
# i-Parapheur
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

psql -v ON_ERROR_STOP=1 --dbname "ipcore" <<-EOSQL

    DROP SERVER IF EXISTS flowable CASCADE;

    CREATE SERVER flowable
      FOREIGN DATA WRAPPER postgres_fdw
      OPTIONS (dbname 'flowable', host 'postgres', port '5432');

    CREATE USER MAPPING FOR ipcore
      SERVER flowable
      OPTIONS (user 'flowable', password 'flowable');


    CREATE FOREIGN TABLE act_ru_task(
        id_ VARCHAR(64),
        execution_id_ VARCHAR(64),
        proc_inst_id_ VARCHAR(64),
        name_ VARCHAR(255),
        parent_task_id_ VARCHAR(64),
        owner_ VARCHAR(255),
        assignee_ VARCHAR(255),
        delegation_ VARCHAR(64),
        create_time_ TIMESTAMP,
        due_date_ TIMESTAMP
      )
      SERVER flowable
      OPTIONS (schema_name 'public', table_name 'act_ru_task');

    CREATE FOREIGN TABLE act_ru_identitylink(
        id_ VARCHAR(64),
        group_id_ VARCHAR(255),
        type_ VARCHAR(255),
        task_id_ VARCHAR(255),
        proc_inst_id_ VARCHAR(255)
      )
      SERVER flowable
      OPTIONS (schema_name 'public', table_name 'act_ru_identitylink');

    CREATE FOREIGN TABLE act_ru_execution(
        id_ VARCHAR(64),
        proc_inst_id_ VARCHAR(64),
        business_key_ VARCHAR(255),
        parent_id_ VARCHAR(64),
        super_exec_ VARCHAR(64),
        root_proc_inst_id_ VARCHAR(64),
        is_active_ BOOLEAN,
        name_ VARCHAR(255),
        start_time_ TIMESTAMP,
        start_user_id_ VARCHAR(255)
      )
      SERVER flowable
      OPTIONS (schema_name 'public', table_name 'act_ru_execution');

    CREATE FOREIGN TABLE act_hi_varinst(
        id_ VARCHAR(64),
        proc_inst_id_ VARCHAR(64),
        execution_id_ VARCHAR(64),
        task_id_ VARCHAR(64),
        name_ VARCHAR(255),
        var_type_ VARCHAR(100),
        bytearray_id_ VARCHAR(64),
        double_ DOUBLE PRECISION,
        long_ BIGINT,
        text_ VARCHAR(4000),
        text2_ VARCHAR(4000)
      )
      SERVER flowable
      OPTIONS (schema_name 'public', table_name 'act_hi_varinst');

    CREATE FOREIGN TABLE act_hi_procinst(
        id_ VARCHAR(64),
        proc_inst_id_ VARCHAR(64),
        business_key_ VARCHAR(255),
        proc_def_id_ VARCHAR(64),
        start_time_ TIMESTAMP,
        end_time_ TIMESTAMP,
        duration_ BIGINT,
        super_process_instance_id_ VARCHAR(64),
        delete_reason_ VARCHAR(4000),
        name_ VARCHAR(255)
      )
      SERVER flowable
      OPTIONS (schema_name 'public', table_name 'act_hi_procinst');

    CREATE FOREIGN TABLE act_ru_variable(
        id_ VARCHAR(64),
        type_ VARCHAR(255),
        name_ VARCHAR(255),
        execution_id_ VARCHAR(64),
        proc_inst_id_ VARCHAR(64),
        task_id_ VARCHAR(64),
        var_type_ VARCHAR(100),
        bytearray_id_ VARCHAR(64),
        double_ DOUBLE PRECISION,
        long_ BIGINT,
        text_ VARCHAR(4000),
        text2_ VARCHAR(4000)
      )
      SERVER flowable
      OPTIONS (schema_name 'public', table_name 'act_ru_variable');


    ALTER FOREIGN TABLE act_ru_task OWNER TO ipcore;
    ALTER FOREIGN TABLE act_ru_identitylink OWNER TO ipcore;
    ALTER FOREIGN TABLE act_ru_execution OWNER TO ipcore;
    ALTER FOREIGN TABLE act_ru_variable OWNER TO ipcore;
    ALTER FOREIGN TABLE act_hi_varinst OWNER TO ipcore;
    ALTER FOREIGN TABLE act_hi_procinst OWNER TO ipcore;

EOSQL

echo "Core-Flowable linked data set"
