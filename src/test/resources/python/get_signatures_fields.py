#!/usr/bin/env python
# -*- coding: utf-8 -*-
from os import access, R_OK
from os.path import isfile

# pdfimages -list "build/ip5-folders/Automatique - Signature - PDF_avec_tags - normal - ec419c23-1236-11ed-85a6-0242ac160017/PDF_avec_tags.pdf"
# pdfimages -all "build/ip5-folders/Automatique - Signature - PDF_avec_tags - normal - ec419c23-1236-11ed-85a6-0242ac160017/PDF_avec_tags.pdf" /home/cbuffin/

# @todo: install PIL
# from PIL import Image
from PyPDF2 import PdfReader
from PyPDF2.generic import decode_pdfdocencoding

import codecs
import json
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

if len(sys.argv) != 3:
    exit_error("Usage: " + sys.argv[0] + "<annotations|signatures> <path to PDF file>")

if sys.argv[1] != "annotations" and sys.argv[1] != "signatures":
    exit_error("Usage: " + sys.argv[0] + "<annotations|signatures> <path to PDF file>")

path = sys.argv[2]

if isfile(path) == False or access(path, R_OK) == False:
    exit_error("File does not exist or is not readable: " + path)

# def export_image(name, x_object):
#     size = (x_object["/Width"], x_object["/Height"])
#     data = x_object.getData()
#     if x_object["/ColorSpace"] == "/DeviceRGB":
#         mode = "RGB"
#     else:
#         mode = "P"
#
#     if x_object["/Filter"] == "/FlateDecode":
#         img = Image.frombytes(mode, size, data)
#         img.save(name + ".png")
#     elif x_object["/Filter"] == "/DCTDecode":
#         img = open(name + ".jpg", "wb")
#         img.write(data)
#         img.close()
#     elif x_object["/Filter"] == "/JPXDecode":
#         img = open(name + ".jp2", "wb")
#         img.write(data)
#         img.close()

try:
    reader = PdfReader(path)

    # Annotations (images)
    if sys.argv[1] == "annotations":
        re_normal = re.compile(u"^\((.*)\) Tj")
        re_hexa = re.compile(u"^<(.*)> Tj")
        result = {}

        for idx in range(len(reader.pages)):
            page = reader.pages[idx]
            if "/Annots" in page:
#                 print("- " + str(idx+1))
                result[str(idx+1)] = {}
                for idxa in range(len(page["/Annots"])):
                    annot = page["/Annots"][idxa]
#                     print("  - " + str(idxa + 1))
                    result[str(idx+1)][str(idxa + 1)] = {}
                    obj = annot.get_object()
                    result[str(idx+1)][str(idxa + 1)]["position"] = repr(obj["/Rect"])
#                     print("    - position: " + repr(obj["/Rect"]))
#                     print("    - text: ")
                    result[str(idx+1)][str(idxa + 1)]["text"] = []
                    for line in obj["/AP"]["/N"].getData().splitlines():
                        match_normal = re.match(re_normal, line.decode("utf-8"))
                        match_hexa = re.match(re_hexa, line.decode("utf-8"))
                        if match_normal is not None:
                            result[str(idx+1)][str(idxa + 1)]["text"].append(match_normal[1])
#                             print("      - " + match_normal[1])
                        elif match_hexa is not None:
                            result[str(idx+1)][str(idxa + 1)]["text"].append(decode_pdfdocencoding(codecs.decode(match_hexa[1], 'hex')))
#                             print("      - " + decode_pdfdocencoding(codecs.decode(match_hexa[1], 'hex')))
        print(json.dumps(result))
    # Signatures
    elif sys.argv[1] == "signatures":
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
