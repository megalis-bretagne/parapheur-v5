#!/bin/bash

#
# Libriciel Auto-update
# Copyright (C) 2024 Libriciel-SCOP
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
#

set -e

VERSION="1.0.0"

# Lance une mise a jour de patch si une nouvelle version d'un Libriciel est detectee.

# Nom du script (pour les noms de fichier)
SCRIPT_NAME="libricielAutoUpdate"

OPTION_REGEX1="^(--update|--help|--version)$"
OPTION_REGEX2="^(--now)$"

# initScript
HOSTNAME=$(hostname)
TMP_FILE="/tmp/${SCRIPT_NAME}.tmp"

# testCommands
REQUIRED_COMMANDS=("awk" "sed" "grep" "find" "curl" "tail" "sort" "cat" "rm" "hostname" "openssl" "nc" "jq")

# poleLibriciel
# testLibricielFolder
LS_LIST=("webactes" "webdelib" "refae" "versae" "asalae" "webgfc" "comelus" "idelibre" "lsmessage" "pastell" "s2low" "iparapheur")

# compareVersionPatch
LS_VERSION_REGEX="^([0-9]|[0-9][0-9]).([0-9]|[0-9][0-9]).([0-9]|[0-9][0-9])$"

# Log
LOG_DATE="$(date '+%Y-%m-%d')"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
LOG_FILE="/var/log/${SCRIPT_NAME}_${LOG_DATE}.log"

# libricielUpdate
LS_UPDATE_URL="https://nexus.libriciel.fr/repository/ls-raw/public/libriciel/libriciel-update.sh"

# waitingPeriod
# Valeur WAITING_DAYS a definir dans le .env:
# 0 = instances de test
# 7 = instances de prod
# 14 = instances de prod +
# 21 = instances de prod ++
WAITING_PERIOD_REGEX="^([0-9]|[0-9][0-9]|[0-9][0-9][0-9])$"

function randomExec {
    RANDOM7=$((RANDOM % 6))
    RANDOM7200=$((RANDOM % 7199))
    if [[ "${RANDOM7}" == 0 ]]; then
        logInfo "[randomExec] début fonction 🔧" "${LOG_FILE}"
        logInfo "[randomExec] Lancement du script dans ${RANDOM7200} secondes ⏳" "${LOG_FILE}"
        sleep "${RANDOM7200}"
        logInfo "[randomExec] Lancement du script 🚀" "${LOG_FILE}"
    else
        infoNoLog "[randomExec] début fonction 🔧"
        infoNoLog "[randomExec] Le script ne se lancera pas aujourd'hui ❎"
        exit 0
    fi
}

function errNoLog {
    local LOG_MSG="${1}"
    echo -e "\e[31m[ERREUR] ${TIMESTAMP} - ${LOG_MSG}\e[0m"
    exit 254
}

function infoNoLog {
    local LOG_MSG="${1}"
    echo -e "\e[34m[INFO] ${TIMESTAMP} - ${LOG_MSG}\e[0m"
}

function logErr {
    local LOG_MSG="${1}"
    local LOG_FILE="${2}"
    echo -e "\e[31m[ERREUR] ${TIMESTAMP} - ${LOG_MSG}\e[0m" | tee -a "${LOG_FILE}"
    logZip
    exit 255
}

function logInfo {
    local LOG_MSG="${1}"
    local LOG_FILE="${2}"
    echo -e "\e[34m[INFO] ${TIMESTAMP} - ${LOG_MSG}\e[0m" | tee -a "${LOG_FILE}"
}

function logWarn {
    local LOG_MSG="${1}"
    local LOG_FILE="${2}"
    echo -e "\e[1;33m[AVERTISSEMENT] ${TIMESTAMP} - ${LOG_MSG}\e[0m" | tee -a "${LOG_FILE}"
}

function logZip {
    logInfo "[logZip] Début fonction 🔧" "${LOG_FILE}"
    logInfo "[logZip] Archivage des journaux." "${LOG_FILE}"
    gzip "${LOG_FILE}" --suffix -"$(date '+%H%M%S')".gz
}

