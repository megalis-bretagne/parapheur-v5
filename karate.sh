#!/usr/bin/env bash

# ----------------------------------------------------------------------------------------------------------------------
# Bootstrap
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

# ----------------------------------------------------------------------------------------------------------------------
# Library
# ----------------------------------------------------------------------------------------------------------------------

# Internal constants

declare -r _blue_="\e[34m"
declare -r _cyan_="\e[36m"
declare -r _default_="\e[0m"
declare -r _green_="\e[32m"
declare -r _red_="\e[31m"

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
# Variables
# ----------------------------------------------------------------------------------------------------------------------

_DEFAULT_TAGS_PATH_="./src/test/resources/features"

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
    printf "  %s [OPTION] [COMMAND]\n" "${__SCRIPT__}"
    printf "\nCOMMANDS\n"
    printf "  run\n"
    printf "  tags\tList all tags used karate fixture files (default: %s)\n"  "${_DEFAULT_TAGS_PATH_}"
    printf "\nOPTIONS\n"
    printf "  -h|--help\tDisplay this help\n"
    printf "\nEXEMPLES\n"
    printf "  %s tags\n" "${__SCRIPT__}"
    printf "  %s --help\n" "${__SCRIPT__}"
}

__tags__() {
    local path="${1}"
    find "${path}" \
          -type f \
          -iname *.feature \
          -exec grep "^\s*@" {} \; \
          | sed 's/\(^\s*\|\s*$\)//g' \
          | sed 's/\s\+/\n/g' \
          | sort \
          | uniq
}

# ----------------------------------------------------------------------------------------------------------------------
# Main function
# ----------------------------------------------------------------------------------------------------------------------

__main__()
{
    (
        opts=`getopt --longoptions help -- h "${@}"` || ( >&2 __usage__ ; exit 1 )
        eval set -- "$opts"
        while true ; do
            case "${1}" in
                -h|--help)
                    __usage__
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

        while true ; do
            case "${1}" in
                tags)
                    __tags__ "${2:-${__ROOT__}/${_DEFAULT_TAGS_PATH_}}"
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
#        echo "${1}"
#        echo "${@}"
    )
}

__main__ "${@}"
