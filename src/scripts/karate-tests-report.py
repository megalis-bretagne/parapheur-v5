#!/usr/bin/env python3

#  iparapheur
#  Copyright (C) 2019-2023 Libriciel SCOP
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program. If not, see <http://www.gnu.org/licenses/>.

# gradle test -Dkarate.options="--tags ~@ip-web" --info
# python3 ./src/scripts/karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-all-ip-core.md"

# gradle test -Dkarate.options="--tags ~@ip-web --tags ~@issue-ip-core-78" --info
# python3 ./src/scripts/karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-all-ip-core-not-issue-ip-core-78.md"

# gradle test -Dkarate.options="--tags ~@ip-web --tags ~@fixme-ip-core --tags ~@todo-ip-core" --info
# python3 ./src/scripts/karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-passing-ip-core.md"

from os import listdir
from os.path import isfile, join

import argparse
import functools
import json
import os
import re
import sys
import urllib.request

# ======================================================================================================================

def get_parser() -> argparse.ArgumentParser:
    defaults = {
        'path': os.path.dirname(os.path.dirname(os.path.dirname(__file__))) + '/build/karate-reports/',
        'url': 'http://iparapheur.dom.local/api/v3/api-docs'
    }

    # @todo: 3 statuses + meaning
    parser=argparse.ArgumentParser(description='Script that merges the Swagger API endpoints with karate test results')

    parser.add_argument(
        '--path',
        '-p',
        default=defaults['path'],
        help=f"The path to the karate reports directory (default: {defaults['path']})"
    )
    parser.add_argument(
        '--url',
        '-u',
        default=defaults['url'],
        help=f"The URL to the Swagger API (default: {defaults['url']})"
    )

    return parser

def http_verbs_cmp(a: str, b: str) -> int:
    o = ['GET', 'POST', 'PATCH', 'PUT', 'DELETE']
    if (a.upper() == b.upper()):
        return 0
    else:
        return o.index(a.upper()) < o.index(b.upper())

def get_api_dict(url: str) -> dict:
    """List all verbs and paths from the Swagger API"""
    results = {}

    try:
        #print(f"Getting URL ${url}")
        with urllib.request.urlopen(url) as api:
            data = json.load(api)
    except urllib.error.URLError as exc:
        print(f"Error: could not reach URL {url}", file=sys.stderr)
        sys.exit(1)

    regexp = re.compile(r'^https{0,1}://([^/]+)(/.+)$')
    matches = regexp.match(data['servers'][0]['url'])
    if matches != None:
        prefix = matches[2]
    else:
        prefix = ''

    for path in sorted(data['paths'].keys()):
        for verb in sorted(data['paths'][path].keys(), key=functools.cmp_to_key(http_verbs_cmp)):
            keys = data['paths'][path][verb].keys()
            results[f"{verb.upper()} {prefix}{path}"] = {
                # @todo: data['paths'][path][verb]['responses'].keys()
                'operationId': data['paths'][path][verb]['operationId'],
                'summary': data['paths'][path][verb]['summary'] if 'summary' in keys else '',
                'total': 0,
                'passed': 0,
                'failed': 0
            }

    return results

def complete_results_with_karate_report(path: str, results: dict) -> dict:
    """Complete with karate test results"""
    regexp = re.compile(r'^(GET|POST|PATCH|PUT|DELETE)\s+(.*)\s+\(.*\)$')

    # @todo: try / catch
    files = [join(path, f) for f in listdir(path) if isfile(join(path, f)) and f.endswith('-json.txt')]
    for file in files:
        with open(file) as content:
            data = json.load(content)
            if 'name' in data:
                matches = regexp.match(data['name'])
                if matches != None:
                    key = f"{matches[1]} {matches[2]}"
                    if key in results:
                        results[key]['total'] = data['passedCount'] + data['failedCount']
                        results[key]['passed'] = data['passedCount']
                        results[key]['failed'] = data['failedCount']

    return results

