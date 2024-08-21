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

function fn(config) {
    config['ip5'] = config['ip5'] || {};
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
        let params = karate.call('classpath:lib/ip5/business/api/draft/params.feature', args);

        let draftCreationResult = ip5.business.api.draft.createSimple(params, args.mainFiles);

        let getFolderParams  = {
          draft: {id: draftCreationResult.id},
          desktop: params.desktop,
          tenant: params.tenant
        };

        let draft = karate.call('classpath:lib/ip5/business/api/draft/getById.feature', getFolderParams).response;

        if (typeof args.mainFiles[0].detached !== "undefined") {
            ip5.business.api.draft.addDetachedSignature(
                draft, params, ip.commonpath.get(args.mainFiles[0].file),
                ip.commonpath.get(args.mainFiles[0].detached)
            );
        }

        if (args.mainFiles !== undefined && args.mainFiles != null && args.mainFiles.length > 1) {
            for(let i = 1; i < args.mainFiles.length; i++) {
                karate.call(
                    'classpath:lib/ip5/business/api/draft/addMainDocument.feature',
                    { tenant: params.tenant, draft: draft, file: ip.commonpath.get(args.mainFiles[i].file) }
                );
            }
            let rv = karate.call(
                'classpath:lib/ip5/business/api/draft/getById.feature',
                { tenant: params.tenant, draft: draft, desktop: params.desktop }
            );
            draft = rv.response;
            for(let i = 1; i < args.mainFiles.length; i++) {
                if (typeof args.mainFiles[i].detached !== "undefined") {
                    ip5.business.api.draft.addDetachedSignature(draft, params, ip.commonpath.get(args.mainFiles[i].file), ip.commonpath.get(args.mainFiles[i].detached));
                }
            }
        }

        let startRequestPath = '/api/standard/v1/tenant/' + params.tenant.id + '/desk/' + params.desktop.id + '/folder/' + draftCreationResult.id + '/task/unusedTaskId/start';
        karate.call('classpath:lib/ip5/business/api/draft/send.feature', karate.merge(args, { draft: draft, path: startRequestPath }));
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
            ip5.api.v1.auth.login("ws-fds", "Ilenfautpeupouretreheureux");
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
        let params = {
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

    config.ip5.business["ui"] = {};
    config.ip5.business.ui["metadatas"] = {};

    config.ip5.business.ui.metadatas["fill"] = function(metadatas, labels, types, base) {
        var name, metadata;

        base = typeof base !== "undefined" ? base : "//ngb-modal-window//app-metadata-form";
        labels = typeof labels !== "undefined" ? labels : ip.business.metadonnees.labels;
        types = typeof types !== "undefined" ? labels : ip.business.metadonnees.types;

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
