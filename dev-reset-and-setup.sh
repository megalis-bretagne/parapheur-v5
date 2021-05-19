#!/usr/bin/env bash

FORCE="0"

# @todo Matomo - setup: 200 http://iparapheur.dom.local/matomo/
# @todo: configurable sleep
# @todo (IIF linux/macos): -f docker-compose.override.dev-macos.yml \
  # @see https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux

MATOMO_URL="http://iparapheur.dom.local/matomo/"
MATOMO_COOKIES=/tmp/matomo-setup-cookies.txt
MATOMO_TMP_HTML=/tmp/matomo-setup-tmp.html

# ----------------------------------------------------------------------------------------------------------------------
# "Library"
# ----------------------------------------------------------------------------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail

# Internal constants

declare -r _blue_="\e[34m"
declare -r _cyan_="\e[36m"
declare -r _default_="\e[0m"
declare -r _green_="\e[32m"
declare -r _red_="\e[31m"

# Bootstrap

if [ "`getopt --longoptions xtrace -- x "$@" 2> /dev/null | grep --color=none "\(^\|\s\)\(\-x\|\-\-xtrace\)\($\|\s\)"`" != "" ] ; then
    declare -r __XTRACE__=1
    set -o xtrace
else
    declare -r __XTRACE__=0
fi

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
    printf "NAME\n"
    printf "  %s\n" "${__SCRIPT__}"
    printf "\nDESCRIPTION\n"
    printf "  ...\n"
    printf "\nSYNOPSIS\n"
    printf "  %s [OPTION]\n" "${__SCRIPT__}"
    printf "\nOPTIONS\n"
    printf "  -f|--force\t...\n"
    printf "  -h|--help\tAffiche cette aide\n"
    printf "  -x|--xtrace\tMode debug, affiche chaque commande avant de l'exécuter (set -o xtrace)\n"
    printf "\nEXEMPLES\n"
    printf "  %s --force\n" "${__SCRIPT__}"
    printf "  %s --help\n" "${__SCRIPT__}"
}

__reset__()
{
    ( \
        echo "--------------------------------------------------------------------------------" \
        && echo "Reset" \
        && echo "--------------------------------------------------------------------------------" \
        && docker-compose \
            -f docker-compose.yml \
            -f docker-compose.override.dev-linux.yml \
            -f docker-compose.override.dev-linux.yml \
            down -v \
        && sudo rm -rf ./data \
        && mkdir -m 757 -p ./data/{alfresco,matomo/{config,plugins},postgres,solr/{data,contentstore},vault/data} \
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
        && sleep 30s \
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
    ( \
        export $(grep -v "^\(#.*\|\s*$\)" .env | xargs) \
        && echo "--------------------------------------------------------------------------------" \
        && echo "Matomo - setup" \
        && echo "--------------------------------------------------------------------------------" \
        && docker-compose up -d matomo nginx \
        && sleep 30s \
        && rm -f $MATOMO_COOKIES \
        && curl_get "${MATOMO_URL}" \
        && curl_get "${MATOMO_URL}index.php?action=systemCheck" \
        && curl_get "${MATOMO_URL}index.php?action=databaseSetup" \
        && curl_post "${MATOMO_URL}index.php?action=databaseSetup" "type=InnoDB&host=matomo-db&username=matomo&password=matomo&dbname=matomo&tables_prefix=matomo_&adapter=PDO%5CMYSQL&submit=Next+%C2%BB" \
        && curl_get "${MATOMO_URL}index.php?action=setupSuperUser&module=Installation" \
        && curl_post "${MATOMO_URL}index.php?action=setupSuperUser&module=Installation" "login=admin&password=libriciel2k18&password_bis=libriciel2k18&email=admin%40dom.local&submit=Next+%C2%BB" \
        && curl_post "${MATOMO_URL}index.php?action=firstWebsiteSetup&module=Installation" "siteName=i-Parapheur+-+G%C3%A9n%C3%A9ral&url=https%3A%2F%2Fiparapheur.dom.local&timezone=Europe%2FParis&ecommerce=0&submit=Next+%C2%BB" \
        && curl_get "${MATOMO_URL}index.php?action=finished&module=Installation&site_idSite=1&site_name=i-Parapheur+-+G%C3%A9n%C3%A9ral" \
        && curl_post "${MATOMO_URL}index.php?action=finished&module=Installation&site_idSite=1&site_name=i-Parapheur+-+G%C3%A9n%C3%A9ral" "submit=Continue+to+Matomo+%C2%BB" \
        && echo "--------------------------------------------------------------------------------" \
        && echo "Matomo - create token" \
        && echo "--------------------------------------------------------------------------------" \
        && rm -f $MATOMO_COOKIES \
        && MATOMO_DATE_URL="`date "+%Y-%m-%d"`" \
        && curl_get "${MATOMO_URL}" \
        && form_nonce=`grep -m 1 "form_nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'` \
        && curl_post "${MATOMO_URL}index.php?module=Login" "form_login=admin&form_nonce=${form_nonce}&form_redirect=http%3A%2F%2Fiparapheur.dom.local%2Fmatomo%2F&form_password=libriciel2k18" \
        && curl_get "${MATOMO_URL}?module=UsersManager&action=addNewToken&idSite=1&period=day&date=${MATOMO_DATE_URL}" \
        && nonce=`grep -m 1 "nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'` \
        && curl_post "${MATOMO_URL}index.php?module=Login&action=confirmPassword&idSite=1&period=day&date=${MATOMO_DATE_URL}" "nonce=${nonce}&password=libriciel2k18" \
        && nonce=`grep -m 1 "nonce" "${MATOMO_TMP_HTML}" | sed 's/^.*value="\([^"]*\)".*$/\1/g'` \
        && curl_post "${MATOMO_URL}index.php?module=UsersManager&action=addNewToken&idSite=1&period=day&date=${MATOMO_DATE_URL}" "description=ipcore&nonce=${nonce}" \
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
        opts=`getopt --longoptions force,help,xtrace -- fhx "${@}"` || ( >&2 __usage__ ; exit 1 )
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
            >&2 echo "Use -f or --force to proceed with destroying everything then recreating a working i-Parapheur v. 5 development environment"
            exit 1
        fi

        export $(grep -v "^\(#.*\|\s*$\)" .env | xargs) \
        && __reset__ \
        && __setup_vault__ \
        && __setup_matomo__ \
        && export $(grep -v "^\(#.*\|\s*$\)" .env | xargs) \
        && docker-compose down \
        && sudo chmod -R 0757 ./data \
        && docker-compose \
            -f docker-compose.yml \
            -f docker-compose.override.dev-linux.yml \
            up \
        && exit 0
    )
}

__main__ "${@}"
