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
    // @todo: ip5.step.api.desktop.getByName (exemple + v4, pour distinguer des appels API "purs")
    config['v5'] = {};
    config.v5['business'] = {};
    config.v5.business['api'] = {};

    // REST API desktop lib
    config.v5.business.api['desktop'] = {};
    config.v5.business.api.desktop['getByName'] = function(tenantId, name) {
        var rv = karate.call('classpath:lib/v5/business/api/desktop/getByName.feature', { "tenantId": tenantId, "name": name });
        return rv.desktop;
    };

    // REST API folder lib
    config.v5.business.api['folder'] = {};
    config.v5.business.api.folder['getByName'] = function(tenantId, deskId, state, name) {
        var rv = karate.call('classpath:lib/v5/business/api/folder/getByName.feature', { "tenantId": tenantId, "deskId": deskId, "state": state, "name": name });
        return rv.folder;
    };

    // REST API tenant lib
    config.v5.business.api['tenant'] = {};
    config.v5.business.api.tenant['getByName'] = function(name, withAdminRights) {
        withAdminRights = (typeof withAdminRights === "undefined") ? false : withAdminRights;
        var rv = karate.call('classpath:lib/v5/business/api/tenant/getByName.feature', { "name": name, "withAdminRights": withAdminRights });
        return rv.tenant;
    };

    config.v5['utils'] = {};
    config.v5.utils['folder'] = {};
    config.v5.utils.folder['signatures'] = function(path, list) {
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
                    signatureBase64: utils.certificate.signHash(path, list[idx].dataToSignList[idxDataToSignList].dataToSignBase64)
                });
            }

            row = {
                folderId: list[idx].folderId,
                documentId: list[idx].documentId,
                dataToSignList: rowDataToSignList,
                signatureDateTime: list[idx].signatureDateTime
            };
            result.push(row);
        }
        return result;
    };

    return config;
}
