#!/usr/bin/env bash

# ----------------------------------------------------------------------------------------------------------------------
# "Bootstrap"
# ----------------------------------------------------------------------------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail

# Use xtrace ?
if [ "`getopt --longoptions xtrace -- x "$@" 2> /dev/null | grep --color=none "\(^\|\s\)\(\-x\|\-\-xtrace\)\($\|\s\)"`" != "" ] ; then
    declare -r __XTRACE__=1
    set -o xtrace
else
    declare -r __XTRACE__=0
fi

# Don't do anything unless forced to
FORCE="0"

# Security problems ahead with .env export... which is why it's a dev script
export_dot_env() {
#    export $(grep -v "^\(#.*\|\s*$\)" .env | xargs)
    set -a; . .env; set +a
}

export_dot_env

MATOMO_COOKIES="${MATOMO_COOKIES:-/tmp/matomo-setup-cookies.txt}"
MATOMO_DB_HOST="${MATOMO_DB_HOST:-matomo-db}"
MATOMO_DB_HOST="${MATOMO_DB_HOST:-matomo-db}"
MATOMO_DB_TYPE="${MATOMO_DB_TYPE:-InnoDB}"
MATOMO_DB_ROOT_EMAIL="${MATOMO_DB_ROOT_EMAIL:-admin@dom.local}"
MATOMO_DB_ROOT_USER="${MATOMO_DB_ROOT_USER:-admin}"
MATOMO_SITE_ID="${MATOMO_SITE_ID:-1}"
MATOMO_SITE_NAME="${MATOMO_SITE_NAME:-i-Parapheur - Général}"
MATOMO_SITE_TIMEZONE="${MATOMO_SITE_TIMEZONE:-Europe/Paris}"
MATOMO_TABLES_PREFIX="${MATOMO_TABLES_PREFIX:-matomo_}"
MATOMO_TOKEN_NAME="${MATOMO_TOKEN_NAME:-ipcore}"
MATOMO_TMP_HTML="${MATOMO_TMP_HTML:-/tmp/matomo-setup-tmp.html}"
MATOMO_URL="${MATOMO_URL:-http://${APPLICATION_HOST}/matomo/}"
SLEEP_VALUE="${SLEEP_VALUE:-30s}"

# ----------------------------------------------------------------------------------------------------------------------
# "Library"
# ----------------------------------------------------------------------------------------------------------------------

# Internal constants

declare -r _blue_="\e[34m"
declare -r _cyan_="\e[36m"
declare -r _default_="\e[0m"
declare -r _green_="\e[32m"
declare -r _red_="\e[31m"

declare -r _check_="\xE2\x9C\x94"
declare -r _cross_="\xE2\x9D\x8C"

declare -r __PID__="${$}"

declare -r __FILE__="$(realpath "${0}")"
declare -r __SCRIPT__="$(basename "${__FILE__}")"
declare -r __ROOT__="$(realpath "$(dirname "${__FILE__}")")"

printf "${_cyan_}Startup:${_default_} started process ${__PID__}\n\n"

# Error and exit handling: exit is trapped, as well as signals.
# If a __cleanup__ function exists, it will be called on signal or exit and the exit code will be passed as parameter.

__trap_signals__()
{
    local code="${?}"
    if [ ${code} -ne 0 ] ; then
        local signal=$((${code} - 128))
        local name="`kill -l ${signal}`"

        >&2 printf "\nProcess ${__PID__} received SIG${name} (${signal}), exiting..."
    fi
}

__trap_exit__()
{
    local code="${?}"

    if [ ${code} -eq 0 ] ; then
        printf "\n${_green_}Success:${_default_} process ${__PID__} exited normally\n"
    else
        >&2 printf "\n${_red_}Error:${_default_} process ${__PID__} exited with error code ${code}\n"
    fi

    if [ "`type -t __cleanup__`" = "function" ] ; then
        __cleanup__
    fi
}

trap "__trap_signals__" SIGHUP SIGINT SIGQUIT SIGTERM
trap "__trap_exit__" EXIT

# ----------------------------------------------------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------------------------------------------------

