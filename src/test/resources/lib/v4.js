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
        // @todo: get et vérifications en javascript (@see cookies)
        var rv = karate.call('classpath:lib/v4/api/rest/desktop/getByName.feature', { "name": name, "asAdmin": asAdmin });
        return rv.desktop;
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
    config.v4.api.rest.folder['sign'] = function(desktop, folder, params) {
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
    };

    // REST API user lib
    config.v4.api.rest['user'] = {};
    config.v4.api.rest.user['login'] = function(username, password) {
        // @see https://github.com/karatelabs/karate#call-vs-read
        return karate.call(true, 'classpath:lib/v4/api/rest/user/login.feature', { "username": username, "password": password });
    };

    return config;
}
