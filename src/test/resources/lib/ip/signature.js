/*
 * iparapheur
 * Copyright (C) 2019-2023 Libriciel SCOP
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
namespace(config, 'config.ip.signature.pades.certificates.read', function(path) {});
namespace(config, 'config.ip.signature.pades.certificates.default', function(alias) {});
var namespace = function (obj, path, item) {
    //obj['ip'] = obj['ip'] || {};
    obj["foo"] = "bar";
    // return object;
};*/

function fn(config) {
    config['ip'] = config['ip'] || {};
    config.ip['signature'] = config.ip['signature'] || {};

    config.ip.signature['cades'] = config.ip.signature['cades'] || {};
    config.ip.signature.cades['check'] = function(document, pkcs7, certificate) {
        certificate = (typeof certificate === "undefined") ? karate.toAbsolutePath(ip.templates.certificate.default("signature")["public"]) : certificate;
        var cmd = [
            "/bin/sh",
            "-c",
            "openssl smime -verify -binary -inform PEM -in \"" + pkcs7 + "\" -content \"" + document + "\" -certfile \"" + certificate + "\" -nointern -noverify > /dev/null"
        ];
        ip.utils.safeExec(cmd);
    };

    config.ip.signature['helios'] = config.ip.signature['helios'] || {};
    config.ip.signature.helios['validateSchema'] = function(document) {
        var classpath = "classpath:xsd/schemas_pes_v5.11/PES_V2/Rev0/PES_Aller.xsd",
            output,
            schema = karate.toAbsolutePath(classpath);
        var cmd = [
            "/bin/sh",
            "-c",
            "xmllint --schema \"" + schema + "\" \"" + document + "\" --noout"
        ];
        output = ip.utils.safeExec(cmd);
        if (output.match(/.xml validates$/) === null) {
            karate.fail('XML document does not validate with schema at ' + classpath + ': ' + document);
        }
    };
    // @see https://gitlab.libriciel.fr/libriciel/pole-plate-formes/s2low/s2low/-/blob/57dcf6d35468c2287a5237304be7b9b620d3ab41/lib/XadesSignature.class.php
    config.ip.signature.helios['validate'] = function(document, certs) {
        certs = typeof certs === "undefined" ? [
                "classpath:files/certificates/signature/ca-root.pem",
                "classpath:files/certificates/signature/ca-intermediate.pem",
                "classpath:files/certificates/signature/public.pem"
            ] : certs;
        var cmd,
            content = karate.read("file://" + document),
            element,
            id,
            idx,
            idxCert,
            matches,
            name,
            nodeId,
            tokens,
            // @todo: #notpresent ?
            //xpath = "//*[namespace-uri()='http://www.w3.org/2000/09/xmldsig#'][local-name()='Signature']",
            xpath = "//Bordereau/Signature",
            signatureNodeList,
            signingTime;

        signatureNodeList = karate.xmlPath(content, xpath);
        if(signatureNodeList === "#notpresent") {
            return karate.fail("Impossible d'extraire les signatures (xpath: " + xpath + ")");
        }

        if (Array.isArray(signatureNodeList) === false) {
            signatureNodeList = [signatureNodeList];
        }

        for (idx = 0 ; idx < signatureNodeList.length ; idx++) {
            id = karate.xmlPath(signatureNodeList[idx], "/Signature/@Id");
            if(id == "#notpresent") {
                return karate.fail("Impossible d'extraire la signature " + String(idx + 1) + " (xpath: /Signature/@Id)");
            }
            //@todo: trouver un moyen propre de sélectionner le bon
            nodeId = karate.xmlPath(signatureNodeList[idx], "/Signature/SignedInfo/Reference/@URI")[0].replace(/^#/, '');
            if(nodeId == "#notpresent") {
                return karate.fail("Impossible d'extraire la signature " + String(idx + 1) + " (xpath: /Signature/SignedInfo/Reference/@URI)");
            }
            xpath = "//*[@Id='" + nodeId + "']";
            element = karate.xmlPath(content, xpath);
            if(element == "#notpresent") {
                return karate.fail("Impossible d'extraire la signature " + String(idx + 1) + " (xpath: " + xpath + ")");
            }

            matches = JSON.stringify(element).match(/^{"([^"]+)":/);
            name = matches[1].replace(/^[^:]+:/, '');
            signingTime = karate.xmlPath(content, "//QualifyingProperties[@Target='#" + id + "']//SigningTime/text()");
            if(signingTime == "#notpresent") {
                return karate.fail("SigningTime non trouvé pour la signature " + String(idx + 1) + " (xpath: //QualifyingProperties[@Target='#" + id + "']//SigningTime)");
            }

            cmd = "xmlsec1 " +
                "--verify ";
            for (idxCert = 0 ; idxCert < certs.length ; idxCert++) {
                cmd += "--trusted-pem \"" + karate.toAbsolutePath(certs[idxCert]) + "\" ";
            }
            cmd += "--node-xpath \"//*[namespace-uri()='http://www.w3.org/2000/09/xmldsig#'][local-name()='Signature'][@Id='" + id + "']\" " +
                "--verification-time \"" + JSON.stringify((new Date(signingTime)).toJSON()) + "\" " +
                "--id-attr:Id " + name + " " +
                "\"" + document + "\"";

            output = ip.utils.safeExec(["/bin/sh", "-c", cmd]);
            tokens = output.split("\n");

            if (tokens[0] !== "OK") {
                return karate.fail('Failure for "' + document + '": '.output);
            }
        }
    };

    config.ip.signature.helios['extract'] = function(path) {
        var prefix = "/PES_Aller/PES_DepenseAller/Bordereau/Signature/Object/QualifyingProperties/SignedProperties/SignedSignatureProperties",
            content = karate.read("file://" + path);
        return {
            City: karate.xmlPath(content, prefix + "/SignatureProductionPlace/City/text()"),
            PostalCode: karate.xmlPath(content, prefix + "/SignatureProductionPlace/PostalCode/text()"),
            CountryName: karate.xmlPath(content, prefix + "/SignatureProductionPlace/CountryName/text()"),
            ClaimedRole: karate.xmlPath(content, prefix + "/SignerRole/ClaimedRoles/ClaimedRole/text()")
        };
    };

    config.ip.signature['pades'] = config.ip.signature['pades'] || {};
    config.ip.signature.pades['annotations'] = config.ip.signature.pades['annotations'] || {};
    config.ip.signature.pades.annotations['read'] = function (path) {
        var cmd = ["python3", karate.toAbsolutePath("classpath:python/karate-ip.py"), "annotations", path],
            idx,
            lines,
            matches,
            proc,
            result = [],
            fields = {};
        proc = karate.fork(cmd);
        proc.waitSync();
        return karate.fromString(proc.sysOut);
    };
    config.ip.signature.pades.annotations['default'] = function(position, line1, line2, line3) {
        line3 = (typeof line3 === "undefined") ? ip5.business.regexp.annotation.date : line3;
        return {
            "position": position,
            "text": [
                line1,
                line2,
                line3
            ]
        };
    };
    config.ip.signature.pades['certificates'] = config.ip.signature.pades['certificates'] || {};
    config.ip.signature.pades.certificates['read'] = function (path) {
        var cmd = ["pdfsig", "-nocert", path],
            idx,
            lines,
            matches,
            proc,
            result = [],
            signature = {};
        proc = karate.fork(cmd);
        proc.waitSync();
        /*if (proc.exitCode !== 0) {
            karate.fail('Got status code ' + proc.exitCode + ' for command ' + command);
        }*/
        tmp = proc.sysOut.replace(/\n$/, '');
        lines = tmp.split(/\r?\n/).filter(element => element);

        for (idx = 0 ; idx < lines.length ; idx++) {
            if (matches = lines[idx].match(/^Signature #([0-9]+):$/)) {
                if (karate.keysOf(signature).length > 0) {
                    result.push(signature);
                }
                signature = {};
            } else if(matches = lines[idx].match(/^\s+- Signer Certificate Common Name: (.*)$/)) {
                signature["commonName"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signer full Distinguished Name: (.*)$/)) {
                signature["distinguishedName"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signing Time: (.*)$/)) {
                signature["timestamp"] = new Date(matches[1]).getTime();
            } else if(matches = lines[idx].match(/^\s+- Signing Hash Algorithm: (.*)$/)) {
                signature["algorithm"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signature Type: (.*)$/)) {
                signature["type"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signature Validation: (.*)$/)) {
                signature["valid"] = matches[1] === "Signature is Valid.";
            } else if(matches = lines[idx].match(/^\s+- (Not total document signed|Total document signed)$/)) {
                signature["wholeDocumentSigned"] = matches[1] === "Total document signed";
            }
        }

        if (karate.keysOf(signature).length > 0) {
            result.push(signature);
        }

        result.sort(function compare(a, b) { if (a.timestamp < b.timestamp) return -1; if (a.timestamp > b.timestamp) return 1; return 0; } );
        for (idx = 0 ; idx < result.length ; idx++) {
            delete result[idx].timestamp;
        }

        return result;
    };
    config.ip.signature.pades.certificates['default'] = function(alias, wholeDocumentSigned, valid) {
        valid = typeof valid === "undefined" ? true : valid;
        wholeDocumentSigned = typeof wholeDocumentSigned === "undefined" ? true : wholeDocumentSigned;

        if (alias === "seal") {
            return {
                "commonName": "Christian Buffin - Default tenant - Cachet serveur",
                "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Christian Buffin - Default tenant - Cachet serveur,OU=Default tenant - Cachet serveur,O=Libriciel SCOP,L=Montpellier,ST=34 - Herault,C=FR",
                "algorithm": "SHA-256",
                "type": "ETSI.CAdES.detached",
                "wholeDocumentSigned": wholeDocumentSigned,
                "valid": true
            };
        } else if (alias === "signature-user") {
            return {
                "commonName": "Prenom Nom - Usages",
                "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Prenom Nom - Usages,OU=Usages,O=Collectivite ou organisation,L=Ville,ST=34 - Herault,C=FR",
                "algorithm": "SHA-256",
                "type": "ETSI.CAdES.detached",
                "wholeDocumentSigned": wholeDocumentSigned,
                "valid": true
            };
        } else if (alias === "signature-cnoir") {
            return {
                "commonName": "Christian Noir - Recette i-parapheur",
                "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Christian Noir - Recette i-parapheur,OU=Recette i-parapheur,O=Libriciel SCOP,L=Montpellier,ST=34 - Herault,C=FR",
                "algorithm": "SHA-256",
                "type": "ETSI.CAdES.detached",
                "wholeDocumentSigned": wholeDocumentSigned,
                "valid": true
            };
        } else {
            var msg = "No config.ip.signature.pades.certificates.default for the \"" + alias + "\" alias. Use one of: seal, signature-user, signature-cnoir";
            karate.log(msg);
            karate.fail(msg);
        }
    };
    config.ip.signature.pades['fields'] = config.ip.signature.pades['fields'] || {};
    config.ip.signature.pades.fields['read'] = function (path) {
        var cmd = ["python3", karate.toAbsolutePath("classpath:python/karate-ip.py"), "signatures", path],
            idx,
            lines,
            matches,
            proc,
            result = [],
            fields = {};
        proc = karate.fork(cmd);
        proc.waitSync();
        if (proc.exitCode !== 0) {
            karate.fail('Got status code ' + proc.exitCode + ' for command ' + command);
        }
        return karate.fromString(proc.sysOut);
    };
    config.ip.signature.pades.fields['default'] = function(signedBy, reason, location) {
        return {
            "signedBy": signedBy,
            "reason": reason,
            "location": location
        };
    };
    config.ip.signature.pades['images'] = config.ip.signature.pades['images'] || {};
    config.ip.signature.pades.images['compare'] = function(actual, expected) {
        var cmd, diff, diffPath, dirname, img, keyImage, keyPage, keyPosition,
            proc, result = {}, script = karate.toAbsolutePath("classpath:python/karate-ip.py");
        for (keyPage in expected) {
            for (keyPosition in expected[keyPage]) {
                for (keyImage in expected[keyPage][keyPosition]) {
                    if (keyPage in actual && keyPosition in actual[keyPage] && keyImage in actual[keyPage][keyPosition]) {
                        dirname = ip.utils.file.dirname(ip.utils.file.dirname(ip.utils.file.dirname(expected[keyPage][keyPosition][keyImage]))) + "/diffs";
                        diffPath = dirname + "/" + keyPage + "/" + keyPosition + "/" + ip.utils.file.basename(expected[keyPage][keyPosition][keyImage]);
                        cmd = [
                            "python3",
                            script,
                            "compare",
                            expected[keyPage][keyPosition][keyImage],
                            actual[keyPage][keyPosition][keyImage],
                            diffPath
                        ];

                        proc = karate.fork(cmd);
                        proc.waitSync();
                        diff = karate.fromString(proc.sysOut);
                        if (diff["diff"] === true) {
                            result[keyPage] = result[keyPage] || {};
                            result[keyPage][keyPosition] = result[keyPage][keyPosition] || {};
                            result[keyPage][keyPosition][keyImage] = diff;
                        }
                    }
                }
            }
        }
        if (karate.keysOf(result).length > 0) {
            karate.fail('Image differences detected: ' + JSON.stringify(result));
        }
    };
    config.ip.signature.pades.images['expected'] = function(username, count) {//666
        count = (typeof count === "undefined") ? 3 : count;
        if (count === 1) {
            return {
                "/Im1": karate.toAbsolutePath("classpath:files/images/grigris/" + username + "/Im1.png")
            };
        } else {
            return {
                "/Im1": karate.toAbsolutePath("classpath:files/images/grigris/" + username + "/Im1.png"),
                "/Im2": karate.toAbsolutePath("classpath:files/images/grigris/" + username + "/Im2.png"),
                "/Im3": karate.toAbsolutePath("classpath:files/images/grigris/" + username + "/Im3.png")
            };
        }
    };
    config.ip.signature.pades.images['export'] = function(path) {
        var cmd = ["python3", karate.toAbsolutePath("classpath:python/karate-ip.py"), "images", path, ip.utils.file.dirname(path) + "/images"],
            proc;
        proc = karate.fork(cmd);
        proc.waitSync();
        return karate.fromString(proc.sysOut);

    };
    config.ip.signature.pades.images['schema'] = function(expected) {
        var keyImage, keyPage, keyPosition, result = {};
        for (keyPage in expected) {
            result[keyPage] = {};
            for (keyPosition in expected[keyPage]) {
                result[keyPage][keyPosition] = {};
                for (keyImage in expected[keyPage][keyPosition]) {
                    result[keyPage][keyPosition][keyImage] = "#string";
                }
            }
        }
        return result;
    };

    config.ip.signature['xades'] = config.ip.signature['xades'] || {};
    config.ip.signature.xades['actual'] = function(document, xades) {
        var actual = {},
            content = karate.read("file://" + xades);

        // 1. Partie publique dans ds:X509Certificate
        actual["X509Certificate"] = karate.xmlPath(content, "/Signature/KeyInfo/X509Data/X509Certificate/text()");

        // 2. DigestValue du document signé
        actual["DigestValue"] = karate.xmlPath(content, "/Signature/SignedInfo/Reference/DigestValue/text()")[0];

        return actual;
    };
    config.ip.signature.xades['expected'] = function(document, xades, certificate) {
        var algorithm,
            cmd,
            content = karate.read("file://" + xades),
            expected = {};

        // 1. Partie publique dans ds:X509Certificate
        expected["X509Certificate"] = ip.utils.certificate.base64Public("file://" + certificate);

        // 2. DigestValue du document signé
        algorithm = String(karate.xmlPath(content, "/Signature/SignedInfo/Reference/DigestMethod/@Algorithm")).replace(/^.*#/, "");

        cmd = [
            "/bin/sh",
            "-c",
            "openssl dgst -binary -" + algorithm + " \"" + document + "\" | openssl enc -base64"
        ];
        expected["DigestValue"] = ip.utils.safeExec(cmd);
        return expected;
    };
    config.ip.signature.xades['extract'] = function(path) {
        var prefix = "/Signature/Object/QualifyingProperties/SignedProperties/SignedSignatureProperties",
            content = karate.read("file://" + path);
        return {
            City: karate.xmlPath(content, prefix + "/SignatureProductionPlaceV2/City/text()"),
            PostalCode: karate.xmlPath(content, prefix + "/SignatureProductionPlaceV2/PostalCode/text()"),
            CountryName: karate.xmlPath(content, prefix + "/SignatureProductionPlaceV2/CountryName/text()"),
            ClaimedRole: karate.xmlPath(content, prefix + "/SignerRoleV2/ClaimedRoles/ClaimedRole/text()")
        };
    };
    // @todo-karate: meilleurs vérifications
    config.ip.signature.xades['validate'] = function(document, xades, certificate) {
        certificate = (typeof certificate === "undefined") ? karate.toAbsolutePath(ip.templates.certificate.default("signature")["public"]) : certificate;
        var actualData = ip.signature.xades.actual(document, xades, certificate),
            actualXml = karate.read("file://" + xades),
            expectedSchema = karate.read("classpath:lib/ip5/schemas/xades.xml"),
            expectedData = ip.signature.xades.expected(document, xades, certificate),
            result;

        // 1. Vérification du schéma
        karate.set({actualXml: actualXml, expectedSchema: expectedSchema});
        result = karate.match("actualXml == expectedSchema");
        if (result.pass !== true) {
            karate.fail(result.message);
        }
        // 2. Vérification de certaines données
        karate.set({actualData: actualData, expectedData: expectedData});
        result = karate.match("actualData == expectedData");
        if (result.pass !== true) {
            karate.fail(result.message);
        }
    };

    return config;
}
