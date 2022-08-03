/*
 * iparapheur
 * Copyright (C) 2019-2022 Libriciel SCOP
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
namespace(config, 'ip.signature.pades.certificates.read', function(path) {});
namespace(config, 'ip.signature.pades.certificates.default', function(alias) {});
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
        certificate = (typeof certificate === "undefined") ? karate.toAbsolutePath(templates.certificate.default("signature")["public"]) : certificate;
        var cmd = [
            "/bin/sh",
            "-c",
            "openssl smime -verify -binary -inform PEM -in \"" + pkcs7 + "\" -content \"" + document + "\" -certfile \"" + certificate + "\" -nointern -noverify > /dev/null"
        ];
        utils.safeExec(cmd);
    };

    config.ip.signature['helios'] = config.ip.signature['helios'] || {};
    config.ip.signature.helios['validate'] = function(document) {
        var classpath = "classpath:xsd/schemas_pes_v5.11/PES_V2/Rev0/PES_Aller.xsd",
            output,
            schema = karate.toAbsolutePath(classpath);
        var cmd = [
            "/bin/sh",
            "-c",
            "xmllint --schema \"" + schema + "\" \"" + document + "\" --noout"
        ];
        output = utils.safeExec(cmd);
        if (output.match(/.xml validates$/) === null) {
            karate.fail('XML document does not validate with schema at ' + classpath + ': ' + document);
        }
    };
    config.ip.signature.helios['extract'] = function(path) {
        var prefix = "/PES_Aller/Signature/Object/QualifyingProperties/SignedProperties/SignedSignatureProperties",
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
        var cmd = ["python3", karate.toAbsolutePath("classpath:python/get_signatures_fields.py"), "annotations", path],
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
    config.ip.signature.pades.annotations['default'] = function(position, line1, line2) {
        return {
            "position": position,
            "text":[
                line1,
                line2,
                v5.business.regexp.annotation.date
            ]
        };
    };
    config.ip.signature.pades['certificates'] = config.ip.signature.pades['certificates'] || {};
    config.ip.signature.pades.certificates['read'] = function (path) {
        var cmd = [ "pdfsig", "-nocert", path ],
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

        for (idx=0;idx<lines.length;idx++) {
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
        for (idx=0;idx<result.length;idx++) {
            delete result[idx].timestamp;
        }

        return result;
    };
    config.ip.signature.pades.certificates['default'] = function(alias, wholeDocumentSigned, valid) {
        valid = typeof valid === "undefined" ? true : valid;
        wholeDocumentSigned = typeof wholeDocumentSigned === "undefined" ? true : wholeDocumentSigned;

        if (alias === "signature-user") {
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
            var msg = "No ip.signature.pades.certificates.default for the \"" + alias + "\" alias. Use one of: signature-user, signature-cnoir";
            karate.log(msg);
            karate.fail(msg);
        }
    };
    config.ip.signature.pades['fields'] = config.ip.signature.pades['fields'] || {};
    config.ip.signature.pades.fields['read'] = function (path) {
        var cmd = ["python3", karate.toAbsolutePath("classpath:python/get_signatures_fields.py"), "signatures", path],
            idx,
            lines,
            matches,
            proc,
            result = [],
            fields = {};
        proc = karate.fork(cmd);
        proc.waitSync();
        /*if (proc.exitCode !== 0) {
            karate.fail('Got status code ' + proc.exitCode + ' for command ' + command);
        }*/
        tmp = proc.sysOut.replace(/\n$/, '');
        lines = tmp.split(/\r?\n/).filter(element => element);

        for (idx=0;idx<lines.length;idx++) {
            if (matches = lines[idx].match(/^- ([0-9]+):$/)) {
                if (karate.keysOf(fields).length > 0) {
                    result.push(fields);
                }
                fields = {};
            } else if(matches = lines[idx].match(/^\s+- Signed By: (.*)$/)) {
                fields["signedBy"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Reason: (.*)$/)) {
                fields["reason"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Location: (.*)$/)) {
                fields["location"] = matches[1];
            }
        }

        if (karate.keysOf(fields).length > 0) {
            result.push(fields);
        }

        return result;
    };
    config.ip.signature.pades.fields['default'] = function(signedBy, reason, location) {
        return {
            "signedBy": signedBy,
            "reason": reason,
            "location": location
        };

        return config;
    };

    return config;
}
