#!/usr/bin/env python3

# gradle test -Dkarate.options="--tags ~@ip-web" --info
# python3 ./src/scripts/karate-tests-details.py > "build/karate-tests-details-`date "+%Y%m%d"`-all-ip-core.md"

# gradle test -Dkarate.options="--tags ~@ip-web --tags ~@issue-ip-core-78" --info
# python3 ./src/scripts/karate-tests-details.py > "build/karate-tests-details-`date "+%Y%m%d"`-all-ip-core-not-issue-ip-core-78.md"

# gradle test -Dkarate.options="--tags ~@ip-web --tags ~@fixme-ip-core --tags ~@todo-ip-core" --info
# python3 ./src/scripts/karate-tests-details.py > "build/karate-tests-details-`date "+%Y%m%d"`-passing-ip-core.md"

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
        'url': 'http://iparapheur.dom.local/api/v2/api-docs'
    }

    # @todo: 3 statuses + meaning
    parser=argparse.ArgumentParser(description='Script that merges the Swagger API endpoints with karate test results')

    parser.add_argument(
        '--path',
        '-p',
        default=defaults['path'],
        help=f"The path to the karate reports directory (default: {defaults['path']})"
    )

    return parser

def karate_print_results_details(path: str) -> None:
    """Complete with karate test results"""
    regexp = re.compile(r'^(GET|POST|PATCH|PUT|DELETE)\s+(.*)\s+\(.*\)$')
    statuses = {
        'OK': '<span style="background: green;">OK</span>',
        'KO': '<span style="background: red;">KO</span>'
    }

    # @todo: try / catch
    files = [join(path, f) for f in listdir(path) if isfile(join(path, f)) and f.endswith('-json.txt')]
    for file in sorted(files):
        with open(file) as content:
            data = json.load(content)
            if 'name' in data:
                total = data['passedCount'] + data['failedCount']
                percent = data['passedCount'] / max(1, total) * 100

                print(f"## {data['name']} (%.2f %%)\n" % (percent))

                print(f"- `" + data['packageQualifiedName'] + "`")
                print(f"- %.2f %%" % (percent))
                print(f"    - passed: %d" % (data['passedCount']))
                print(f"    - failed: %d" % (data['failedCount']))
                print(f"    - total: %d" % (total))
                print(f"\n| Result | Scenario |\n| --- | --- |")
                for scenario in data['scenarioResults']:
                    print(f"| %s | %s |" % (statuses['OK'] if scenario['failed'] == False else statuses['KO'], scenario['name']))

# ======================================================================================================================

# main
parser = get_parser()
args = parser.parse_args()
results = karate_print_results_details(args.path)
