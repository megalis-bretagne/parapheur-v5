#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import codecs
import json
import os
import PyPDF2
import re
import sys
import traceback

from PIL import Image, ImageChops
from PyPDF2.generic import decode_pdfdocencoding

class Dict():
    @classmethod
    def exists(cls, haystack: dict, path: list) -> bool:
        if path[0] in haystack:
            if len(list(path)) == 1:
                return True
            else:
                return cls.exists(haystack[path[0]], path[1:])
        else:
            return False
    @classmethod
    def get(cls, haystack: dict, path: list, default : any = None) -> any:
        if path[0] in haystack:
            if len(list(path)) == 1:
                return haystack[path[0]]
            else:
                return cls.get(haystack[path[0]], path[1:], default)
        else:
            return default

# tests:
# haystack = { "/foo": { "/bar": 666 } }
# path = ["/foo", "/bar"]
# print(Dict.exists(haystack, path))
# print(Dict.get(haystack, path))

# ------------------------------------------------------------------------------

class PdfImage():
    @classmethod
    def export(cls, x_object, path: str) -> str:
        """@see https://stackoverflow.com/a/34116472"""
        if os.path.isdir(os.path.dirname(path)) is False:
            os.makedirs(os.path.dirname(path))

        size = (x_object["/Width"], x_object["/Height"])
        data = x_object.getData()
        if x_object["/ColorSpace"] == "/DeviceRGB":
            mode = "RGB"
        else:
            mode = "P"

        if x_object["/Filter"] == "/FlateDecode":
            img = Image.frombytes(mode, size, data)
            mask = Image.frombytes("L", (x_object["/SMask"]["/Width"], x_object["/SMask"]["/Height"]), x_object["/SMask"].getData())

            img.convert("RGBA")
            mask.convert("RGBA")
            img.putalpha(mask)

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
    @classmethod
    def compare(cls, expected: str, actual: str, diff: str) -> dict:
        imgActual = Image.open(actual)
        imgExpected = Image.open(expected)
        difference = ImageChops.difference(imgActual, imgExpected)
        bbox = difference.getbbox()
        if bbox is None:
            return {"diff": False} # @todo: harmoniser
        else:
            if os.path.isdir(os.path.dirname(diff)) is False:
                os.makedirs(os.path.dirname(diff))
            difference.save(diff)
            return {"diff": True, "position": list(bbox), "path": diff}