__usage__()
{
    local warning="${_red_}Warning!${_default_}"

    printf "NAME\n"
    printf "  %s\n" "${__SCRIPT__}"
    printf "\nDESCRIPTION\n"
    printf "  ${warning} Destroys and re-creates a working working i-Parapheur v. 5 development environment\n"
    printf "  ${warning} Uses sudo to destroy and recreate ./data dir.\n"
    printf "  ${warning} Reads and exports values from the .env file\n"
    printf "  ${warning} Replaces values (MATOMO_TOKEN, VAULT_TOKEN, VAULT_UNSEAL_KEY) in the .env file and exports them\n"
    printf "  Look at the top of the file for some extra variables (that can be passed as environment variables)\n"
    printf "  It should detect a linux or macos environment and use specific override-dev according to arch\n"
    printf "\nSYNOPSIS\n"
    printf "  %s [OPTION]\n" "${__SCRIPT__}"
    printf "\nOPTIONS\n"
    printf "  -f|--force\tYou have to use this option for the script to work\n"
    printf "  -h|--help\tDisplay this help\n"
    printf "  -s|--sleep\tThe sleep amount to wait for the vault container or the matomo containers to properly start up (default: 30s)\n"
    printf "  -x|--xtrace\tDebug mode, prints every command before executing it (set -o xtrace)\n"
    printf "\nEXEMPLES\n"
    printf "  %s --force\n" "${__SCRIPT__}"
    printf "  %s --force --sleep 30s\n" "${__SCRIPT__}"
    printf "  %s --help\n" "${__SCRIPT__}"
}

urlencode () {
    local string="${1}"
    python3 -c "exec(\"import sys\nfrom urllib.parse import quote_plus\nprint(quote_plus(sys.argv[1]))\")" "${string}"
}

# @see https://stackoverflow.com/a/3466183
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
    required_commands=(bash curl docker docker-compose grep java python3 sed)
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
    expected['docker-compose']="1.27"
    expected['grep']="3.1"
    expected['java']="11.0"
    expected['python3']="3.6"
    expected['sed']="4.4"

    local -A versions
    versions['bash']="`bash --version | grep --color=never "bash" -m 1 | sed "s/^.* ${regexp}.*$/\1/g"`"
    versions['curl']="`curl --version | grep --color=never "curl" -m 1 | sed "s/^.*curl ${regexp}.*$/\1/g"`"
    versions['docker']="`docker --version | sed "s/^.*version ${regexp}.*$/\1/g"`"
    versions['docker-compose']="`docker-compose --version | sed "s/^.*version ${regexp}.*$/\1/g"`"
    versions['grep']="`grep --version | grep --color=never -m 1 "grep" | sed "s/^.* ${regexp}.*$/\1/g"`"
    versions['java']="`java -version 2>&1 | grep --color=never -m 1 "version" | sed "s/^.*\\"${regexp}\\".*$/\1/g"`"
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

    if [ ${mismatches} -gt 0 ] ; then
        >&2 printf "\n${_red_}Fatal:${_default_} software versions requirements not met\n"
        exit 1
    fi
}

__check__() {
    ( \
        echo "--------------------------------------------------------------------------------" \
        && echo "Checking environment" \
        && echo "--------------------------------------------------------------------------------" \
        && ( test -f .env && printf "${_green_}${_check_}${_default_} .env file is present\n" || ( >&2 printf "${_red_}Fatal${_default_} %s\n" "file ${__ROOT__}/.env does not exist" ; exit 1 ) ) \
        && ( test -w .env && printf "${_green_}${_check_}${_default_} .env file is writable\n" || ( >&2 printf "${_red_}Fatal${_default_} %s\n" "file ${__ROOT__}/.env is not writable" ; exit 1 ) ) \
        && ( missing="`comm -23 <(grep -v "^\(#.*\|\s*$\)" .env.dist | sed 's/=.*$//g' | sort) <(grep -v "^\(#.*\|\s*$\)" .env | sed 's/=.*$//g' | sort)`" ; if [ ! -z "${missing}" ]; then >&2 printf "${_red_}Fatal${_default_} missing variables from .env file when comparing to .env.dist: %s\n" "`echo ${missing} | sed 's/\s\+/, /g'`" && exit 1;  fi ) \
        && accepted_arch > /dev/null \
        && __check_commands__ \
        && __check_versions__ \
    )

    EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ] ; then
        printf "\n${_green_}OK${_default_} Checking environment completed\n"
    fi
    return $EXIT_STATUS
}

__reset__()
{
    ( \
        echo "--------------------------------------------------------------------------------" \
        && echo "Reset" \
        && echo "--------------------------------------------------------------------------------" \
        && docker-compose \
            -f docker-compose.yml \
            -f docker-compose.override.dev-`accepted_arch`.yml \
            down \
            --remove-orphans \
            --volumes \
        && sudo rm -rf ./data \
        && mkdir -m 757 -p ./data/{alfresco,matomo/{config,plugins},postgres,solr/{data,contentstore},vault/data} \
        && touch ./data/.gitkeep \
        && chmod -R 0757 ./data
    )

    EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ] ; then
        printf "\n${_green_}OK${_default_} Reset completed\n"
    fi
    return $EXIT_STATUS

}

