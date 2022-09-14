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

    config.ip4['signature'] = config.ip4['signature'] ? config.ip4['signature'] : {};
    config.ip4.signature['pades'] = config.ip4.signature['pades'] ? config.ip4.signature['pades'] : {};
    config.ip4.signature.pades['annotations'] = config.ip4.signature.pades['annotations'] ? config.ip4.signature.pades['annotations'] : {};
    config.ip4.signature.pades.annotations['default'] = function(position, line1, line2) {
        return {
            "position": position,
            "text":[
                "Signé électroniquement par : " + line1,
                "#regex Date de signature : [0-9]{1,2}/[0-9]{2}/[0-9]{4}",
                "Qualité : " + line2
            ]
        };
    };

    config.ip4['utils'] = {};
    config.ip4.utils['folder'] = {};
    config.ip4.utils.folder['signatures'] = function(path, list) {
        var idx, result = { signature: [], signatureDateTime: [] };
        for (idx = 0;idx<list.length;idx++) {
            result.signature.push(ip.utils.certificate.signHash(path, list[idx].dataToSignBase64List));
            result.signatureDateTime.push(list[idx].signatureDateTime);
        }
        return result;
    };

    return config;
}
