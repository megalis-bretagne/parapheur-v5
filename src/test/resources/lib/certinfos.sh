#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o functrace
set -o nounset
set -o pipefail

__usage__()
{
    echo "Usage: ${0} (enddate|issuer|subject) certificate password"
}

if [ $# -ne 3 ] ; then
    >&2 __usage__
    exit 1
fi

certificate="${2}"
password="${3}"

case "${1:-}" in
    alias)
        openssl pkcs12 -in "${certificate}" -nodes -passin pass:"${password}" | openssl x509 -noout -subject | sed 's/^.*CN *= *\([^,]\+\), .*$/\1/g'
        exit 0
    ;;
    enddate)
        notAfter=$(openssl pkcs12 -in "${certificate}" -nodes -passin pass:"${password}" | openssl x509 -noout -enddate | sed 's/notAfter=//g')
        date -d"${notAfter}" +%s000
        exit 0
    ;;
    issuer)
        openssl pkcs12 -in "${certificate}" -nodes -passin pass:"${password}" | openssl x509 -noout -issuer | sed 's/issuer=//g'
        exit 0
    ;;
    subject)
        openssl pkcs12 -in "${certificate}" -nodes -passin pass:"${password}" | openssl x509 -noout -subject
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