__setup_vault__()
{
    ( \
        echo "--------------------------------------------------------------------------------" \
        && echo "Vault - setup" \
        && echo "--------------------------------------------------------------------------------" \
        && docker-compose up -d vault \
        && sleep ${SLEEP_VALUE} \
        && VAULT_OUTPUT="`docker exec -it compose_vault_1 vault operator init -key-shares=1 -key-threshold=1`" \
        && export VAULT_UNSEAL_KEY="`echo "$VAULT_OUTPUT" | grep --color=never "Unseal Key 1:" | sed "s/Unseal Key 1: //g" | sed 's/\x1b\[[0-9;]*m//g' | sed "s/\s\+//g"`" \
        && export VAULT_TOKEN="`echo "$VAULT_OUTPUT" | grep --color=never "Initial Root Token:" | sed "s/Initial Root Token: //g" | sed 's/\x1b\[[0-9;]*m//g' | sed "s/\s\+//g"`" \
        && sed -i "s#VAULT_UNSEAL_KEY=.*#VAULT_UNSEAL_KEY=${VAULT_UNSEAL_KEY}#g" .env \
        && sed -i "s#VAULT_TOKEN=.*#VAULT_TOKEN=${VAULT_TOKEN}#g" .env \
        && docker exec -it compose_vault_1 vault operator unseal ${VAULT_UNSEAL_KEY} \
        && docker exec -it compose_vault_1 vault login token=${VAULT_TOKEN} \
        && docker exec -it compose_vault_1 vault secrets enable -version=2 -path=secret kv
    )

    EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ] ; then
        printf "\n${_green_}OK${_default_} Vault - setup completed\n"
    fi
    return $EXIT_STATUS
}

curl_get() {
    local url="${1}"
    local output="`curl -b ${MATOMO_COOKIES} -c ${MATOMO_COOKIES} -s -o "${MATOMO_TMP_HTML}" -L -w "%{http_code} %{url_effective}\n" -L -X GET "${url}"`"

    if [[ "${output}" =~ ^2[0-9][0-9] ]] ; then
        printf "\t${_green_}OK${_default_} %s\n" "${output}"
    else
        >&2 printf "\t${_red_}KO${_default_} %s\n" "${output}"
        exit 1
    fi
}

curl_post() {
    local url="${1}"
    local data="${2}"
    local output="`curl -b ${MATOMO_COOKIES} -c ${MATOMO_COOKIES} -s -o "${MATOMO_TMP_HTML}" -L -w "%{http_code} %{url_effective}\n" -L -X POST "${url}" --data "${data}"`"

    if [[ "${output}" =~ ^2[0-9][0-9] ]] ; then
        printf "\t${_green_}OK${_default_} %s\n" "${output}"
    else
        >&2 printf "\t${_red_}KO${_default_} %s\n" "${output}"
        exit 1
    fi
}