function testCommands {
    logInfo "[testCommands] Début fonction 🔧" "${LOG_FILE}"
    for REQUIRED_COMMAND in "${REQUIRED_COMMANDS[@]}"; do
        command -v "${REQUIRED_COMMAND}" &> /dev/null || logErr "[testCommands] La commande \"${REQUIRED_COMMAND}\" est introuvable. Arrêt du script ⛔️" "${LOG_FILE}"
    done
}

function testDistLink {
    logInfo "[testDistLink] Début fonction 🔧" "${LOG_FILE}"
    local LS_DIST="${1}"
    if [ ! -L "${LS_DIST}" ] && [ ! -e "${LS_DIST}" ]; then
        logErr "[testDistLink] Le lien symbolique \"${LS_DIST}\" n'existe pas. Arrêt du script ⛔️" "${LOG_FILE}"
    else
        logInfo "[testDistLink] Le lien symbolique \"${LS_DIST}\" existe ✅" "${LOG_FILE}"
    fi
}

function testEnvFile {
    logInfo "[testEnvFile] Début fonction 🔧" "${LOG_FILE}"
    local LS_ENV="${1}"
    if [ ! -e "${LS_ENV}" ]; then
        logErr "[testEnvFile] Le fichier \"${LS_ENV}\" n'existe pas. Arrêt du script ⛔️" "${LOG_FILE}"
    else
        logInfo "[testEnvFile] Le fichier \"${LS_ENV}\" existe ✅" "${LOG_FILE}"
    fi
}

function testUrlHttpReturnCode {
    logInfo "[testUrlHttpReturnCode] Début fonction 🔧" "${LOG_FILE}"
    local TESTED_URL="${1}"
    if [[ "$(curl --connect-timeout 5 --head -s "${TESTED_URL}" | grep HTTP | awk '{print $2}')" != "200" ]]; then
	logErr "[testUrlHttpReturnCode] URL \"${TESTED_URL}\" HS. Arrêt du script ⛔️" "${LOG_FILE}"
    else
        logInfo "[testUrlHttpReturnCode] URL \"${TESTED_URL}\" OK ✅" "${LOG_FILE}"
    fi
}

function testLibricielFolder {
    logInfo "[testLibricielFolder] Début fonction 🔧" "${LOG_FILE}"
    for LIBRICIEL in "${LS_LIST[@]}"; do
        LIBRICIEL=$(find /opt/ -mindepth 1 -maxdepth 1 -type d | grep -w "${LIBRICIEL}" | sed 's#/opt/##')
        if [ -n "${LIBRICIEL}" ] && [ -d "/opt/${LIBRICIEL}" ]; then
            logInfo "[testLibricielFolder] Le libriciel \"${LIBRICIEL}\" est installé et a été détecté automatiquement ✅" "${LOG_FILE}"
            break
        fi
    done
    if [ -z "${LIBRICIEL}" ]; then
        logErr "[testLibricielFolder] Aucun libriciel ne semble installé. Vérifiez le répertoire /opt. Arrêt du script ⛔️" "${LOG_FILE}"
    fi
    # testDistLink
    LS_DIST="/opt/${LIBRICIEL}/dist"
    # testEnvFile
    LS_ENV="/opt/${LIBRICIEL}/current/.env"
}

function testLibricielVersionRegex {
    logInfo "[testLibricielVersionRegex] Début fonction 🔧" "${LOG_FILE}"
    local LIBRICIEL="${1}"
    # compareVersionPatch
    LS_INSTALLED_VERSION=$(readlink /opt/"${LIBRICIEL}"/dist | sed 's#/opt/*.*/dist-##' | sed 's#/##')
    [[ "${LS_INSTALLED_VERSION}" =~ ${LS_VERSION_REGEX} ]] || \
        logErr "[testLibricielVersionRegex] Ce numéro de version installée n'est pas valide : ${LS_INSTALLED_VERSION}. Arrêt du script ⛔️" "${LOG_FILE}"
}

