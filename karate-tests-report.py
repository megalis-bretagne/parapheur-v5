import functools
import json
import urllib.request

# gradle test -Dkarate.options="--tags ~@ip-web" --info
# python3 karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-all-ip-core.md"

# gradle test -Dkarate.options="--tags ~@ip-web --tags ~@issue-ip-core-78" --info
# python3 karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-all-ip-core-not-issue-ip-core-78.md"

# gradle test -Dkarate.options="--tags ~@ip-web --tags ~@fixme-ip-core --tags ~@todo-ip-core" --info
# python3 karate-tests-report.py > "build/karate-tests-`date "+%Y%m%d"`-all-ip-core-no-fixme.md"

result = {}

# 1. List all verbs and paths from the Swagger API (136@20210524)
url = 'http://iparapheur.dom.local/api/v2/api-docs'
with urllib.request.urlopen(url) as api:
    data = json.load(api)

def http_verbs_cmp(a, b):
    o = ['GET', 'POST', 'PATCH', 'PUT', 'DELETE']
    if (a.upper() == b.upper()):
        return 0
    else:
        return o.index(a.upper()) < o.index(b.upper())

for path in sorted(data['paths'].keys()):
    for verb in sorted(data['paths'][path].keys(), key=functools.cmp_to_key(http_verbs_cmp)):
        result[f"{verb.upper()} {path}"] = {'total': 0, 'passed': 0, 'failed': 0}

# 2. Get karate test results
path = 'build/karate-reports/'
from os import listdir
from os.path import isfile, join
import re
regexp = re.compile(r'^(GET|POST|PATCH|PUT|DELETE)\s+(.*)\s+\(.*\)$')

files = [join(path, f) for f in listdir(path) if isfile(join(path, f)) and f.endswith('-json.txt')]
for file in files:
    with open(file) as content:
        data = json.load(content)
        if 'name' in data:
            matches = regexp.match(data['name'])
            if matches != None:
                key = f"{matches[1]} {matches[2]}"
                result[key] = {
                    'total': data['passedCount'] + data['failedCount'],
                    'passed': data['passedCount'],
                    'failed': data['failedCount']
                }

# 3. Output results
max = 0
for path in result.keys():
    if len(path) > max:
        max = len(path)

statuses = {
    'OK': '<span style="background: green;">OK</span>',
    'KO': '<span style="background: yellow;">KO</span>',
    'NA': '<span style="background: red;">N/A</span>',
}

totals = {'total': 0, 'passed': 0, 'failed': 0}

print(f"| " + 'Status'.ljust(43) + " | " + 'Endpoint'.ljust(max + 2) + " | Passed | Failed | Total |")
print(f"| " + '---'.ljust(43) + " | " + '---'.ljust(max + 2) + " | " + '---'.ljust(6) + " | " + '---'.ljust(6) + " | " + '---'.ljust(5) + " |")

for path, details in result.items():
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
