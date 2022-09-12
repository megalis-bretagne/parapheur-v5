#!/usr/bin/env python3

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
# 20220811-12h45 - 10m 34s - 581 tests completed, 112 failed
# ./gradlew test --info -Dkarate.options="--tags @formats-de-signature" -Dkarate.headless=true
# 20220811-13h32 - 41m 27s - 766 tests completed, 131 failed
# ./gradlew test --info -Dkarate.options="--tags @demo-simple-bde,@formats-de-signature,@legacy-bridge --tags ~@ignore --tags ~@ip4" -Dkarate.headless=true
# 20220910-18h45 - 1h 5m 7s - 917 tests completed, 150 failed
# ./gradlew test --info -Dkarate.options="--tags @demo-simple-bde,@formats-de-signature,@legacy-bridge,@metadonnees --tags ~@ignore --tags ~@ip4" -Dkarate.headless=true
# ======================================================================================================================

def get_parser() -> argparse.ArgumentParser:
    defaults = {
        'path': os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))) + '/build/karate-reports/',
    }

    parser=argparse.ArgumentParser(description='Find features and scenarios where the fixme-ip tag is erroneous (missing while the test fails or present while the test succeeds)')

    parser.add_argument(
        '--path',
        '-p',
        default=defaults['path'],
        help=f"The path to the karate reports directory (default: {defaults['path']})"
    )

    return parser

def karate_print_results_details(path: str) -> None:
    # @todo: try / catch
    files = [join(path, f) for f in listdir(path) if isfile(join(path, f)) and f.endswith('-json.txt')]
    from jsonpath_ng.ext import parser
    extra = {}
    missing = {}

    for file in sorted(files):
        with open(file) as content:
            data = json.load(content)
            # ------------------------------------------------------------------
            # OK -> tag fixme-ip alors que le test passe
            results = parser.parse('$.scenarioResults[?(@.failed==false)].tags[?(@=="fixme-ip")].`parent`.`parent`').find(data)
            if (len(results) > 0):
                for result in results:
                    relativePath = result.context.context.value['relativePath']
                    if relativePath not in extra:
                        extra[relativePath] = []
                    extra[relativePath].append(result.value['name'])

            # OK -> pas de tag fixme-ip alors que le test ne passe pas
            results = parser.parse('$.scenarioResults[?(@.failed==true)]').find(data)
            if (len(results) > 0):
                for result in results:
                    if "fixme-ip" not in result.value['tags']:
                        relativePath = result.context.context.value['relativePath']
                        if relativePath not in missing:
                            missing[relativePath] = []
                        missing[relativePath].append(result.value['name'])
    # @todo: add scenario line number
    if len(extra.keys()) > 0:
        print(f"extra fixme-ip tag in {len(extra.keys())} file(s)")
        for fileKey in sorted(extra.keys()):
            print("\t- " + fileKey)
            for scenario in extra[fileKey]:
                print("\t\t- " + scenario)

    if len(missing.keys()) > 0:
        print(f"missing fixme-ip tag in {len(missing.keys())} file(s)")
        for fileKey in sorted(missing.keys()):
            print("\t- " + fileKey)
            for scenario in missing[fileKey]:
                print("\t\t- " + scenario)

    if len(extra.keys()) > 0 or len(missing.keys()) > 0:
        exit(1)
    else:
        print(f"All fixme-ip tags are correct")
        exit(0)
# main
parser = get_parser()
args = parser.parse_args()
karate_print_results_details(args.path)