__setup_matomo__()
{
    # @fixme: Matomo version (currently, 4.2.1 is working)
    ( \
        export_dot_env \
        && echo "--------------------------------------------------------------------------------" \
        && echo "Matomo - setup" \
        && echo "--------------------------------------------------------------------------------" \
        && docker-compose up -d matomo nginx \
        && sleep ${SLEEP_VALUE} \
        && rm -f $MATOMO_COOKIES \
        && curl_get "${MATOMO_URL}" \
        && curl_get "${MATOMO_URL}index.php?action=systemCheck" \
        && curl_get "${MATOMO_URL}index.php?action=databaseSetup" \
        && curl_post "${MATOMO_URL}index.php?action=databaseSetup" "type=${MATOMO_DB_TYPE}&host=${MATOMO_DB_HOST}&username=`urlencode ${MATOMO_DB_USER}`&password=`urlencode ${MATOMO_DB_PASSWORD}`&dbname=`urlencode ${MATOMO_DB_DATABASE}`&tables_prefix=${MATOMO_TABLES_PREFIX}&adapter=`urlencode "PDO\MYSQL"`&submit=`urlencode "Next »"`" \
        && curl_get "${MATOMO_URL}index.php?action=setupSuperUser&module=Installation" \
        && curl_post "${MATOMO_URL}index.php?action=setupSuperUser&module=Installation" "login=${MATOMO_DB_ROOT_USER}&password=`urlencode ${MATOMO_DB_ROOT_PASSWORD}`&password_bis=`urlencode ${MATOMO_DB_ROOT_PASSWORD}`&email=`urlencode ${MATOMO_DB_ROOT_EMAIL}`&submit=`urlencode "Next »"`" \
        && curl_post "${MATOMO_URL}index.php?action=firstWebsiteSetup&module=Installation" "siteName=`urlencode "${MATOMO_SITE_NAME}"`&url=`urlencode "https://${APPLICATION_HOST}"`&timezone=`urlencode ${MATOMO_SITE_TIMEZONE}`&ecommerce=0&submit=`urlencode "Next »"`" \
        && curl_get "${MATOMO_URL}index.php?action=finished&module=Installation&site_idSite=${MATOMO_SITE_ID}&site_name=`urlencode "${MATOMO_SITE_NAME}"`" \
        && curl_post "${MATOMO_URL}index.php?action=finished&module=Installation&site_idSite=${MATOMO_SITE_ID}&site_name=`urlencode "${MATOMO_SITE_NAME}"`" "submit=`urlencode "Continue to Matomo »"`" \
        && echo "--------------------------------------------------------------------------------" \
        && echo "Matomo - create token" \
        && echo "--------------------------------------------------------------------------------" \
        && rm -f $MATOMO_COOKIES \
        && MATOMO_DATE_URL="`date "+%Y-%m-%d"`" \
        && curl_get "${MATOMO_URL}" \
        && form_nonce=`grep -m 1 "form_nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'` \
        && curl_post "${MATOMO_URL}index.php?module=Login" "form_login=${MATOMO_DB_ROOT_USER}&form_nonce=${form_nonce}&form_redirect=`urlencode "${MATOMO_URL}"`&form_password=`urlencode "${MATOMO_DB_ROOT_PASSWORD}"`" \
        && curl_get "${MATOMO_URL}?module=UsersManager&action=addNewToken&idSite=${MATOMO_SITE_ID}&period=day&date=${MATOMO_DATE_URL}" \
        && nonce=`grep -m 1 "nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'` \
        && curl_post "${MATOMO_URL}index.php?module=Login&action=confirmPassword&idSite=${MATOMO_SITE_ID}&period=day&date=${MATOMO_DATE_URL}" "nonce=${nonce}&password=`urlencode "${MATOMO_DB_ROOT_PASSWORD}"`" \
        && nonce=`grep -m 1 "nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'` \
        && curl_post "${MATOMO_URL}index.php?module=UsersManager&action=addNewToken&idSite=${MATOMO_SITE_ID}&period=day&date=${MATOMO_DATE_URL}" "description=${MATOMO_TOKEN_NAME}&nonce=${nonce}" \
        && export MATOMO_TOKEN="`grep "<code>" "${MATOMO_TMP_HTML}" | sed 's/^.*<code>\([^<]*\)<.*$/\1/g'`" \
        && sed -i "s#MATOMO_TOKEN=.*#MATOMO_TOKEN=${MATOMO_TOKEN}#g" .env
    )

    EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ] ; then
        printf "\n${_green_}OK${_default_} Matomo - setup completed\n"
    fi
    return $EXIT_STATUS
}

# ----------------------------------------------------------------------------------------------------------------------
# Main function
# ----------------------------------------------------------------------------------------------------------------------

__main__()
{
    (
        cd ${__ROOT__}
        opts=`getopt --longoptions force,help,sleep:,xtrace -- fhs:x "${@}"` || ( >&2 __usage__ ; exit 1 )
        eval set -- "$opts"
        while true ; do
            case "${1}" in
                -f|--force)
                    FORCE="1"
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

        if [ ${FORCE} -ne 1 ] ; then
            >&2 __usage__
            >&2 echo "Use -f or --force to proceed the script"
            exit 1
        fi

        __check__ \
        && export_dot_env \
        && __reset__ \
        && __setup_vault__ \
        && __setup_matomo__ \
        && export_dot_env \
        && docker-compose down \
        && sudo chmod -R 0757 ./data \
        && docker-compose \
            -f docker-compose.yml \
            -f docker-compose.override.dev-`accepted_arch`.yml \
            up \
        && exit 0
    )
}

__main__ "${@}"
