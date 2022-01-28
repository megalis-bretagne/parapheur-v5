#!/bin/sh

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

cp /tmp/keycloak.json /tmp/keycloak_env_var_patched.json

echo 'Patching keycloak.json file, replacing values :'
echo '    ${env.KEYCLOAK_REALM}         : '${KEYCLOAK_REALM}
echo '    ${env.KEYCLOAK_CLIENT_ID}     : '${KEYCLOAK_CLIENT_ID}
echo '    ${env.KEYCLOAK_WEB_CLIENT_ID} : '${KEYCLOAK_WEB_CLIENT_ID}
echo '    ${env.KEYCLOAK_CLIENT_SECRET} : '$( [[ ${#KEYCLOAK_CLIENT_SECRET} = 0 ]] && echo 'NO VALUE !!!' || echo '*****' )
echo '    ${env.KEYCLOAK_USER}          : '${KEYCLOAK_USER}
echo '    ${env.KEYCLOAK_PASSWORD}      : '$( [[ ${#KEYCLOAK_PASSWORD} = 0 ]] && echo 'NO VALUE !!!' || echo '*****' )

sed -i "s/\${env.KEYCLOAK_REALM}/${KEYCLOAK_REALM}/g"                 /tmp/keycloak_env_var_patched.json
sed -i "s/\${env.KEYCLOAK_CLIENT_ID}/${KEYCLOAK_CLIENT_ID}/g"         /tmp/keycloak_env_var_patched.json
sed -i "s/\${env.KEYCLOAK_WEB_CLIENT_ID}/${KEYCLOAK_WEB_CLIENT_ID}/g"         /tmp/keycloak_env_var_patched.json
sed -i "s/\${env.KEYCLOAK_CLIENT_SECRET}/${KEYCLOAK_CLIENT_SECRET}/g" /tmp/keycloak_env_var_patched.json
sed -i "s/\${env.KEYCLOAK_USER}/${KEYCLOAK_USER}/g"                   /tmp/keycloak_env_var_patched.json
sed -i "s/\${env.KEYCLOAK_PASSWORD}/${KEYCLOAK_PASSWORD}/g"           /tmp/keycloak_env_var_patched.json
