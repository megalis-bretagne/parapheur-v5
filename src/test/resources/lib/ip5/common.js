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
    // @todo: ip5.business.api.desktop.getByName (exemple + v4, pour distinguer des appels API "purs")
    // @todo: ajouter les paquets nécessaire pour l'intégration continue + dans le README-karate
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

    config.ip5['business'] = config.ip5['business'] || {};
    config.ip5.business['api'] = config.ip5.business['api'] || {};

    // REST API desktop lib
    config.ip5.business.api['desktop'] = {};
    config.ip5.business.api.desktop['getByName'] = function(tenantId, name) {
        var rv = karate.call('classpath:lib/ip5/business/api/desktop/getByName.feature', { "tenantId": tenantId, "name": name });
        return rv.desktop;
    };

    config.ip5.business.api['draft'] = {};
    config.ip5.business.api.draft['addDetachedSignature'] = function(folder, params, file, path) {
        var document = { id: ip5.utils.getDraftDocumentId(folder, file) };//@todo: whole document
        return karate.call(
            'classpath:lib/ip5/business/api/draft/addDetachedSignature.feature',
            {
                tenant: params.tenant,
                desktop: params.desktop,
                folder: folder,
                document: document,
                file: path
            }
        );
    };
    config.ip5.business.api.draft['createAndSendSimple'] = function(args) {
        // @todo: annexes
        var idx,
            params = karate.call('classpath:lib/ip5/business/api/draft/params.feature', args)
            draft = ip5.business.api.draft.createSimple(params, args.mainFiles), rv;
        if (typeof args.mainFiles[0].detached !== "undefined") {
            ip5.business.api.draft.addDetachedSignature(draft, params, ip.commonpath.get(args.mainFiles[0].file), ip.commonpath.get(args.mainFiles[0].detached));
        }

        if (args.mainFiles.length > 1) {
            for(idx=1;idx<args.mainFiles.length;idx++) {
                karate.call(
                    'classpath:lib/ip5/business/api/draft/addMainDocument.feature',
                    { tenant: params.tenant, draft: draft, file: ip.commonpath.get(args.mainFiles[idx].file) }
                );
            }
            rv = karate.call(
                'classpath:lib/ip5/business/api/draft/getById.feature',
                { tenant: params.tenant, draft: draft, desktop: params.desktop }
            );
            draft = rv.response;
            for(idx=1;idx<args.mainFiles.length;idx++) {
                if (typeof args.mainFiles[idx].detached !== "undefined") {
                    ip5.business.api.draft.addDetachedSignature(draft, params, ip.commonpath.get(args.mainFiles[idx].file), ip.commonpath.get(args.mainFiles[idx].detached));
                }
            }
        }
        karate.call('classpath:lib/ip5/business/api/draft/send.feature', karate.merge(args, { draft: draft, path: params.path }));
    };
    config.ip5.business.api.draft['createSimple'] = function(params, mainFiles) {
        var rv = karate.call('classpath:lib/ip5/business/api/draft/createSimple.feature', { params: params, mainFiles: mainFiles } );
        return rv.folder;
    };
    // REST API folder lib
    config.ip5.business.api['folder'] = {};
    config.ip5.business.api.folder['download'] = function(tenant, desktop, state, name) {
        var params = { "tenant": tenant, "desktop": desktop, "state": state, "name": name },
            rv = karate.call('classpath:lib/ip5/business/api/folder/downloadFiles.feature', params);
        return rv.download;
    };
    // @deprecated
    config.ip5.business.api.folder['downloadFiles'] = function(tenant, desktop, state, name) {
        var params = { "tenant": tenant, "desktop": desktop, "state": state, "name": name },
            rv = karate.call('classpath:lib/ip5/business/api/folder/downloadFiles.feature', params);
        return rv.files;
    };
    config.ip5.business.api.folder['getByName'] = function(tenantId, deskId, state, name) {
        var rv = karate.call('classpath:lib/ip5/business/api/folder/getByName.feature', { "tenantId": tenantId, "deskId": deskId, "state": state, "name": name });
        return rv.folder;
    };
    config.ip5.business.api.folder['getDetails'] = function(tenantId, desktopId, folderId) {
        var rv = karate.call('classpath:lib/ip5/business/api/folder/getDetails.feature', { "tenantId": tenantId, "desktopId": desktopId, "folderId": folderId });
        return rv.folder;
    };

    // REST API tenant lib
    config.ip5.business.api['tenant'] = {};
    config.ip5.business.api.tenant['getByName'] = function(name, withAdminRights) {
        withAdminRights = (typeof withAdminRights === "undefined") ? false : withAdminRights;
        var rv = karate.call('classpath:lib/ip5/business/api/tenant/getByName.feature', { "name": name, "withAdminRights": withAdminRights });
        return rv.tenant;
    };

    // REST API "Formats de signature" lib
    config.ip5.business['formatsDeSignature'] = {};
    config.ip5.business.formatsDeSignature['download'] = function(state, name) {
        var desktop;
        if (state === "finished") {
            api_v1.auth.login("ws-fds", "a123456");
            desktop = "WebService";
        } else {
            // @todo
        }
        return ip5.business.api.folder.download("Formats de signature", desktop, state, name);
    };
    config.ip5.business.formatsDeSignature['seal'] = function(type, subtype, name, files, positions) {
        var params = {
                mainFiles: files,
                type: type,
                subtype: subtype,
                name: name
            };
        if (typeof positions !== "undefined") {
            params["positions"] = positions;
        }
        karate.call("classpath:lib/ip5/business/Formats de signature/createSendAndSealFolderNormal.feature", params);
        karate.call("classpath:lib/ip5/business/Formats de signature/createSendAndSealFolderSurcharge.feature", params);
    };
    config.ip5.business.formatsDeSignature['sign'] = function(type, subtype, name, files, positions) {
        var params = {
                mainFiles: files,
                type: type,
                subtype: subtype,
                name: name
            };
        if (typeof positions !== "undefined") {
            params["positions"] = positions;
        }
        karate.call("classpath:lib/ip5/business/Formats de signature/createSendAndSignFolderNormal.feature", params);
        karate.call("classpath:lib/ip5/business/Formats de signature/createSendAndSignFolderSurcharge.feature", params);
    };
    config.ip5.business["regexp"] = {};
    config.ip5.business.regexp["annotation"] = {};
    config.ip5.business.regexp.annotation["date"] = "#regex [0-9]{1,2} (janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre|janv\.|févr\.|mars|avr\.|mai|juin|juil\.|août|sept\.|oct\.|nov\.|déc\.) [0-9]{4}";

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

    // ---------------------------------------------------------------------------------------------------------------------------------------------------------

    config.ip5.business["ui"] = {};

    config.ip5.business.ui["metadatas"] = {};

    config.ip5.business.ui.metadatas["fill"] = function(metadatas, labels, types, base) {
        var name, metadata;

        base = typeof base !== "undefined" ? base : "//ngb-modal-window//app-metadata-form";
        labels = typeof labels !== "undefined" ? labels : ip.metadatas.labels;
        types = typeof types !== "undefined" ? labels : ip.metadatas.types;

        ip.ui.expect(base);

        for (name in metadatas) {
            metadata = {
                value: metadatas[name],
                type: types[name],
                xpath: base + "//label[normalize-space(text())='" + labels[name] + "']/parent::div/app-metadata-input",
                dateXpath: null,
                inputXpath: null,
                selectArrowXpath: null,
                selectXpath: null
            };
            metadata.dateXpath = metadata.xpath + "//input[(@type='date') and not(@readonly)]";
            metadata.inputXpath = metadata.xpath + "//input[(@type='number' or @type='text' or @type='url') and not(@readonly)]";
            metadata.selectXpath = metadata.xpath + "//ng-select";

            ip.ui.expect(metadata.xpath).mouse().go();
            scroll(metadata.xpath);

            // 1. ng-select
            if (exists(metadata.selectXpath) === true) {
                karate.log("... ng-select found: " + metadata.selectXpath);

                if (metadata.type === "BOOLEAN") {
                    if (metadata.value === true) {
                        metadata.value = "Oui";
                    } else if (metadata.value === false) {
                        metadata.value = "Non";
                    }
                } else if (metadata.type === "DATE") {
                    metadata.value = metadata.value.replace(/^(....)-(..)-(..)$/, "$3/$2/$1");
                } else if (metadata.type === "FLOAT") {
                    metadata.value = metadata.value.toFixed(1);//@todo: not always 1
                }

                ip5.ui.ngSelect(metadata.selectXpath, metadata.value);
            } else if (exists(metadata.inputXpath) === true) {
                karate.log("... input found: " + metadata.inputXpath);
                input(metadata.inputXpath, String(metadata.value));
            } else if (exists(metadata.dateXpath) === true) {
                karate.log("... date found: " + metadata.dateXpath);
                input(metadata.dateXpath, metadata.value.replace(/^(....)-(..)-(..)$/, "$3/$2/$1"));
            } else {
                karate.fail("Unhandled metadate field type for \"" + name + "\" (accepted: ng-select, input[type=date,number,text,url]): " + html(metadata.xpath));
            }
        }
    };

    return config;
}