function poleLibriciel {
    logInfo "[poleLibriciel] Début fonction 🔧" "${LOG_FILE}"
    local LIBRICIEL="${1}"
    case "${LIBRICIEL}" in 
        "webactes"|"webdelib")
        LS_POLE="actes"
        logInfo "[poleLibriciel] Le pôle \"${LS_POLE}\" a été trouvé ✅" "${LOG_FILE}"
        ;;
        "refae"|"versae"|"asalae")
        LS_POLE="archivage"
        logInfo "[poleLibriciel] Le pôle \"${LS_POLE}\" a été trouvé ✅" "${LOG_FILE}"
        ;;
        "webgfc"|"comelus"|"idelibre"|"lsmessage")
        LS_POLE="citoyens"
        logInfo "[poleLibriciel] Le pôle \"${LS_POLE}\" a été trouvé ✅" "${LOG_FILE}"
        ;;
        "pastell"|"s2low")
        LS_POLE="plateforme"
        logInfo "[poleLibriciel] Le pôle \"${LS_POLE}\" a été trouvé ✅" "${LOG_FILE}"
        ;;
        "iparapheur")
        LS_POLE="signature"
        logInfo "[poleLibriciel] Le pôle \"${LS_POLE}\" a été trouvé ✅" "${LOG_FILE}"
        ;;
        *)
	logErr "[poleLibriciel] Aucun libriciel ne semble installé. Vérifiez le répertoire /opt. Arrêt du script ⛔️" "${LOG_FILE}"
        ;;
    esac
    LS_URL="https://nexus.libriciel.fr/service/rest/repository/browse/ls-raw/public/${LS_POLE}/${LIBRICIEL}/"
}

function parseJsonFromRepo {
    logInfo "[parseJsonFromRepo] Début fonction 🔧" "${LOG_FILE}"
    echo "1970-01-01T00:00:00.000+00:00 | dummy-output-1.1.1.tar.gz" | tee -a ${TMP_FILE} &> /dev/null
    RETURNED_VALUE=$?
    [[ ${RETURNED_VALUE} -eq 0 ]] || \
        logErr "[parseJsonFromRepo] Problème à la création du fichier temporaire. Arrêt du script ⛔️" "${LOG_FILE}"
    LS_INSTALLED_VERSION_NONPATCH=$(echo "${LS_INSTALLED_VERSION}" | sed -r 's/.[0-9]*$//')
    LS_URL_GLOB="https://nexus.libriciel.fr/service/rest/v1/search/assets?name=public/${LS_POLE}/${LIBRICIEL}/${LIBRICIEL}-${LS_INSTALLED_VERSION_NONPATCH}.*.tar.gz"
    for OCCURRENCE in $(curl -s -X 'GET' -H 'accept: application/json' "${LS_URL_GLOB}" | jq -r '.items[].path'); do
        LS_URL="https://nexus.libriciel.fr/service/rest/v1/search/assets?name=${OCCURRENCE}"
        CURL_REQUESTS=$(curl -s -X 'GET' -H 'accept: application/json' "${LS_URL}" | jq -jr ".items[].lastModified" ; printf " " ; curl -s -X 'GET' -H 'accept: application/json' "${LS_URL}" | jq -jr ".items[].path" ; printf "\n")
        echo "${CURL_REQUESTS}" | tee -a ${TMP_FILE} &> /dev/null
    done

    LS_LAST_VERSION=$(cat ${TMP_FILE} | grep -Evi '(alpha|beta|dev|rc|test)' | grep "${LIBRICIEL}" | sort | tail -n 1 | awk '{print $2}'| sed 's/.*-//' | sed 's/.tar.gz//')
    LS_LAST_TGZ_DATE=$(cat ${TMP_FILE} | grep -Evi '(alpha|beta|dev|rc|test)' | grep "${LIBRICIEL}" | sort | tail -n 1 | awk '{print $1}')
}

function testLibricielOccurrencesInTmpFile {
    logInfo "[testLibricielOccurrencesInTmpFile] Début fonction 🔧" "${LOG_FILE}"
    local TMP_FILE=${1}
    [[ $(grep -c "${LIBRICIEL}" "${TMP_FILE}") -ne "0" ]] || \
        logErr "[testLibricielOccurrencesInTmpFile] Le fichier \"${TMP_FILE}\" ne contient aucune référence à \"${LIBRICIEL}\" Arrêt du script ⛔️" "${LOG_FILE}"
}

