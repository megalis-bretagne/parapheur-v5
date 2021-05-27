#!/usr/bin/env python3

# gradle test -Dkarate.options="--tags ~@ip-web" --info
# python3 ./src/scripts/karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-all-ip-core.md"

# gradle test -Dkarate.options="--tags ~@ip-web --tags ~@issue-ip-core-78" --info
# python3 ./src/scripts/karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-all-ip-core-not-issue-ip-core-78.md"

# gradle test -Dkarate.options="--tags ~@ip-web --tags ~@fixme-ip-core --tags ~@todo-ip-core" --info
# python3 ./src/scripts/karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-all-ip-core-no-fixme.md"

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
        'url': 'https://iparapheur-5-0.dev.libriciel.net/api/v2/api-docs' # @fixme: 'http://iparapheur.dom.local/api/v2/api-docs'
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
        with urllib.request.urlopen(url) as api:
            data = json.load(api)
    except urllib.error.URLError as exc:
        print(f"Error: could not reach URL {url}")
        sys.exit(1)

    for path in sorted(data['paths'].keys()):
        for verb in sorted(data['paths'][path].keys(), key=functools.cmp_to_key(http_verbs_cmp)):
            results[f"{verb.upper()} {path}"] = {'total': 0, 'passed': 0, 'failed': 0}

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
                    results[key] = {
                        'total': data['passedCount'] + data['failedCount'],
                        'passed': data['passedCount'],
                        'failed': data['failedCount']
                    }
    return results

def output_results_in_md(results: dict) -> None:
    """Output results in markdown"""
    max = 0
    for path in results.keys():
        if len(path) > max:
            max = len(path)

    statuses = {
        'OK': '<span style="background: green;">OK</span>',
        'KO': '<span style="background: yellow;">KO</span>',
        'NA': '<span style="background: red;">N/A</span>',
    }
    # @todo: 43= longest...

    totals = {'total': 0, 'passed': 0, 'failed': 0}

    print(f"| " + 'Status'.ljust(43) + " | " + 'Endpoint'.ljust(max + 2) + " | Passed | Failed | Total |")
    print(f"| " + '---'.ljust(43) + " | " + '---'.ljust(max + 2) + " | " + '---'.ljust(6) + " | " + '---'.ljust(6) + " | " + '---'.ljust(5) + " |")

    for path, details in results.items():
        totals['total'] = totals['total'] + details['total']
        totals['passed'] = totals['passed'] + details['passed']
        totals['failed'] = totals['failed'] + details['failed']

        if details['total'] == 0:
            status = 'NA'
        elif details['total'] > details['passed']:
            status = 'KO'
        else:
            status = 'OK'

        print(f"| " + statuses[status].ljust(43) + " | `" + path + "`" + ''.ljust(max - len(path)) + " | " + str(details['passed']).rjust(6) + " | " + str(details['failed']).rjust(6) + " | " + str(details['total']).rjust(5) + " |")

    print(f"| " + ''.ljust(43) + " | " + 'Total'.ljust(max + 2) + " | " + str(totals['passed']).rjust(6) + " | " + str(totals['failed']).rjust(6) + " | " + str(totals['total']).rjust(5) + " |")

# ======================================================================================================================

# main
parser = get_parser()
args = parser.parse_args()
results = get_api_dict(args.url)
results = complete_results_with_karate_report(args.path, results)
output_results_in_md(results)
