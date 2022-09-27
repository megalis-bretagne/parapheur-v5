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
    config['ip5'] = config['ip5'] || {};

    config.ip5['downloadpath'] = {};
    // @todo: fail si le jsonPath ne retourne rien
    config.ip5.downloadpath['annexe'] = function(files, basename, prefix) {
        prefix = typeof prefix === "undefined" ? "file://" : prefix;
        return prefix + buildDir + karate.jsonPath(files, "$.annexes['" + basename +"']");
    };
    config.ip5.downloadpath['detached'] = function(files, basename, prefix) {
        prefix = typeof prefix === "undefined" ? "file://" : prefix;
        return prefix + buildDir + karate.jsonPath(files, "$.documents[*][*].detached['" + basename +"']");
    };
    config.ip5.downloadpath['document'] = function(files, basename, prefix) {
        prefix = typeof prefix === "undefined" ? "file://" : prefix;
        return prefix + buildDir + karate.jsonPath(files, "$.documents[*]['" + basename +"'].path");
    };
    config.ip5.downloadpath['readAnnexe'] = function(files, basename, prefix) {
        return karate.read(ip5.downloadpath.annexe(files, basename, prefix));
    };
    config.ip5.downloadpath['readDetached'] = function(files, basename, prefix) {
        return karate.read(ip5.downloadpath.detached(files, basename, prefix));
    };
    config.ip5.downloadpath['readDocument'] = function(files, basename, prefix) {
        return karate.read(ip5.downloadpath.document(files, basename, prefix));
    };

    config.ip5['log'] = function(message) {
        karate.log('message : ' + message);
    };

    //==================================================================================================================
    // Scenario titles
    //==================================================================================================================
    config.ip5['scenario'] = {'title': {}};

    config.ip5.scenario.title['existing'] = function(exists){
        return exists == true ? 'an existing' : 'a non existing';
    };

    config.ip5.scenario.title['role'] = function(role){
        return role !== '' && role !== null ? 'a user with the role "' + role + '"' : 'an unauthenticated user';
    };

    config.ip5.scenario.title['permissions'] = function(role, target, status){
        role = ip5.scenario.title.role(ip.utils.string.normalize(role));
        status = ip5.scenario.title.status(status);
        target = ip.utils.string.normalize(target);

        return 'Permissions - ' + role + ' ' + status + ' ' + target;
    };

    config.ip5.scenario.title['validation'] = function(role, target, status, data){
        role = ip5.scenario.title.role(ip.utils.string.normalize(role));
        status = ip5.scenario.title.status(status);
        target = ip.utils.string.normalize(target);

        return 'Data validation - ' + role + ' ' + status + ' ' + target + ' with ' + String(data);
    };

    config.ip5.scenario.title['searching'] = function(role, target, status, total, searchTerm = null, sort = null, direction = null){
        role = ip5.scenario.title.role(ip.utils.string.normalize(role));
        searchTerm = ip.utils.string.normalize(searchTerm);
        status = ip5.scenario.title.status(status);
        target = ip.utils.string.normalize(target);

        return 'Searching - ' + role + ' ' + status + ' '
            + target
            + ( searchTerm === '' ? '' : ' filtered with "' + searchTerm + '"' ) + ' '
            + ip5.scenario.title.sorted(sort, direction)
            + ' and obtain ' + total + ' ' + (total < 2 ? 'result' : 'results') + ' '
            ;
    };

    config.ip5.scenario.title['sorted'] = function(field = null, direction = null){
        field = ip.utils.string.normalize(field);

        if (field === '' || ip.utils.string.normalize(direction) === '') {
            return '';
        } else {
            return 'sorted by ' + field + ' ' + (direction === 'ASC' ? 'ascending' : 'descending');
        }
    };

    config.ip5.scenario.title['status'] = function(status){
        return String(status).match(/^[2-3]/) ? 'can' : 'cannot';
    };

    config.ip5['utils'] = {};
    config.ip5.utils['folder'] = {};
    // @todo: faire pour v4
    config.ip5.utils.folder['download'] = function (tenant, folder) {
        var basePath = "ip5-folders/" + folder.name.replace(/(:|\/)/, '_') + " - " + folder.id,
            content,
            detached,
            document,
            idxDet,
            idxDoc,
            path,
            result = [],
            url;
        // @todo: essayer une étape de création avec le premier document, puis ajouter les autres documents, puis ajouter les signature détachées, puis les annexes
        for(idxDoc=0;idxDoc<folder.documentList.length;idxDoc++) {
            // Document
            document = folder.documentList[idxDoc];
            url = "/api/v1/tenant/" + tenant.id + "/folder/" + folder.id + "/document/" + document.id;
            content = karate.call('classpath:lib/ip/get.feature', { url: url });
            if (document.isMainDocument === true) {
                path = document.name;
                //karate.write(content.bytes, basePath + "/" + path);
                result.push(path);
            } else {
                // @fixme: téléchargement des annexes dans le bon sous-dossier
                path = "annexes/" + document.name;
                //karate.write(content.bytes, basePath + "/" + path);
                result.push(path);
            }

            // Detached signatures
            for(idxDet=0;idxDet<document.detachedSignatures.length;idxDet++) {
                detached = document.detachedSignatures[idxDet];
                url = "/api/v1/tenant/" + tenant.id + "/folder/" + folder.id + "/document/" + document.id + "/detachedSignature/" + detached.id;
                content = karate.call('classpath:lib/ip/get.feature', { url: url });
                path = detached.name;
                //karate.write(content.bytes, basePath + "/" + path);
                result.push(path);
            }
        }
        return { base: buildDir + "/" + basePath, files: result };
        //----------------------------------------------------------------------
    };

    // @deprecated
    config.ip5.utils.folder['downloadFiles'] = function (tenant, folder) {
        var basePath = "ip5-folders/" + folder.name.replace(/(:|\/)/, '_') + " - " + folder.id,
            content,
            detached,
            document,
            idxDet,
            idxDoc,
            path,
            result = { documents: [], annexes: {} },
            row = {},
            url;
        // @todo: vérifier que les fichiers n'existent pas (en cas de mauvais nommage des fichiers par exemple)
        // @todo: essayer une étape de création avec le premier document, puis ajouter les autres documents, puis ajouter les signature détachées, puis les annexes
        // @todo: du coup, on pourrait simplifier le retour
        // { files: { name: path }, detached: { name: path }, annexes: { name: path } }
        // ...teamplates.ip.ui.expect(["document_rtf.rtf"], ["document_rtf-0-signature_externe.p7s"])
        for(idxDoc=0;idxDoc<folder.documentList.length;idxDoc++) {
            row = {};

            // Document
            document = folder.documentList[idxDoc];
            url = "/api/v1/tenant/" + tenant.id + "/folder/" + folder.id + "/document/" + document.id;
            content = karate.call('classpath:lib/ip/get.feature', { url: url });
            if (document.isMainDocument === true) {
                //path = basePath + "/" + idxDoc + "/" + document.name;
                path = basePath + "/" + document.name;
                karate.write(content.bytes, path);
                row[document.name] = { path: path, detached: {} };
            } else {
                path = basePath + "/annexes/" + document.name;
                karate.write(content.bytes, path);
                result["annexes"][document.name] = path;
            }

            // Detached signatures
            // @todo: renommer les signatures détachées ?
            for(idxDet=0;idxDet<document.detachedSignatures.length;idxDet++) {
                detached = document.detachedSignatures[idxDet];
                url = "/api/v1/tenant/" + tenant.id + "/folder/" + folder.id + "/document/" + document.id + "/detachedSignature/" + detached.id;
                content = karate.call('classpath:lib/ip/get.feature', { url: url });
                // path = basePath + "/" + idxDoc + "/detached/" + detached.name;
                path = basePath + "/" + detached.name;
                karate.write(content.bytes, path);
                row[document.name]["detached"][detached.name] = path;
            }

            if (karate.keysOf(row).length > 0) {
                result.documents.push(row);
            }
        }
        return result;
    };

    config.ip5.utils.folder['signatures'] = function(path, list) {
        var Base64 = Java.type('java.util.Base64'),
            hash,
            idx,
            idxDataToSignList,
            result = [],
            row = {},
            rowDataToSignList;

        for (idx = 0;idx<list.length;idx++) {
            rowDataToSignList = [];
            for(idxDataToSignList=0;idxDataToSignList<list[idx].dataToSignList.length;idxDataToSignList++) {
                rowDataToSignList.push({
                    id: list[idx].dataToSignList[idxDataToSignList].id,
                    dataToSignBase64: list[idx].dataToSignList[idxDataToSignList].dataToSignBase64,
                    digestBase64: null,
                    signatureValue: ip.utils.certificate.signHash(path, list[idx].dataToSignList[idxDataToSignList].dataToSignBase64)
                });
            }

            row = {
                documentId: list[idx].documentId,
                dataToSignList: rowDataToSignList,
                signatureDateTime: list[idx].signatureDateTime
            };
            result.push(row);
        }
        return result;
    };

    config.ip5.utils['getDraftDocumentId'] = function (response, fileName) {
        fileName = ip.utils.file.basename(fileName);
        for (var idx = 0;idx < response.documentList.length;idx++) {
            if (fileName === response.documentList[idx].name && response.documentList[idx].id !== null) {
                return response.documentList[idx].id;
            }
        }
        return null;
    };

    return config;
}