function waitingPeriod {
    logInfo "[waitingPeriod] Début fonction 🔧" "${LOG_FILE}"
    UNIX_LAST_TGZ_DATE=$(date +%s -d "${LS_LAST_TGZ_DATE}")
    UNIX_CURRENT_DATE=$(date +%s)
    DAYS_DIFF=$(((UNIX_CURRENT_DATE-UNIX_LAST_TGZ_DATE)/86400))
    WAITING_DAYS=$(< "${LS_ENV}" grep WAITING_DAYS | sed 's/WAITING_DAYS=//')
    [[ "${DAYS_DIFF}" =~ ${WAITING_PERIOD_REGEX} ]] || \
        logErr "[waitingPeriod] Cette différence entre la date du jour et la date du tarball source n'est pas possible : ${DAYS_DIFF}. Arrêt du script ⛔️" "${LOG_FILE}"
    [[ "${WAITING_DAYS}" =~ ${WAITING_PERIOD_REGEX} ]] || \
        logErr "[waitingPeriod] Ce délai de carence n'est pas valide : ${WAITING_DAYS} jours. Arrêt du script ⛔️" "${LOG_FILE}"
    logInfo "[waitingPeriod] La dernière version de ${LIBRICIEL} (version ${LS_LAST_VERSION}) est sortie il y a ${DAYS_DIFF} jours." "${LOG_FILE}"
    if [[ "${DAYS_DIFF}" -ge "${WAITING_DAYS}" ]]; then
        logInfo "[waitingPeriod] Délai de carence dépassé (${WAITING_DAYS} jours)...⌛️ Le script va continuer ⚙️" "${LOG_FILE}"
    else
        logInfo "[waitingPeriod] Délai de carence en cours (${WAITING_DAYS} jours)...⏳ Le script ne va pas continuer ❎" "${LOG_FILE}"
        checkTempFile "${TMP_FILE}"
        logZip
	exit 0
    fi
}

function checkTempFile {
    logInfo "[checkTempFile] Début fonction 🔧" "${LOG_FILE}"
    local TMP_FILE=${1}
    if [ -e "${TMP_FILE}" ]; then
        logInfo "[checkTempFile] Le fichier \"${TMP_FILE}\" existe. Nettoyage..." "${LOG_FILE}"
        rm "${TMP_FILE}" &> /dev/null
        RETURNED_VALUE=$?
        if [ ${RETURNED_VALUE} -ne 0 ]; then
            logErr "[checkTempFile] Le fichier \"${TMP_FILE}\" n'a pas pu être supprimé. Arrêt du script ⛔️" "${LOG_FILE}"
        else
            logInfo "[checkTempFile] Le fichier \"${TMP_FILE}\" a été supprimé 🧹" "${LOG_FILE}"
        fi
        else
            logInfo "[checkTempFile] Le fichier \"${TMP_FILE}\" n'existe pas." "${LOG_FILE}"
    fi
}

function testLastVersionRegex {
    logInfo "[testLastVersionRegex] Début fonction 🔧" "${LOG_FILE}"
    local LS_LAST_VERSION=${1}
    [[ "${LS_LAST_VERSION}" =~ ${LS_VERSION_REGEX} ]] || \
        logErr "[testLastVersionRegex] Ce numéro de version disponible n'est pas valide : ${LS_LAST_VERSION}. Arrêt du script ⛔️" "${LOG_FILE}"
}

function compareVersionPatch {
    [[ "${1}" == "--update" ]] || \
        logErr "[compareVersionPatch] La fonction doit être appelée avec \"--update\", (variable \${OPTION}). Arrêt du script ⛔️" "${LOG_FILE}"
    logInfo "[compareVersionPatch] Début fonction 🔧" "${LOG_FILE}"
    LS_INSTALLED_VERSION_PATCH=$(echo "${LS_INSTALLED_VERSION}" | sed -r 's/([0-9]|[0-9][0-9]).([0-9]|[0-9][0-9]).//')
    LS_LAST_VERSION_PATCH=$(echo "${LS_LAST_VERSION}" | sed -r 's/([0-9]|[0-9][0-9]).([0-9]|[0-9][0-9]).//')
    if [[ ${1} == "--update" ]] && [ "${LS_INSTALLED_VERSION_PATCH}" -lt "${LS_LAST_VERSION_PATCH}" ]; then
        logInfo "[compareVersionPatch] La version ${LS_LAST_VERSION} du libriciel \"${LIBRICIEL}\" va être installée." "${LOG_FILE}"
	libricielUpdate
    elif [[ "${LS_INSTALLED_VERSION_PATCH}" -eq "${LS_LAST_VERSION_PATCH}" ]]; then
	logInfo "[compareVersionPatch] Le libriciel \"${LIBRICIEL}\" est déjà à la version la plus récente disponible. Version ${LS_INSTALLED_VERSION} ✅" "${LOG_FILE}"
    fi
}