def output_results_in_md(results: dict) -> None:
    """Computes and outputs results in markdown"""

    # Compute and get max lengths...
    endpoints = {'total': len(results), 'passed': 0, 'partial': 0}
    totals = {'total': 0, 'passed': 0, 'failed': 0}
    max = {'status': 43, 'endpoint': 0, 'description': 0, 'passed': 0, 'failed': 0, 'total': 0}
    for path, details in results.items():
        totals['total'] = totals['total'] + details['total']
        totals['passed'] = totals['passed'] + details['passed']
        totals['failed'] = totals['failed'] + details['failed']

        if details['total'] > 0:
            if details['failed'] == 0:
                endpoints['passed'] = endpoints['passed'] + 1
            elif details['passed'] > 0:
                endpoints['partial'] = endpoints['partial'] + 1

        max['endpoint'] = len(path) if len(path) > max['endpoint'] else max['endpoint']
        max['description'] = len(path) if len(path) > max['description'] else max['description']

    max['passed'] = len(str(totals['passed']))
    max['failed'] = len(str(totals['failed']))
    max['total'] = len(str(totals['total']))

    # Display
    # @todo: 43= longest...
    statuses = {
        'OK': '<span style="background: green;">OK</span>',
        'KO': '<span style="background: yellow;">KO</span>',
        'NA': '<span style="background: red;">N/A</span>',
    }

    print(f"# Summary\n")

    print(f"| Endpoints | Passing | Partial | Uncovered |")
    print(f"| ---       | ---     | ---     | ---       |")
    print(f"| %9d | %7d | %7d | %9d |" % (endpoints['total'], endpoints['passed'], endpoints['partial'], endpoints['total'] - (endpoints['passed'] + endpoints['partial'])))
    print(f"| %7.2f %% | %5.2f %% | %5.2f %% | %7.2f %% |" % (
        endpoints['total'] / endpoints['total'] * 100,
        endpoints['passed'] / endpoints['total'] * 100,
        endpoints['partial'] / endpoints['total'] * 100,
        (endpoints['total'] - (endpoints['passed'] + endpoints['partial'])) / endpoints['total'] * 100
        )
    )

    print(f"\n# Details\n")

    print(
        f"| " + "Status".ljust(max["status"])
        + " | " + "Endpoint".ljust(max["endpoint"] + 2)

        + " | Description".ljust(max["description"])
        + " | Passed".ljust(max["passed"])
        + " | Failed".ljust(max["failed"])
        + " | Total".ljust(max["total"])
        + " |"
    )
    print(
        f"| " + "---".ljust(max["status"])
        + " | " + "---".ljust(max["endpoint"] + 2)
        + " | " + "---".ljust(max['description'])
        + " | " + "---".ljust(max["passed"])
        + " | " + "---".ljust(max["failed"])
        + " | " + "---".ljust(max["total"])
        + " |"
    )

    for path, details in results.items():
        if details['total'] == 0:
            status = 'NA'
        elif details['total'] > details['passed']:
            status = 'KO'
        else:
            status = 'OK'

        print(
            f"| " + statuses[status].ljust(max["status"])
            + " | `" + path + "`" + ''.ljust(max["endpoint"] - len(path))
            + " | " + details['summary'].ljust(max["description"])
            + " | " + str(details['passed']).rjust(max["passed"])
            + " | " + str(details['failed']).rjust(max["failed"])
            + " | " + str(details['total']).rjust(max["total"])
            + " |"
        )

    print(
        f"| " + ''.ljust(max["status"])
        + " | " + 'Total'.ljust(max["endpoint"] + 2)
        + " | " + details['summary'].ljust(max["description"])
        + " | " + str(totals['passed']).rjust(max["passed"])
        + " | " + str(totals['failed']).rjust(max["failed"])
        + " | " + str(totals['total']).rjust(max["total"])
        + " |"
    )

# ======================================================================================================================

# main
parser = get_parser()
args = parser.parse_args()
results = get_api_dict(args.url)
results = complete_results_with_karate_report(args.path, results)
output_results_in_md(results)