class Pdf():
    @classmethod
    def annotations(cls, path: str) -> dict:
        re_normal = re.compile(u"^\((.*)\) Tj")
        re_hexa = re.compile(u"^<(.*)> Tj")
        result = {}
        reader = PyPDF2.PdfReader(path)

        for idxPage in range(len(reader.pages)):
            page = reader.pages[idxPage]
            keyAnnot = 0

            if "/Annots" in page:
                keyPage = "page " + str(idxPage+1)
                for idxAnnot in range(len(page["/Annots"])):
                    annot = page["/Annots"][idxAnnot]
                    obj = annot.get_object()
                    if obj["/Subtype"] == "/Widget":
                        if keyPage not in result:
                            result[keyPage] = {}
                        keyAnnot = keyAnnot + 1
                        result[keyPage][str(keyAnnot)] = {}
                        result[keyPage][str(keyAnnot)]["position"] = [int(obj["/Rect"][0]), int(obj["/Rect"][1]), int(obj["/Rect"][2]), int(obj["/Rect"][3])]
                        result[keyPage][str(keyAnnot)]["text"] = []
                        if Dict.exists(obj, ["/AP", "/N"]):
                            for line in obj["/AP"]["/N"].getData().splitlines():
                                match_normal = re.match(re_normal, line.decode("utf-8"))
                                match_hexa = re.match(re_hexa, line.decode("utf-8"))
                                if match_normal is not None:
                                    result[keyPage][str(keyAnnot)]["text"].append(match_normal[1])
                                elif match_hexa is not None:
                                    result[keyPage][str(keyAnnot)]["text"].append(decode_pdfdocencoding(codecs.decode(match_hexa[1], 'hex')))
        return result

    @classmethod
    def images(cls, path: str, base: str) -> dict:
        result = {}
        reader = PyPDF2.PdfReader(path)

        for idxPage in range(len(reader.pages)):
            page = reader.pages[idxPage]
            indirect = []
            keyAnnot = 0

            if "/Annots" in page:
                keyPage = "page " + str(idxPage+1)
                for idxAnnot in range(len(page["/Annots"])):
                    annot = page["/Annots"][idxAnnot]
                    obj = annot.get_object()
                    if Dict.exists(obj, ["/AP", "/N", "/Resources", "/XObject"]):
                        for imgKey in obj["/AP"]["/N"]["/Resources"]["/XObject"]:
                            if Dict.get(obj, ["/AP", "/N", "/Resources", "/XObject", imgKey, "/Subtype"]) == "/Image":
                                if keyPage not in result:
                                    result[keyPage] = {}
                                if repr(annot) not in indirect:
                                    indirect.append(repr(annot))
                                keyAnnot = str(indirect.index(repr(annot)) + 1)
                                if keyAnnot not in result[keyPage]:
                                    result[keyPage][str(keyAnnot)] = {}
                                imgPath = base + "/" + keyPage + "/" + keyAnnot + imgKey
                                result[keyPage][keyAnnot][imgKey] = PdfImage.export(obj["/AP"]["/N"]["/Resources"]["/XObject"][imgKey], imgPath)
        return result

    @classmethod
    def signatures(cls, path: str) -> dict:
        result = []
        reader = PyPDF2.PdfReader(path)
        fields = reader.get_fields()
        for key in fields.keys():
            if Dict.get(fields, [key, "/V", "/Type"]) == "/Sig":
                # Certifié ou signé ?
                signKey = "signedBy"
                references = Dict.get(fields, [key, "/V", "/Reference"])
                if references is not None:
                    for reference in references:
                        reference = reference.get_object()
                        if Dict.get(reference, ["/Type"]) == "/SigRef" \
                            and Dict.get(reference, ["/TransformMethod"]) == "/DocMDP" \
                            and Dict.get(reference, ["/TransformParams", "/P"]) == 1:
                            signKey = "certifiedBy"
                result.append(
                    {
                        signKey: re.sub(' .{40}$', '', Dict.get(fields, [key, "/V", "/Name"], "")),
                        "reason": Dict.get(fields, [key, "/V", "/Reason"], ""),
                        "location": Dict.get(fields, [key, "/V", "/Location"], "")
                    }
                )
        return result

def usage():
    program = os.path.basename(sys.argv[0])
    print("{0}".format(program))
    print("COMMANDES")
    print("    annotations PDF")
    print("        extrait les annotations d'un document PDF et les retourne au format JSON")
    print("    compare IMAGE IMAGE IMAGE")
    print("        compare une image attendue à une image obtenue, stocke l'image de différence le cas échéant et retourne les détails au format JSON")
    print("    images PDF DIR")
    print("        extrait les images d'un document PDF dans un dossier et retourne leurs chemins au format JSON")
    print("    signatures PDF")
    print("        extrait les données des signatures électroniques d'un document PDF au format JSON")
    print("EXAMPLES")
    # @todo: exemples

try:
    if len(sys.argv) < 2:
        usage()
        exit(1)

    if sys.argv[1] == "annotations":
        if len(sys.argv) != 3:
            usage()
            exit(1)
        result = Pdf.annotations(sys.argv[2])
    elif sys.argv[1] == "compare":
        if len(sys.argv) != 5:
            usage()
            exit(1)
        result = PdfImage.compare(sys.argv[2], sys.argv[3], sys.argv[4])
    elif sys.argv[1] == "images":
        if len(sys.argv) != 4:
            usage()
            exit(1)
        result = Pdf.images(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "signatures":
        if len(sys.argv) != 3:
            usage()
            exit(1)
        result = Pdf.signatures(sys.argv[2])
    else:
        usage()
        exit(1)
    print(json.dumps(result))
except Exception as exc:
    traceback.print_exc()
    exit(2)
