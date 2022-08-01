# -*- coding: utf-8 -*-
from os import access, R_OK
from os.path import isfile
from PyPDF2 import PdfReader

import re
import sys
import traceback

# @todo: ordonner ?
# @todo: différence Signé par / Certifié par ?

def exit_error(message):
    sys.stderr.write(message + "\n")
    exit(1)

def value(fields, key1, key2):
    if key1 in fields:
        if key2 in fields[key1]:
            return fields[key1][key2]
    return ""

if len(sys.argv) != 2:
    exit_error("Usage: " + sys.argv[0] + " <path to PDF file>")

path = sys.argv[1]

if isfile(path) == False or access(path, R_OK) == False:
    exit_error("File does not exist or is not readable: " + path)

try:
    reader = PdfReader(path)
    fields=reader.get_fields()

    for key in fields.keys():
        if fields[key]["/V"]["/Type"] == "/Sig":
            print("- " + re.sub('^Signature', '', key) + ":")
            print("    - Signed By: " + re.sub(' .{40}$', '', value(fields[key], "/V", "/Name")))
            #print("    - Date: " + fields[key]["/V"]["/M"])
            print("    - Reason: " + value(fields[key], "/V", "/Reason"))
            print("    - Location: " + value(fields[key], "/V", "/Location"))
except Exception as exc:
    traceback.print_exc()
    # @todo: better error management
    exit_error("File is not a valid PDF file: " + path)
