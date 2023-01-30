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

from os import listdir
from os.path import isfile, join

import argparse
import functools
import json
import os
import re
import sys
import urllib.request

def get_parser() -> argparse.ArgumentParser:
    defaults = {
        'path': os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))) + '/build/karate-reports/',
        'tag': 'fixme-ip5'
    }

    parser=argparse.ArgumentParser(description=f"Find features and scenarios where the {defaults['tag']} tag is erroneous (missing while the test fails or present while the test succeeds)")

    parser.add_argument(
        '--path',
        '-p',
        default=defaults['path'],
        help=f"The path to the karate reports directory (default: {defaults['path']})"
    )

    parser.add_argument(
        '--tag',
        '-t',
        default=defaults['tag'],
        help=f"The tag that should be used on failed tests (default: {defaults['tag']})"
    )

    return parser

def karate_print_results_details(path: str, tag: str) -> None:
    # @todo: try / catch
    files = [join(path, f) for f in listdir(path) if isfile(join(path, f)) and f.endswith('-json.txt')]
    from jsonpath_ng.ext import parser
    extra = {}
    missing = {}

    for file in sorted(files):
        with open(file) as content:
            data = json.load(content)
            # ------------------------------------------------------------------
            # Tag alors que le test passe ?
            results = parser.parse('$.scenarioResults[?(@.failed==false)].tags[?(@=="' + tag + '")].`parent`.`parent`').find(data)
            if (len(results) > 0):
                for result in results:
                    relativePath = result.context.context.value['relativePath']
                    if relativePath not in extra:
                        extra[relativePath] = []
                    extra[relativePath].append(result.value['name'])

            # Pas de tag alors que le test ne passe pas
            results = parser.parse('$.scenarioResults[?(@.failed==true)]').find(data)
            if (len(results) > 0):
                for result in results:
                    if tag not in result.value['tags']:
                        relativePath = result.context.context.value['relativePath']
                        if relativePath not in missing:
                            missing[relativePath] = []
                        missing[relativePath].append(result.value['name'])

    if len(extra.keys()) > 0:
        print(f"extra {tag} tag in {len(extra.keys())} file(s)")
        for fileKey in sorted(extra.keys()):
            print("\t- " + fileKey)
            for scenario in extra[fileKey]:
                print("\t\t- " + scenario)

    if len(missing.keys()) > 0:
        print(f"missing {tag} tag in {len(missing.keys())} file(s)")
        for fileKey in sorted(missing.keys()):
            print("\t- " + fileKey)
            for scenario in missing[fileKey]:
                print("\t\t- " + scenario)

    if len(extra.keys()) > 0 or len(missing.keys()) > 0:
        exit(1)
    else:
        print(f"All {tag} tags are correct")
        exit(0)
# main
parser = get_parser()
args = parser.parse_args()
karate_print_results_details(args.path, args.tag)
