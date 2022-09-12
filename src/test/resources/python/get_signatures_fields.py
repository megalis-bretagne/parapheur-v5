#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @derecated, see karate-ip.py

# @todo: install PIL, ...
from PIL import Image, ImageChops
from PyPDF2 import PdfReader
from PyPDF2.generic import decode_pdfdocencoding

import codecs
import json
import os
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


# https://stackoverflow.com/a/52260663
def key_exists(dataDict, path):
    mapList = path.split(".")
    if mapList[0] in dataDict:
        if len(list(mapList)) == 1:
            return True
        else:
            return key_exists(dataDict[mapList[0]], '.'.join(mapList[1:]))
    else:
        return False


# @todo: comparaison + nouvelle méthode (images) qui prend un json en entrée avec les chemins
def export_image(path, x_object):
    # https://stackoverflow.com/a/34116472
    size = (x_object["/Width"], x_object["/Height"])
    data = x_object.getData()
    if x_object["/ColorSpace"] == "/DeviceRGB":
        mode = "RGB"
    else:
        mode = "P"

    if x_object["/Filter"] == "/FlateDecode":
        # @todo: transparency
        # https://pillow.readthedocs.io/en/stable/reference/Image.html#PIL.Image.frombytes
        # https://www.geeksforgeeks.org/create-transparent-png-image-with-python-pillow/
        img = Image.frombytes(mode, size, data)
        fullPath = path + ".png"
        img.save(fullPath)
    elif x_object["/Filter"] == "/DCTDecode":
        fullPath = path + ".jpg"
        img = open(fullPath, "wb")
        img.write(data)
        img.close()
    elif x_object["/Filter"] == "/JPXDecode":
        fullPath = path + ".jp2"
        img = open(fullPath, "wb")
        img.write(data)
        img.close()
    return fullPath

usage = "Usage:\n\t" + sys.argv[0] + "<annotations|images|signatures> <path to PDF file>\n\t" + sys.argv[0] + "compare '<actual json>' '<expected json>'"

# @todo: les autres cas (4 param pour autre chose que compare, ...)
if len(sys.argv) < 3:
    exit_error(usage)

if sys.argv[1] != "annotations" and sys.argv[1] != "compare" and sys.argv[1] != "images" and sys.argv[1] != "signatures":
    exit_error(usage)

# ----------------------------------------------------------------------------------------------------

if sys.argv[1] == "compare":
    # https://stackoverflow.com/a/56280735
    # @todo: https://stackoverflow.com/a/68402702
    # @todo: https://stackoverflow.com/a/46126988

    actual = json.loads(sys.argv[2])
    expected = json.loads(sys.argv[3])

    # @fixme: paramètre en plus
    basePath = "/home/cbuffin/Documents/gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/compose/build/ip5-folders/Automatique - Signature - PDF_sans_tags - surcharge - 90d4bff0-14a3-11ed-b108-0242ac160017"

    result = {}

    for keyPage in actual:
        result[keyPage] = {}
        for annotKey in actual[keyPage]:
            result[keyPage][annotKey] = {}
            for imgKey in actual[keyPage][annotKey]:
                imgActual = Image.open(actual[keyPage][annotKey][imgKey])
                imgExpected = Image.open(expected[keyPage][annotKey][imgKey])

                diff = ImageChops.difference(imgActual, imgExpected)

                if diff.getbbox():
                    imgPath = basePath + "/diffs/" + keyPage + "/" + str(annotKey) + "/" + str(imgKey) + ".png"
                    if os.path.isdir(os.path.dirname(imgPath)) is False:
                        os.makedirs(os.path.dirname(imgPath))
                    diff.save(imgPath)
                    result[keyPage][annotKey][imgKey] = imgPath
                else:
                    result[keyPage][annotKey][imgKey] = True
    print(json.dumps(result))
else:
    path = sys.argv[2]

    if os.path.isfile(path) == False or os.access(path, os.R_OK) == False:
        exit_error("File does not exist or is not readable: " + path)

    # ----------------------------------------------------------------------------------------------------

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
                    keyPage = "page " + str(idx+1)
                    result[keyPage] = {}
                    for idxa in range(len(page["/Annots"])):
                        annot = page["/Annots"][idxa]
                        result[keyPage][str(idxa + 1)] = {}
                        obj = annot.get_object()
                        result[keyPage][str(idxa + 1)]["position"] = repr(obj["/Rect"])
                        result[keyPage][str(idxa + 1)]["text"] = []
                        for line in obj["/AP"]["/N"].getData().splitlines():
                            match_normal = re.match(re_normal, line.decode("utf-8"))
                            match_hexa = re.match(re_hexa, line.decode("utf-8"))
                            if match_normal is not None:
                                result[keyPage][str(idxa + 1)]["text"].append(match_normal[1])
                            elif match_hexa is not None:
                                result[keyPage][str(idxa + 1)]["text"].append(decode_pdfdocencoding(codecs.decode(match_hexa[1], 'hex')))
            print(json.dumps(result))
        # Images
        elif sys.argv[1] == "images":
            basePath = os.path.dirname(path)
            re_normal = re.compile(u"^\((.*)\) Tj")
            re_hexa = re.compile(u"^<(.*)> Tj")
            result = {}

            for idx in range(len(reader.pages)):
                page = reader.pages[idx]

                if "/Annots" in page:
                    keyPage = "page " + str(idx+1)
                    result[keyPage] = {}
                    for idxa in range(len(page["/Annots"])):
                        annot = page["/Annots"][idxa]
                        result[keyPage][str(idxa + 1)] = {}
                        obj = annot.get_object()
                        if key_exists(obj, "/AP./N./Resources./XObject"):
                            for imgKey in obj["/AP"]["/N"]["/Resources"]["/XObject"]:
                                # @todo: IIF '/Subtype': '/Image'
                                imgPath = basePath + "/images/" + keyPage + "/" + str(idxa + 1) + "/" + imgKey
                                if os.path.isdir(os.path.dirname(imgPath)) is False:
                                    os.makedirs(os.path.dirname(imgPath))
                                result[keyPage][str(idxa + 1)][imgKey] = export_image(imgPath, obj["/AP"]["/N"]["/Resources"]["/XObject"][imgKey])
            print(json.dumps(result))
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
