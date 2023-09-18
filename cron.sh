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

# This script should be called every night, by the crontab:
#   05 01 * * * /opt/iparapheur/dist/docker-resources/cron.sh

cd /opt/iparapheur/dist/docker-resources

# Backup...

./backup.sh
if [ $? -eq 0 ]; then
  echo "Backup completed successfully."
else
  echo -e "\e[31mBackup failed with exit code $?.\e[0m"
fi

# Restart the app...

cd /opt/iparapheur/current/
docker compose up -d