function libricielUpdate {
    logInfo "[libricielUpdate] Début fonction 🔧" "${LOG_FILE}"
    logInfo "[libricielUpdate] Exécution du script libriciel-update.sh 💾" "${LOG_FILE}"
    bash <(curl --connect-timeout 5 -s ${LS_UPDATE_URL}) "${LS_LAST_VERSION}" --force &> /dev/null
    RETURNED_VALUE=$?
    if [ ${RETURNED_VALUE} -ne 0 ]; then
        logErr "[libricielUpdate] Le script libriciel-update.sh a eu une erreur. Arrêt du script ⛔️" "${LOG_FILE}"
    else
        LS_NEW_VERSION=$(readlink /opt/"${LIBRICIEL}"/dist | sed 's#/opt/*.*/dist-##' | sed 's#/##')
        [[ "${LS_NEW_VERSION}" =~ ${LS_VERSION_REGEX} ]] || \
            logErr "[libricielUpdate] Ce numéro de version installée n'est pas valide : ${LS_NEW_VERSION}. Arrêt du script ⛔️" "${LOG_FILE}"
    fi
    if [[ "${LS_NEW_VERSION}" == "${LS_LAST_VERSION}" ]]; then
        logInfo "[libricielUpdate] L'instance est à jour ✅." "${LOG_FILE}"
    fi
}

function help {
    infoNoLog "[help] Début fonction 📖"
echo -e "Script d'installation automatique des patches de Libriciel-SCOP version ${VERSION}.
Options obligatoires : --update
| --update : Compare et lance la mise à jour du patch automatiquement si une version patch supérieure est disponible sur le dépôt.
Option facultative pour les tests:
| --now : Exécution sans délai aléatoire et sans délai de carence.
Option --help : Affiche cette aide.
Option --version : Affiche le numéro de version."
    exit 0
}

function main {
    [[ "$(whoami)" == "root" ]] || errNoLog "[${SCRIPT_NAME}] Le script doit être exécuté en root. Arrêt du script ⛔️"
    [[ -z "${1}" ]] && help
    [[ "${1}" =~ ${OPTION_REGEX1} ]] || errNoLog "[${SCRIPT_NAME}] Option inconnue : \"${1}\". Voir --help. Arrêt du script ⛔️"
    if [[ -n "${2}" ]]; then
        [[ "${2}" =~ ${OPTION_REGEX2} ]] || errNoLog "[${SCRIPT_NAME}] Option inconnue : \"${2}\". Voir --help. Arrêt du script ⛔️"
    fi
    case "${1}" in
        "--update")
            OPTION="${1}"
        ;;
        "--help")
            help
        ;;
        "--version")
            echo ${VERSION}
            exit 0
        ;;
    esac
    if [[ "${2}" == "--now" ]]; then
        NO_RANDOM_EXEC="true"
        NO_DELAY="true"
        logInfo "[${SCRIPT_NAME}] Le script sera exécuté sans délai aléatoire et sans délai de carence." "${LOG_FILE}"
    fi
    checkTempFile "${TMP_FILE}"
    if [[ "${NO_RANDOM_EXEC}" != "true" ]]; then
        randomExec
    fi
    testCommands
    testLibricielFolder
    testLibricielVersionRegex "${LIBRICIEL}"
    testDistLink "${LS_DIST}"
    testEnvFile "${LS_ENV}"
    poleLibriciel "${LIBRICIEL}"
    testUrlHttpReturnCode "${LS_URL}"
    testUrlHttpReturnCode "${LS_UPDATE_URL}"
    parseJsonFromRepo
    testLibricielOccurrencesInTmpFile "${TMP_FILE}"
    if [[ "${NO_DELAY}" != "true" ]]; then
        waitingPeriod
    fi
    testLastVersionRegex "${LS_LAST_VERSION}"
    compareVersionPatch "${OPTION}"
    checkTempFile "${TMP_FILE}"
    logZip
} 

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
