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

function fn(config) {
    config['ip4'] = config['ip4'] || {};
    config.ip4['business'] = config.ip4['business'] || {};
    config.ip4.business['api'] = config.ip4.business['api'] || {};

    // REST API desktop lib
    config.ip4.business.api['desktop'] = {};
    config.ip4.business.api.desktop['getByName'] = function(name, asAdmin) {
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/ip4/business/api/desktop/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.desktop;
    };
    config.ip4.business.api.desktop['getAllIdsByName'] = function(names, asAdmin) {
        var idx, result = [], rv;
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        for (idx = 0;idx < names.length;idx++) {
            rv = karate.call('classpath:lib/ip4/business/api/desktop/getByName.feature', { "name": names[idx], "asAdmin": asAdmin });
            result.push(rv.desktop.id);
        }
        return result;
    };

    // REST API folder lib
    config.ip4.business.api['folder'] = {};
    config.ip4.business.api.folder['customSignature'] = function(desktop, folder, positions) {
        // @todo: positions array|object
        var idx;
        for(idx=0;idx<folder.documents.length;idx++) {
            karate.call('classpath:lib/ip4/business/api/folder/customSignature.feature', {desktop: desktop, folder: folder, document: folder.documents[idx], positions: positions});
        }
    };
    config.ip4.business.api.folder['download'] = function(desktop, state, name) {
        var params = { "desktop": desktop, "state": state, "title": name },
            rv = karate.call('classpath:lib/ip4/business/api/folder/downloadFiles.feature', params);
        return rv.download;
    };
    config.ip4.business.api.folder['getById'] = function(deskId, folderId) {
        var rv = karate.call('classpath:lib/ip4/business/api/folder/getById.feature', { "deskId": deskId, "folderId": folderId });
        return rv.response;
    };
    config.ip4.business.api.folder['getByName'] = function(deskId, corbeilleName, name) {
        var rv = karate.call('classpath:lib/ip4/business/api/folder/getByName.feature', { "deskId": deskId, "corbeilleName": corbeilleName, "name": name });
        return rv.folder;
    };

    // REST API metadata lib
    config.ip4.business.api['metadata'] = {};
    config.ip4.business.api.metadata['getById'] = function(id, asAdmin) {
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/ip4/business/api/metadata/getById.feature', { "id": id, "asAdmin": asAdmin });
        return rv.metadata;
    };

    // REST API pastellConnector lib
    config.ip4.business.api['pastellConnector'] = {};
    config.ip4.business.api.pastellConnector['getByName'] = function(name, asAdmin) { //@todo: asAdmin ?
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/ip4/business/api/pastellConnector/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.pastellConnector;
    };

    // REST API seal lib
    config.ip4.business.api['seal'] = {};
    config.ip4.business.api.seal['getByName'] = function(name, asAdmin) { //@todo: asAdmin ?
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/ip4/business/api/seal/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.seal;
    };

    // REST API type lib
    config.ip4.business.api['type'] = {};
    config.ip4.business.api.type['getByName'] = function(name, asAdmin) {
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/ip4/business/api/type/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.type;
    };

    // REST API user lib
    config.ip4.business.api['user'] = {};
    config.ip4.business.api.user['login'] = function(username, password) {
        // @see https://github.com/karatelabs/karate#call-vs-read
        return karate.call(true, 'classpath:lib/ip4/business/api/user/login.feature', { "username": username, "password": password });
    };

    // REST API entité "Formats de signature"
    config.ip4.business['formatsDeSignature'] = {};
    config.ip4.business.formatsDeSignature['download'] = function(state, name) {
        var desktop;
        if (state === "a-archiver") {
            ip4.business.api.user.login("ws@fds", "a123456");
            desktop = "WebService";
        } else {
            // @todo
        }
        return ip4.business.api.folder.download(desktop, state, name);
    };
    config.ip4.business.formatsDeSignature['seal'] = function(type, subtype, name, files, positions) {
        var params = {
            mainFiles: files,
            type: type,
            subtype: subtype,
            name: name
        };
        if (typeof positions !== "undefined") {
            params["positions"] = positions;
        }
        karate.call("classpath:lib/ip4/business/Formats de signature/createSendAndSealFolderNormal.feature", params);
        karate.call("classpath:lib/ip4/business/Formats de signature/createSendAndSealFolderSurcharge.feature", params);
    };
    config.ip4.business.formatsDeSignature['sign'] = function(type, subtype, name, files, positions) {
        var params = {
            mainFiles: files,
            type: type,
            subtype: subtype,
            name: name
        };
        if (typeof positions !== "undefined") {
            params["positions"] = positions;
        }
        karate.call("classpath:lib/ip4/business/Formats de signature/createSendAndSignFolderNormal.feature", params);
        karate.call("classpath:lib/ip4/business/Formats de signature/createSendAndSignFolderSurcharge.feature", params);
    };

    config.ip4['signature'] = config.ip4['signature'] ? config.ip4['signature'] : {};
    config.ip4.signature['pades'] = config.ip4.signature['pades'] ? config.ip4.signature['pades'] : {};
    config.ip4.signature.pades['annotations'] = config.ip4.signature.pades['annotations'] ? config.ip4.signature.pades['annotations'] : {};
    config.ip4.signature.pades.annotations['default'] = function(position, line1, line2) {
        var text = [];
        if (typeof line1 !== "undefined" || typeof line2 !== "undefined") {
            text = [
                "Signé électroniquement par : " + line1,
                "#regex Date de signature : [0-9]{1,2}/[0-9]{2}/[0-9]{4}",
                "Qualité : " + line2
            ];
        }
        return {
            "position": position,
            "text": text
        };
    };
    config.ip4.signature.pades['images'] = config.ip4.signature.pades['images'] ? config.ip4.signature.pades['images'] : {};
    config.ip4.signature.pades.images['expected'] = function(username) {
        return {
            "/Im1": karate.toAbsolutePath("classpath:files/images/grigris/v4/" + username + "/Im1.png")
        };
    };
    config.ip4.signature['xades'] = config.ip4.signature['xades'] || {};
    config.ip4.signature.xades['actual'] = function(document, xades) {
        var actual = {},
            content = karate.read("file://" + xades);

        // 1. Partie publique dans ds:X509Certificate
        actual["X509Certificate"] = karate.xmlPath(content, "/Signature/KeyInfo/X509Data/X509Certificate/text()");

        // 2. DigestValue du document signé
        actual["DigestValue"] = karate.xmlPath(content, "/Signature/SignedInfo/Reference/DigestValue/text()")[0];

        return actual;
    };
    config.ip4.signature.xades['expected'] = function(document, xades, certificate) {
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
    config.ip4.signature.xades['extract'] = function(path) {
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
    config.ip4.signature.xades['validate'] = function(document, xades, certificate) {
        certificate = (typeof certificate === "undefined") ? karate.toAbsolutePath(ip.templates.certificate.default("signature")["public"]) : certificate;
        var actualData = ip4.signature.xades.actual(document, xades, certificate),
            actualXml = karate.read("file://" + xades),
            expectedSchema = karate.read("classpath:lib/ip4/schemas/xades.xml"),
            expectedData = ip4.signature.xades.expected(document, xades, certificate),
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
    config.ip4['utils'] = {};
    config.ip4.utils['folder'] = {};
    // @todo: faire pour v4
    config.ip4.utils.folder['download'] = function (folder) {
        // karate.log("---------------------");
        // karate.log(folder);
        // karate.log("---------------------");
        var basePath = "ip4-folders/" + folder.title.replace(/(:|\/)/, '_') + " - " + folder.id,
            content,
            detached,
            document,
            idxDet,
            idxDoc,
            idxStep,
            path,
            result = [],
            url;
        // @todo: essayer une étape de création avec le premier document, puis ajouter les autres documents, puis ajouter les signature détachées, puis les annexes
        for(idxDoc=0;idxDoc<folder.documents.length;idxDoc++) {
            // Document
            document = folder.documents[idxDoc];
            url = "/iparapheur/proxy/alfresco/api/node/workspace/SpacesStore/" + document.id + "/content/" + document.name;
            content = karate.call('classpath:lib/ip/get.feature', { url: url });
            if (document.isMainDocument === true) {
                path = document.name;
                karate.write(content.bytes, basePath + "/" + path);
                result.push(path);
            } else {
                // @fixme: téléchargement des annexes dans le bon sous-dossier
                path = "annexes/" + document.name;
                karate.write(content.bytes, basePath + "/" + path);
                result.push(path);
            }
            // Detached signatures
            var rv = karate.call('classpath:lib/ip4/business/api/folder/getWorkflow.feature', { folderId: folder.id });
            var Base64 = Java.type('java.util.Base64');
            var decoded, ext, step;
            // @todo: les autres + si multidoc ?
            if(rv.response.circuit.sigFormat === "PKCS#7/single") {
                ext = "p7s";
            } else if(rv.response.circuit.sigFormat === "XAdES/detached") {
                ext = "xml";
            } else { // @todo
                ext = "xml";
            }
            for(idxStep=0;idxStep<rv.response.circuit.etapes.length;idxStep++) {
                step = rv.response.circuit.etapes[idxStep];
                if(step.signed === true) {
                    //ids.push(rv.response.circuit.etapes[idxStep].id);
                    decoded = Base64.getDecoder().decode(step.signatureEtape);
                    path = document.name.replace(/\.[^\.]+$/, "") + "-" + idxStep + "-" + step.signataire + "." + ext;
                    karate.write(decoded, basePath + "/" + path);
                    result.push(path);
                }
            }
        }

        // karate.log(content)

        return { base: buildDir + "/" + basePath, files: result };
    };
    config.ip4.utils.folder['signatures'] = function(path, list) {
        karate.log({path: path, list: list});
        var idx, result = { signature: [], signatureDateTime: [] };
        for (idx = 0;idx<list.length;idx++) {
            result.signature.push(ip.utils.certificate.signHash(path, list[idx].dataToSignBase64List));
            result.signatureDateTime.push(list[idx].signatureDateTime);
        }
        return result;
    };

    return config;
}
