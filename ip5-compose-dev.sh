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
if [ "`getopt --longoptions xtrace -- x "$@" 2> /dev/null | grep --color=none "\(^\|\s\)\(\-x\|\-\-xtrace\)\($\|\s\)"`" != "" ] ; then
    set -o xtrace
fi

# Don't do anything unless forced to
FORCE="0"

IGNORE_MATOMO_VERSION="0"

# Security problems ahead with .env export...
# which is why it's a dev script
export_dot_env() {
    set -o allexport
    # @see https://stackoverflow.com/a/29327295
    eval "$(sed "s/\(<\|>\)//g" .env | sed "s/=https$/=http/g")"
    set +o allexport
}

export_dot_env

KARATE_DEFAULT_TAGS_PATH="./src/test/resources/features"
# @todo: get and use
KEYCLOAK_CLIENT_SECRET="${KEYCLOAK_CLIENT_SECRET:-random-uuid}"
MATOMO_COOKIES="${MATOMO_COOKIES:-/tmp/matomo-setup-cookies.txt}"
MATOMO_DB_HOST="${MATOMO_DB_HOST:-matomo-db}"
MATOMO_DB_HOST="${MATOMO_DB_HOST:-matomo-db}"
MATOMO_DB_TYPE="${MATOMO_DB_TYPE:-InnoDB}"
MATOMO_DB_ROOT_EMAIL="${MATOMO_DB_ROOT_EMAIL:-admin@dom.local}"
MATOMO_DB_ROOT_USER="${MATOMO_DB_ROOT_USER:-admin}"
MATOMO_EXPECTED_VERSION="4.2.1"
MATOMO_SITE_ID="${MATOMO_SITE_ID:-1}"
MATOMO_SITE_NAME="${MATOMO_SITE_NAME:-i-Parapheur - Général}"
MATOMO_SITE_TIMEZONE="${MATOMO_SITE_TIMEZONE:-Europe/Paris}"
MATOMO_TABLES_PREFIX="${MATOMO_TABLES_PREFIX:-matomo_}"
MATOMO_TOKEN_NAME="${MATOMO_TOKEN_NAME:-ipcore}"
MATOMO_TMP_HTML="${MATOMO_TMP_HTML:-/tmp/matomo-setup-tmp.html}"
MATOMO_URL="${MATOMO_URL:-http://${APPLICATION_HOST}/matomo/}"
SLEEP_VALUE="${SLEEP_VALUE:-30s}"
OVERRIDE_COMPOSE_FILE="1"
START_APP="1"

# ======================================================================================================================

