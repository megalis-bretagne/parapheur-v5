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
    config['v4'] = {};
    config.v4['api'] = {};
    config.v4.api['rest'] = {};

    // REST API desktop lib
    config.v4.api.rest['desktop'] = {};
    config.v4.api.rest.desktop['getByName'] = function(name, asAdmin) {
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/v4/api/rest/desktop/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.desktop;
    };
    config.v4.api.rest.desktop['getAllIdsByName'] = function(names, asAdmin) {
        var idx, result = [], rv;
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        for (idx = 0;idx < names.length;idx++) {
            rv = karate.call('classpath:lib/v4/api/rest/desktop/getByName.feature', { "name": names[idx], "asAdmin": asAdmin });
            result.push(rv.desktop.id);
        }
        return result;
    };

    // REST API folder lib
    config.v4.api.rest['folder'] = {};
    config.v4.api.rest.folder['getById'] = function(deskId, folderId) {
        var rv = karate.call('classpath:lib/v4/api/rest/folder/getById.feature', { "deskId": deskId, "folderId": folderId });
        return rv.response;
    };
    config.v4.api.rest.folder['getByName'] = function(deskId, corbeilleName, name) {
        var rv = karate.call('classpath:lib/v4/api/rest/folder/getByName.feature', { "deskId": deskId, "corbeilleName": corbeilleName, "name": name });
        return rv.folder;
    };
    /*config.v4.api.rest.folder['sign'] = function(desktop, folder, params) {
        var defaults = {
                annotPub: null,
                annotPriv: null,
                publicCert: null,
                privateCert: null,
            },
            rv;
        params = karate.merge(defaults, params);
        params["desktop"] = desktop;
        params["folder"] = folder;
        rv = karate.call('classpath:lib/v4/api/rest/folder/signSimple.feature', params);
        return rv.response;
    };*/

    // REST API metadata lib
    config.v4.api.rest['metadata'] = {};
    config.v4.api.rest.metadata['getById'] = function(id, asAdmin) {
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/v4/api/rest/metadata/getById.feature', { "id": id, "asAdmin": asAdmin });
        return rv.metadata;
    };

    // REST API pastellConnector lib
    config.v4.api.rest['pastellConnector'] = {};
    config.v4.api.rest.pastellConnector['getByName'] = function(name, asAdmin) { //@todo: asAdmin ?
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/v4/api/rest/pastellConnector/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.pastellConnector;
    };

    // REST API seal lib
    config.v4.api.rest['seal'] = {};
    config.v4.api.rest.seal['getByName'] = function(name, asAdmin) { //@todo: asAdmin ?
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/v4/api/rest/seal/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.seal;
    };

    // REST API type lib
    config.v4.api.rest['type'] = {};
    config.v4.api.rest.type['getByName'] = function(name, asAdmin) {
        asAdmin = typeof asAdmin === 'undefined' ? false : true;
        var rv = karate.call('classpath:lib/v4/api/rest/type/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.type;
    };

    // REST API user lib
    config.v4.api.rest['user'] = {};
    config.v4.api.rest.user['login'] = function(username, password) {
        // @see https://github.com/karatelabs/karate#call-vs-read
        return karate.call(true, 'classpath:lib/v4/api/rest/user/login.feature', { "username": username, "password": password });
    };

    config.v4['utils'] = {};
    config.v4.utils['folder'] = {};
    config.v4.utils.folder['signatures'] = function(path, list) {
        var idx, result = { signature: [], signatureDateTime: [] };
        for (idx = 0;idx<list.length;idx++) {
            result.signature.push(utils.certificate.signHash(path, list[idx].dataToSignBase64List));
            result.signatureDateTime.push(list[idx].signatureDateTime);
        }
        return result;
    };

    return config;
}
