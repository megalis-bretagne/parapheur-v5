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

BACKUPS_ROOT_DIR=${BACKUPS_ROOT_DIR:-/data/iparapheur_backups}
  # Keep the 2 most recent backups. We'll bow to the 3-2-1 backup strategy
  # Note that we should skip saturday and sunday backups in the crontab

  # Delete *_pending backups
  rm ${BACKUPS_ROOT_DIR}/*_pending.tar.gz

  # Number of backups
  backup_count=$(find ${BACKUPS_ROOT_DIR} -name 'backup_*.tar.gz' | wc -l)

  # Check if at least 2 backups are present
  if [ $backup_count -gt 1 ]; then
    # Deleting all backups exept the last 2
    ls -1t ${BACKUPS_ROOT_DIR}/backup_*.tar.gz | sort -r | tail -n +3 | xargs rm > /dev/null 2>&1
  fi