__trap_exit__()
{
    local code="${1}"

    # Make sure we're called from the main script
    if [ "${$}" -eq "${BASHPID}" ]; then
        if [ ${code} -eq 0 ] ; then
            log_success "process ${BASHPID} exited normally in ${SECONDS}s at `date_now`"
        else
            # Unset trap so we exit immediately
            trap - ERR EXIT

            # Prepare stack trace
            local stack_trace=()
            for ((i=0;i<${#FUNCNAME[@]}-1;i++)) ; do
                stack_trace+=("${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} in function ${FUNCNAME[$i+1]}")
            done

            # Print the stack trace
            log_error "process ${BASHPID} exited with error code ${code} in ${SECONDS}s at `date_now`"
            >&2 printf "\nStack trace (most recent call last):\n"
            for ((i=${#stack_trace[@]}-1;i>=0;i--)) ; do
                >&2 printf "  ${stack_trace[$i]}\n"
            done
        fi
    fi
}

# @fixme: wrong code
__trap_signals__()
{
    local code="${?}"
    if [ ${code} -ne 0 ] ; then
        local signal=$((${code} - 128))
        local name="`kill -l ${signal}`"

        >&2 printf "\nProcess ${BASHPID} received SIG${name} (${signal}), exiting...\n"
    fi
}

trap '__trap_exit__ ${?} ${LINENO}' ERR EXIT
trap '__trap_signals__ ${?}' SIGHUP SIGINT SIGQUIT SIGTERM

# ======================================================================================================================

declare -r _blue_="\e[34m"
declare -r _cyan_="\e[36m"
declare -r _default_="\e[0m"
declare -r _green_="\e[32m"
declare -r _light_yellow_="\e[93m"
declare -r _red_="\e[31m"

# @see https://unix.stackexchange.com/a/25907
declare -r _check_="\xE2\x9C\x94"
declare -r _cross_="\xE2\x9D\x8C"
declare -r _warning_="\xE2\x9A\xA0"

# ----------------------------------------------------------------------------------------------------------------------

date_now() { date "+%Y-%m-%d %H:%M:%S"; }

log_error()   { printf "${_red_}${2:-Error:}${_default_} ${1}\n"; }
log_info()    { printf "${_cyan_}${2:-Info:}${_default_} ${1}\n"; }
log_success() { printf "${_green_}${2:-Success:}${_default_} ${1}\n"; }
log_warning() { printf "${_light_yellow_}${2:-Warning:}${_default_} ${1}\n"; }

log_icon_check()   { log_success "${1}" "${_check_}"; }
log_icon_cross()   { log_error "${1}" "${_cross_}"; }
log_icon_warning() { log_warning "${1}" "${_warning_}"; }

log_hr()   {
    local char=${1:--}
    local times=${2:-80}
    printf "%${times}s\n" | sed "s/ /${char}/g"
}

# ----------------------------------------------------------------------------------------------------------------------

declare -r __FILE__="$(realpath "${0}")"
declare -r __SCRIPT__="$(basename "${__FILE__}")"
declare -r __ROOT__="$(realpath "$(dirname "${__FILE__}")")"

# ======================================================================================================================

__usage__()
{
    local warning="${_red_}Warning!${_default_}"

    printf "NAME\n"
    printf "  %s\n" "${__SCRIPT__}"
    printf "\nDESCRIPTION\n"
    printf "  Development helper script for i-Parapheur v. 5\n"
    printf "  Look at the top of the file for some extra variables (that can be passed as environment variables)\n"
    printf "  It should detect a linux or macos environment and use specific override-dev according to arch\n"
    printf "\nSYNOPSIS\n"
    printf "  %s [OPTION] [COMMAND]\n" "${__SCRIPT__}"
    printf "\nCOMMANDS\n"
    printf "  check\t\tCheck the prerequisites needed to setup a working i-Parapheur v. 5 development environment\n"
    printf "  karate-tags\tList all tags used in karate fixture files path (default: %s)\n"  "${KARATE_DEFAULT_TAGS_PATH}"
    printf "  setup\t\tCheck the prerequisites, setup and launch a working i-parapheur 5 installation\n"
    printf "  \t\t${warning} Destroys and re-creates a working i-Parapheur v. 5 development environment\n"
    printf "  \t\t${warning} Uses sudo to destroy and recreate /data/iparapheur dir.\n"
    printf "  \t\t${warning} Reads and exports values from the .env file\n"
    printf "  \t\t${warning} Replaces values (MATOMO_TOKEN, VAULT_TOKEN, VAULT_UNSEAL_KEY) in the .env file and exports them\n"
    printf "\nOPTIONS\n"
    printf "  -f|--force\t\t\tYou have to use this option for the setup command to work\n"
    printf "  -h|--help\t\t\tDisplay this help\n"
    printf "  --ignore-matomo-version\tDon't fail for unexpected Matomo version during check or setup (expected ${MATOMO_EXPECTED_VERSION})\n"
    printf "  --ignore-override-compose\tDon't use docker-compose override file\n"
    printf "  --dont-start-app\t\tDon't start app after initialization\n"
    printf "  -s|--sleep\t\t\tThe sleep amount to wait for the vault container or the matomo containers to properly start up during setup (default: 30s)\n"
    printf "  -x|--xtrace\t\t\tDebug mode, prints every command before executing it (set -o xtrace)\n"
    printf "\nEXEMPLES\n"
    printf "  %s check\n" "${__SCRIPT__}"
    printf "  %s karate-tags %s\n" "${__SCRIPT__}" "${KARATE_DEFAULT_TAGS_PATH}"
    printf "  %s setup --force\n" "${__SCRIPT__}"
    printf "  %s setup --force --sleep 30s\n" "${__SCRIPT__}"
    printf "  %s --help\n" "${__SCRIPT__}"
    printf "\n"
}

urlencode () {
    local string="${1}"
    python3 -c "exec(\"import sys\nfrom urllib.parse import quote_plus\nprint(quote_plus(sys.argv[1]))\")" "${string}"
}

log_info "started process ${BASHPID} at `date_now`\n" "Startup:"

# @see https://stackoverflow.com/a/3466183
accepted_arch() {
    local arch="`uname -s`"
    case "${arch}" in
        Darwin*)
            echo "macos"
        ;;
        Linux*)
            echo "linux"
        ;;
        *)
            >&2 echo "Unaccepted arch \"${arch}\". This development script only works for Darwin or Linux."
            exit 2
        ;;
    esac
}

# @see https://stackoverflow.com/a/4025065
version_compare() {
    if [[ $1 == $2 ]] ; then
        echo 0
        return
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)) ; do
        ver1[i]=0
    done
    # fill empty fields in ver2 with zeros
    for ((i=${#ver2[@]}; i<${#ver1[@]}; i++)) ; do
        ver2[i]=0
    done

    for ((i=0; i<${#ver1[@]}; i++)) ; do
        if [[ -z ${ver2[i]} ]] ; then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi

        if ((10#${ver1[i]} > 10#${ver2[i]})) ; then
            echo 1
            return
        fi

        if ((10#${ver1[i]} < 10#${ver2[i]})) ; then
            echo -1
            return
        fi
    done
    echo 0
    return
}

__check_commands__() {
    required_commands=(bash curl docker grep python3 sed)
    missing_commands=()

    for required_command in "${required_commands[@]}";do
        if [ `command -v "${required_command}" >/dev/null 2>&1 ; echo $?` -gt 0 ] ; then
            missing_commands+=( $required_command )
        fi
    done

    if [ ${#missing_commands[@]} -gt 0 ] ; then
        >&2 printf "\n${_red_}Fatal:${_default_} missing command(s): ${missing_commands[@]}\n"
        exit 1
    fi
}

__check_versions__() {
    # @todo: compare versions ? (sort -V)
    local -A expected
    local -A comparisons
    local software status mismatches=0 regexp="\([0-9]\+\.[0-9]\+\(\.[0-9]\+\)\{0,1\}\)"

    expected['bash']="4.4"
    expected['curl']="7.58"
    expected['docker']="20.10"
    expected['grep']="3.1"
    expected['python3']="3.6"
    expected['sed']="4.4"

    local -A versions
    versions['bash']="`bash --version | grep --color=never "bash" -m 1 | sed "s/^.* ${regexp}.*$/\1/g"`"
    versions['curl']="`curl --version | grep --color=never "curl" -m 1 | sed "s/^.*curl ${regexp}.*$/\1/g"`"
    versions['docker']="`docker --version | sed "s/^.*version ${regexp}.*$/\1/g"`"
    versions['grep']="`grep --version | grep --color=never -m 1 "grep" | sed "s/^.* ${regexp}.*$/\1/g"`"
    versions['python3']="`python3 --version 2>&1 | sed "s/^.* ${regexp}.*$/\1/g"`"
    versions['sed']="`sed --version | grep --color=never -m 1 "sed" | sed "s/^.* ${regexp}.*$/\1/g"`"

    for software in "${!expected[@]}"; do
        comparisons[${software}]=`version_compare "${versions[${software}]}" "${expected[${software}]}"`
    done

    for software in "${!expected[@]}"; do
        if [ ${comparisons[$software]} -lt 0 ] ; then
            >&2 printf "${_red_}${_cross_}${_default_} ${software} ${versions[${software}]} (expected at least ${expected[${software}]})\n"
            mismatches=$((mismatches+1))
        else
            printf "${_green_}${_check_}${_default_} ${software} ${versions[${software}]} (expected at least ${expected[${software}]})\n"
        fi
    done

    # @info Matomo version 4.2.1, check __setup_matomo__
    local MATOMO_VERSION="`grep "image.*matomo:" docker-compose.yml | sed 's/^.*matomo:\([0-9\.]\+\).*$/\1/g'`"
    if [ "${MATOMO_VERSION}" == "${MATOMO_EXPECTED_VERSION}" ] ; then
        log_icon_check "matomo ${MATOMO_VERSION} (expected ${MATOMO_EXPECTED_VERSION} for the function __setup_matomo__)"
    elif [ "${IGNORE_MATOMO_VERSION}" == "1" ] ; then
            log_warning "matomo ${MATOMO_VERSION} (expected ${MATOMO_EXPECTED_VERSION} for the function __setup_matomo__)"
    else
        mismatches=$((mismatches+1))
        log_icon_cross "matomo ${MATOMO_VERSION} (expected ${MATOMO_EXPECTED_VERSION} for the function __setup_matomo__)"
    fi

    if [ ${mismatches} -gt 0 ] ; then
        >&2 printf "\n${_red_}Fatal:${_default_} software versions requirements not met\n"
        exit 1
    fi
}

__check__() {
      log_hr
      echo "Checking environment..."
      log_hr

      ( test -f .env && printf "${_green_}${_check_}${_default_} .env file is present\n" || ( >&2 printf "${_red_}Fatal${_default_} %s\n" "file ${__ROOT__}/.env does not exist" ; exit 1 ) )
      ( test -w .env && printf "${_green_}${_check_}${_default_} .env file is writable\n" || ( >&2 printf "${_red_}Fatal${_default_} %s\n" "file ${__ROOT__}/.env is not writable" ; exit 1 ) )
      ( missing="`comm -23 <(grep -v "^\(#.*\|\s*$\)" .env.dist | sed 's/=.*$//g' | sort) <(grep -v "^\(#.*\|\s*$\)" .env | sed 's/=.*$//g' | sort)`" ; if [ ! -z "${missing}" ]; then >&2 printf "${_red_}Fatal${_default_} missing variables from .env file when comparing to .env.dist: %s\n" "`echo ${missing} | sed 's/\s\+/, /g'`" && exit 1;  fi )
      accepted_arch > /dev/null
      log_success "... checking environment completed\n" "OK"

      log_hr
      echo "Checking required softwares..."
      log_hr
      __check_commands__
      __check_versions__
      log_success "... checking required softwares completed\n" "OK"
}

__reset__()
{
      log_hr
      echo "Resetting..."
      log_hr
      docker compose \
          -f docker-compose.yml \
          down \
          --remove-orphans \
          --volumes
      rm -rf /data/iparapheur
      mkdir -m 777 -p /data/iparapheur/{alfresco,matomo/{config,plugins},postgres,pes-viewer/pesPJ,solr/{contentstore,data},transfer/data,vault/data}
      touch /data/iparapheur/{alfresco,matomo/{config,plugins},pes-viewer/pesPJ,transfer}/.gitkeep
      chmod -R 0777 /data/iparapheur

      log_success "... resetting completed\n" "OK"
}

__setup_vault__()
{
      log_hr
      echo "Vault - setup..."
      log_hr

      docker compose \
          --file docker-compose.yml \
          up -d vault
      sleep ${SLEEP_VALUE}
      VAULT_OUTPUT="`docker exec -it ${COMPOSE_PROJECT_NAME}-vault-1 vault operator init -key-shares=1 -key-threshold=1`"
      export VAULT_UNSEAL_KEY="`echo "${VAULT_OUTPUT}" | grep --color=never "Unseal Key 1:" | sed "s/Unseal Key 1: //g" | sed 's/\x1b\[[0-9;]*m//g' | sed "s/\s\+//g"`"
      export VAULT_TOKEN="`echo "${VAULT_OUTPUT}" | grep --color=never "Initial Root Token:" | sed "s/Initial Root Token: //g" | sed 's/\x1b\[[0-9;]*m//g' | sed "s/\s\+//g"`"
      sed -i "s#VAULT_UNSEAL_KEY=.*#VAULT_UNSEAL_KEY=${VAULT_UNSEAL_KEY}#g" .env
      sed -i "s#VAULT_TOKEN=.*#VAULT_TOKEN=${VAULT_TOKEN}#g" .env
      docker exec -it ${COMPOSE_PROJECT_NAME}-vault-1 vault operator unseal ${VAULT_UNSEAL_KEY}
      docker exec -it ${COMPOSE_PROJECT_NAME}-vault-1 vault login token=${VAULT_TOKEN}
      docker exec -it ${COMPOSE_PROJECT_NAME}-vault-1 vault secrets enable -version=2 -path=secret kv

      log_success "... Vault - setup completed\n" "OK"
}

curl_get() {
    local url="${1}"
    local output="`curl -b ${MATOMO_COOKIES} -c ${MATOMO_COOKIES} -s -o "${MATOMO_TMP_HTML}" -L -w "%{http_code} %{url_effective}\n" -L -X GET "${url}"`"

    if [[ "${output}" =~ ^2[0-9][0-9] ]] ; then
        printf "${_green_}${_check_}${_default_} %s\n" "${output}"
    else
        >&2 printf "${_red_}${_cross_}${_default_} %s\n" "${output}"
        exit 1
    fi
}

curl_post() {
    local url="${1}"
    local data="${2}"
    local output="`curl -b ${MATOMO_COOKIES} -c ${MATOMO_COOKIES} -s -o "${MATOMO_TMP_HTML}" -L -w "%{http_code} %{url_effective}\n" -L -X POST "${url}" --data "${data}"`"

    if [[ "${output}" =~ ^2[0-9][0-9] ]] ; then
        printf "${_green_}${_check_}${_default_} %s\n" "${output}"
    else
        >&2 printf "${_red_}${_cross_}${_default_} %s\n" "${output}"
        exit 1
    fi
}

# @info Matomo version 4.2.1
__setup_matomo__()
{
    export_dot_env

    log_hr
    echo "Matomo - setup..."
    log_hr

    docker compose \
        --file docker-compose.yml \
        --file docker-compose.override.init.yml \
        up -d matomo nginx
    sleep ${SLEEP_VALUE}
    rm -f $MATOMO_COOKIES
    curl_get "${MATOMO_URL}"
    curl_get "${MATOMO_URL}index.php?action=systemCheck"
    curl_get "${MATOMO_URL}index.php?action=databaseSetup"
    curl_post "${MATOMO_URL}index.php?action=databaseSetup" "type=${MATOMO_DB_TYPE}&host=${MATOMO_DB_HOST}&username=`urlencode ${MATOMO_DB_USER}`&password=`urlencode ${MATOMO_DB_PASSWORD}`&dbname=`urlencode ${MATOMO_DB_DATABASE}`&tables_prefix=${MATOMO_TABLES_PREFIX}&adapter=`urlencode "PDO\MYSQL"`&submit=`urlencode "Next »"`"
    curl_get "${MATOMO_URL}index.php?action=setupSuperUser&module=Installation"
    curl_post "${MATOMO_URL}index.php?action=setupSuperUser&module=Installation" "login=${MATOMO_DB_ROOT_USER}&password=`urlencode ${MATOMO_DB_ROOT_PASSWORD}`&password_bis=`urlencode ${MATOMO_DB_ROOT_PASSWORD}`&email=`urlencode ${MATOMO_DB_ROOT_EMAIL}`&submit=`urlencode "Next »"`"
    curl_post "${MATOMO_URL}index.php?action=firstWebsiteSetup&module=Installation" "siteName=`urlencode "${MATOMO_SITE_NAME}"`&url=`urlencode "https://${APPLICATION_HOST}"`&timezone=`urlencode ${MATOMO_SITE_TIMEZONE}`&ecommerce=0&submit=`urlencode "Next »"`"
    curl_get "${MATOMO_URL}index.php?action=finished&module=Installation&site_idSite=${MATOMO_SITE_ID}&site_name=`urlencode "${MATOMO_SITE_NAME}"`"
    curl_post "${MATOMO_URL}index.php?action=finished&module=Installation&site_idSite=${MATOMO_SITE_ID}&site_name=`urlencode "${MATOMO_SITE_NAME}"`" "submit=`urlencode "Continue to Matomo »"`"
    log_success "... Matomo - setup completed\n" "OK"

    log_hr
    echo "Matomo - create token..."
    log_hr

    rm -f $MATOMO_COOKIES
    MATOMO_DATE_URL="`date "+%Y-%m-%d"`"
    curl_get "${MATOMO_URL}"
    form_nonce=`grep -m 1 "form_nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'`
    curl_post "${MATOMO_URL}index.php?module=Login" "form_login=${MATOMO_DB_ROOT_USER}&form_nonce=${form_nonce}&form_redirect=`urlencode "${MATOMO_URL}"`&form_password=`urlencode "${MATOMO_DB_ROOT_PASSWORD}"`"
    curl_get "${MATOMO_URL}?module=UsersManager&action=addNewToken&idSite=${MATOMO_SITE_ID}&period=day&date=${MATOMO_DATE_URL}"
    nonce=`grep -m 1 "nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'`
    curl_post "${MATOMO_URL}index.php?module=Login&action=confirmPassword&idSite=${MATOMO_SITE_ID}&period=day&date=${MATOMO_DATE_URL}" "nonce=${nonce}&password=`urlencode "${MATOMO_DB_ROOT_PASSWORD}"`"
    nonce=`grep -m 1 "nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'`
    curl_post "${MATOMO_URL}index.php?module=UsersManager&action=addNewToken&idSite=${MATOMO_SITE_ID}&period=day&date=${MATOMO_DATE_URL}" "description=${MATOMO_TOKEN_NAME}&nonce=${nonce}"
    export MATOMO_TOKEN="`grep "<code>" "${MATOMO_TMP_HTML}" | sed 's/^.*<code>\([^<]*\)<.*$/\1/g'`"
    sed -i "s#MATOMO_TOKEN=.*#MATOMO_TOKEN=${MATOMO_TOKEN}#g" .env
    log_success "... Matomo - create token completed\n" "OK"
}

__karate_tags__() {
    local path="${1}"
    find "${path}" \
          -type f \
          -iname *.feature \
          -exec grep "^\s*@" {} \; \
          | sed 's/\(^\s*\|\s*$\)//g' \
          | sed 's/\s\+/\n/g' \
          | sort \
          | uniq
    printf "\n"
}

# ----------------------------------------------------------------------------------------------------------------------
# Main function
# ----------------------------------------------------------------------------------------------------------------------

__main__()
{
      cd ${__ROOT__}
      opts=`getopt --longoptions force,ignore-matomo-version,ignore-override-compose,dont-start-app,help,sleep:,xtrace -- fhs:x "${@}"` || ( >&2 __usage__ ; exit 1 )
      eval set -- "$opts"
      while true ; do
          case "${1}" in
              -f|--force)
                  FORCE="1"
                  shift
              ;;
              --ignore-matomo-version)
                  IGNORE_MATOMO_VERSION="1"
                  shift
              ;;
              --ignore-override-compose)
                  OVERRIDE_COMPOSE_FILE="0"
                  shift
              ;;
              --dont-start-app)
                  START_APP="0"
                  shift
              ;;
              -h|--help)
                  __usage__
                  exit 0
              ;;
              -x|--xtrace)
                  shift
              ;;
            -s|--sleep)
                  SLEEP_VALUE="${2}"
                  shift 2
              ;;
              --)
                  shift
                  break
              ;;
              *)
                  >&2 __usage__
                  exit 1
              ;;
          esac
      done

      while true ; do
          case "${1:-}" in
              check)
                  __check__
                  exit 0
              ;;
              setup)
                  if [ ${FORCE} -ne 1 ] ; then
                      >&2 __usage__
                      >&2 printf "\n"
                      log_error "Use -f or --force to proceed with the script" "Fatal:"
                      exit 1
                  fi

                  __check__
                  export_dot_env
                  __reset__
                  ENV_BACKUP=".env.backup.`date +'%s'`"
                  log_info "Copying .env to ${ENV_BACKUP}"
                  cp .env "${ENV_BACKUP}"
                  __setup_vault__
                  __setup_matomo__
                  export_dot_env
                  docker compose down --volumes --remove-orphans
                  chmod -R 0777 /data/iparapheur
                  if [ "${START_APP}" == "1" ] ; then
                    if [ "${OVERRIDE_COMPOSE_FILE}" == "1" ] ; then
                      docker compose \
                      --file docker-compose.yml \
                      --file docker-compose.override.dev-`accepted_arch`.yml \
                      up
                    else
                      docker compose \
                      --file docker-compose.yml \
                      up
                    fi
                  fi
                  exit 0
              ;;
              karate-tags)
                  __karate_tags__ "${2:-./${KARATE_DEFAULT_TAGS_PATH}}"
                  exit 0
              ;;
              --)
                  shift
                  break
              ;;
              *)
                  >&2 __usage__
                  exit 1
              ;;
          esac
      done
}

__main__ "${@}"
