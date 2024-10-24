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
    config.ip5['api'] = config.ip5['api'] || {};
    config.ip5.api['v1'] = config.ip5.api['v1'] || {};

    /**
     * auth
     */
    config.ip5.api.v1['auth'] = {token: {}};

    // @todo: as pure javascript functions
    config.ip5.api.v1.auth['login'] = function (username, password, status = null) {
        karate.configure('headers', {
            Accept: 'application/json'
        });
        ip5.api.v1.auth.token = {};

        if (ip.utils.isInteger(status) === false) {
            if (status === true || (status === null && username !== '')) {
                status = 200;
            } else if (status === false || (status === null && username === '')) {
                status = 401;
            }
        }

        rv = karate.call('classpath:lib/ip5/api/auth/post_' + String(status) + '.feature', {
            username: username,
            password: password
        });

        if (status === 200) {
            ip5.api.v1.auth.token['access_token'] = rv.response.access_token;
            ip5.api.v1.auth.token['refresh_token'] = rv.response.refresh_token;

            karate.configure('headers', {
                Accept: 'application/json',
                Authorization: 'Bearer ' + ip5.api.v1.auth.token.access_token
            });
        }

        return rv;
    };
    config.ip5.api.v1.auth['logout'] = function () {
        response = karate
            .http(baseUrl)
            .path('/auth/realms/api/protocol/openid-connect/logout')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while logging out');
        }
    };

    /**
     * desk
     */
    config.ip5.api.v1['desk'] = {};
    config.ip5.api.v1.desk['createTemporary'] = function (tenantId) {
        var unique = 'tmp-' + java.util.UUID.randomUUID() + '';
        var description = 'Bureau ' + unique;
        var data = {
            name: unique,
            description: description,
            parentDeskId: null,
            tenantId: tenantId
        };
        karate.call('classpath:lib/ip5/api/desk/createTemporary.feature', data);

        return ip5.api.v1.desk.getIdByName(tenantId, unique);
    };
    config.ip5.api.v1.desk['getVariableDeskIds'] = function (tenantId, variableDeskIds, containing = false) {
        result = {};
        for (const key in variableDeskIds) {
            result[key] = ip5.api.v1.desk.getIdByName(tenantId, variableDeskIds[key], containing)
        }
        return result;
    };
    config.ip5.api.v1.desk['draft'] = {};
    config.ip5.api.v1.desk.draft['getPayloadMonodoc'] = function (params, count, extra, start) {
        start = start === undefined ? 1 : start;

        var result = [],
            max = (count + start - 1),
            tenantId = ip5.api.v1.entity.getIdByName(params.tenant),
            deskId = ip5.api.v1.desk.getIdByName(tenantId, params.desktop),
            typeId = ip5.api.v1.type.getIdByName(tenantId, params.type),
            subtypeId = ip5.api.v1.subtype.getIdByName(tenantId, typeId, params.subtype),
            length = max.toString().length,
            annotation = params.annotation === undefined ? '' : params.annotation,
            username = params.username === undefined ? '' : params.username,
            nameTemplate = params.nameTemplate === undefined ? params.subtype + '_%counter%' : params.nameTemplate,
            annexFilePath = params.annexFilePath === undefined ? 'classpath:files/pdf/annex-1_1.pdf' : params.annexFilePath,
            mainFilePath = params.mainFile === undefined ? 'classpath:files/pdf/main-1_1.pdf' : params.mainFile
        ;

        if (typeof mainFilePath !== 'object') {
            mainFilePath = {'file': mainFilePath, 'detached': null};
        }

        for (var i = start ; i <= max ; i++) {
            var createFolderRequest = {
                dueDate: extra.dueDate === undefined ? null : extra.dueDate,
                metadata: extra.metadata === undefined ? {} : extra.metadata,
                name: nameTemplate.replace('%counter%', i.toString().padStart(length, "0")),
                paperSignable: extra.paperSignable === undefined ? false : extra.paperSignable,
                subtypeId: subtypeId,
                typeId: typeId,
                variableDesksIds: extra.variableDesksIds === undefined ? {} : ip5.api.v1.desk.getVariableDeskIds(tenantId, extra.variableDesksIds),
                visibility: extra.visibility === undefined ? 'CONFIDENTIAL' : extra.visibility,
            };
            result.push({
                tenantId: tenantId,
                deskId: deskId,
                createFolderRequest: createFolderRequest,
                annexFilePath: annexFilePath,
                mainFilePath: mainFilePath['file'],
                mainFileDetachedPath: mainFilePath['detached'],
                path: '/api/v1/tenant/' + tenantId + '/desk/' + deskId + '/draft',
                startPath: '/api/standard/v1/tenant/' + tenantId + '/desk/' + deskId + '/folder/{folderId}/task/unusedTaskId/start',
                annotation: annotation === '' ? '' : annotation + ' du dossier ' + createFolderRequest.name,
                username: username,
            });
        }

        return result;
    };
    config.ip5.api.v1.desk.draft['getPayloadMultidoc'] = function (params, count, extra, start) {
        start = start === undefined ? 1 : start;

        var result = [],
            max = (count + start - 1),
            tenantId = ip5.api.v1.entity.getIdByName(params.tenant),
            deskId = ip5.api.v1.desk.getIdByName(tenantId, params.desktop),
            typeId = ip5.api.v1.type.getIdByName(tenantId, params.type),
            subtypeId = ip5.api.v1.subtype.getIdByName(tenantId, typeId, params.subtype),
            length = max.toString().length,
            annotation = params.annotation === undefined ? '' : params.annotation,
            username = params.username === undefined ? '' : params.username,
            nameTemplate = params.nameTemplate === undefined ? params.subtype + '_%counter%' : params.nameTemplate,
            annexFilePath = params.annexFilePath === undefined ? 'classpath:files/pdf/annex-1_1.pdf' : params.annexFilePath,
            // mainFilePath = params.mainFile === undefined ? 'classpath:files/pdf/main-1_1.pdf' : params.mainFile,
            mainFilesPaths = [
                'classpath:files/pdf/main-1_1.pdf',
                'classpath:files/pdf/annex-1_1.pdf'
            ]
        ;

        for (var i = start ; i <= max ; i++) {
            var createFolderRequest = {
                dueDate: extra.dueDate === undefined ? null : extra.dueDate,
                metadata: extra.metadata === undefined ? {} : extra.metadata,
                name: nameTemplate.replace('%counter%', i.toString().padStart(length, "0")),
                paperSignable: extra.paperSignable === undefined ? false : extra.paperSignable,
                subtypeId: subtypeId,
                typeId: typeId,
                variableDesksIds: extra.variableDesksIds === undefined ? {} : ip5.api.v1.desk.getVariableDeskIds(tenantId, extra.variableDesksIds),
                visibility: extra.visibility === undefined ? 'CONFIDENTIAL' : extra.visibility,
            };
            result.push({
                createFolderRequest: createFolderRequest,
                annexFilePath: annexFilePath,
                // mainFilePath: mainFilePath,
                mainFilesPaths: mainFilesPaths,
                path: '/api/v1/tenant/' + tenantId + '/desk/' + deskId + '/draft',
                startPath: '/api/standard/v1/tenant/' + tenantId + '/desk/' + deskId + '/folder/{folderId}/task/unusedTaskId/start',
                annotation: annotation === '' ? '' : annotation + ' du dossier ' + createFolderRequest.name,
                username: username,
            });
        }
        return result;
    };
    config.ip5.api.v1.desk['getAllIdsByNames'] = function (tenantId, names, containing = false) {
        result = [];
        for (var i = 0 ; i < names.length ; i++) {
            result.push(ip5.api.v1.desk.getIdByName(tenantId, names[i], containing));
        }
        return result;
    };
    config.ip5.api.v1.desk['getById'] = function (tenantId, deskId) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant/' + tenantId + '/desk/' + deskId)
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and deskId');
        }

        return response.body;
    };
    config.ip5.api.v1.desk['getCreationPayload'] = function (tenantId, name, shortName, owners, parent, associated, permissions) {
        for (var i = 0 ; i < owners.length ; i++) {
            owners[i] = ip5.api.v1.user.getIdByEmail(tenantId, owners[i]);
        }

        for (var i = 0 ; i < associated.length ; i++) {
            associated[i] = ip5.api.v1.desk.getIdByName(tenantId, associated[i]);
        }

        var payload = {
            actionAllowed: permissions['action'] === undefined ? false : permissions['action'],
            archivingAllowed: permissions['archiving'] === undefined ? false : permissions['archiving'],
            associatedDeskIds: associated,
            supervisorIds: [],
            delegationManagerIds: [],
            filterableMetadataIds: [],
            availableSubtypeIdsList: [],
            chainAllowed: permissions['chain'] === undefined ? false : permissions['chain'],
            delegatingDesks: [],
            delegationManagerIdsList: [],
            description: 'Bureau ' + name,
            filterableMetadataIdsList: [],
            filterableSubtypeIdsList: [],
            folderCreationAllowed: permissions['creation'] === undefined ? false : permissions['creation'],
            linkedDeskboxIds: [],
            name: name,
            ownerIds: owners,
            parentDeskId: parent === '' ? null : ip5.api.v1.desk.getIdByName(tenantId, parent),
            shortName: shortName,
            supervisorIdsList: []
        };

        return payload;
    };
    config.ip5.api.v1.desk['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant/' + tenantId + '/desk')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'desk', 'name', name, containing);
        return element['id'];
    };
    config.ip5.api.v1.desk['getKeyStringFromNameString'] = function (name) {
        return String(name).toLowerCase().replace(/[^a-z0-9]/g, '_');
    };
    config.ip5.api.v1.desk['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    /**
     * entity
     * @todo: rename as tenant
     */
    config.ip5.api.v1['entity'] = {};
    config.ip5.api.v1.entity['createTemporary'] = function () {
        var name = 'tmp-' + java.util.UUID.randomUUID() + '';
        karate.call('classpath:lib/ip5/api/tenant/createTemporary.feature', {name: name});
        return ip5.api.v1.entity.getIdByName(name);
    };
    config.ip5.api.v1.entity['getIdByName'] = function (name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('page', 0)
            .param('size', 100)
            .param('searchTerm', name)
            .param('sort', 'ID,ASC')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting entity id by its name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'entity', 'name', name, containing);
        return element['id'];
    };
    config.ip5.api.v1.entity['getNameById'] = function (id) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('page', 0)
            .param('size', 100)
            .param('sort', 'ID,ASC')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting entity name by its id');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'entity', 'id', id);
        return element['name'];
    };
    config.ip5.api.v1.entity['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };
    config.ip5.api.v1.entity['getListByPartialName'] = function (partialName) {
        var result = [],
            response = karate
                .http(baseUrl)
                .path('/api/provisioning/v1/admin/tenant/')
                .param('size', 100)
                .param('searchTerm', partialName)
                .param('sort', 'NAME,ASC')
                .header('Accept', 'application/json')
                .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
                .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and deskId');
        }

        response.body.content.forEach(tenant => result.push(tenant));

        return result;
    };

    /**
     * externalSignature
     */
    config.ip5.api.v1['externalSignature'] = {};
    config.ip5.api.v1.externalSignature['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/externalSignature/config')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('page', 0)
            .param('size', 100)
            .param('sort', 'ID,ASC')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting external signature id by its name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'externalSignature', 'name', name, containing);
        return element['id'];
    };

    /**
     * metadata
     */
    config.ip5.api.v1['layer'] = {};
    config.ip5.api.v1.layer['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/layer')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting layer id by its tenantId and name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'layer', 'name', name, containing);
        return element['id'];
    };

    /**
     * metadata
     */
    config.ip5.api.v1['metadata'] = {};
    config.ip5.api.v1.metadata['getIdByKey'] = function (tenantId, key) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant/' + tenantId + '/metadata')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('size', 100)
            .param('sort', 'KEY,ASC')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting metadata id by its tenantId and key');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'metadata', 'key', key, false);
        return element['id'];
    };

    /**
     * secureMail
     */
    config.ip5.api.v1['secureMailServer'] = {};
    config.ip5.api.v1.secureMailServer['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/secureMail/server')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('page', 0)
            .param('size', 100)
            .param('sort', 'ID,ASC')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting secure mail id by its name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'secureMail', 'name', name, containing);
        return element['id'];
    };

    /**
     * user
     */
    config.ip5.api.v1['user'] = {};
    config.ip5.api.v1.user['createTemporary'] = function (tenantId) {
        var unique = 'tmp-' + java.util.UUID.randomUUID() + '';
        var email = unique + '@dom.local';
        var data = {
            userName: unique,
            email: email,
            firstName: 'tmp',
            lastName: 'tmp',
            password: 'Ilenfautpeupouretreheureux',
            privilege: 'NONE',
            notificationsCronFrequency: 'NONE',
            notificationsRedirectionMail: email,
            tenantId: tenantId
        };
        karate.call('classpath:lib/ip5/api/user/createTemporary.feature', data);

        return ip5.api.v1.user.getIdByEmail(tenantId, email);
    };
    // @fixme-ip-core: user-controller, /api/v1/currentUser -> 404
    config.ip5.api.v1.user['getCurrentUserId'] = function () {
        response = karate
            .http(baseUrl)
            .path('/api/v1/currentUser')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting current user');
        }

        return response.body['id'];
    };


    config.ip5.api.v1.user['getById'] = function (tenantId, userId) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant/' + tenantId + '/user/' + userId)
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting user id by its tenantId and email');
        }

        return response.body;
    };
    config.ip5.api.v1.user['getIdByEmail'] = function (tenantId, email, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant/' + tenantId + '/user')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('searchTerm', email)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting user id by its tenantId and email');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'user', 'email', email, containing);
        return element['id'];
    };
    config.ip5.api.v1.user['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    config.ip5.api.v1.user['getCurrentUserData'] = function () {
        response = karate
            .http(baseUrl)
            .path('/api/v1/currentUser')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting current user');
        }

        return response.body;
    };

    config.ip5.api.v1.user['update'] = function (userObject) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/currentUser')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .put(userObject);

        if (response.status !== 200 && response.status !== 201) {
            karate.fail('Got status code ' + response.status + ' while setting current user\'s preferences');
        }
    };


    config.ip5.api.v1.user['updateCurrentUserNotificationFrequency'] = function (notifFrequency) {
        let userData = ip5.api.v1.userPref.getCurrentUserPreferences();
        userData.notificationsCronFrequency = notifFrequency;
        ip5.api.v1.userPref.update(userData);
    };


    /**
     * User preferences
     */

    config.ip5.api.v1['userPref'] = {};
    config.ip5.api.v1.userPref['getCurrentUserPreferences'] = function () {
        response = karate
            .http(baseUrl)
            .path('/api/v1/currentUser/preferences')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting current user');
        }

        return response.body;
    };

    config.ip5.api.v1.userPref['update'] = function (userPrefObject) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/currentUser/preferences')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .put(userPrefObject);

        if (response.status !== 200 && response.status !== 201) {
            karate.fail('Got status code ' + response.status + ' while setting current user\'s preferences');
        }
    };


    /*
    --
    */

    config['matchers'] = {
        'signingTime': '#regex ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$',
        'timestamp': '#regex ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}\\+[0-9]{2}:[0-9]{2}$',
    };
    /**
     * schemas -> @todo: ip5.api.v1_schemas.js
     */
    config['schemas'] = {
        'auth': {
            'post_200': karate.read('classpath:lib/ip5/api/schemas/auth/post_200.json'),
            'post_401': karate.read('classpath:lib/ip5/api/schemas/auth/post_401.json'),
        },
        'tenant': {
            'element': karate.read('classpath:lib/ip5/api/schemas/tenant.element.json'),
            'index': karate.read('classpath:lib/ip5/api/schemas/tenant.index.json'),
            'index_element': karate.read('classpath:lib/ip5/api/schemas/tenant.index.element.json')
        },
        'user': {
            'element': karate.read('classpath:lib/ip5/api/schemas/user.element.json'),
            'index': karate.read('classpath:lib/ip5/api/schemas/user.index.json')
        },
        'desk': {
            'element': karate.read('classpath:lib/ip5/api/schemas/desk.element.json'),
            'index': karate.read('classpath:lib/ip5/api/schemas/desk.index.json')
        },
        'workflow': {
            'element': karate.read('classpath:lib/ip5/api/schemas/workflow.element.json'),
            'index': karate.read('classpath:lib/ip5/api/schemas/workflow.index.json')
        },
        'type': {
            'element': karate.read('classpath:lib/ip5/api/schemas/type.element.json'),
            // 'index': karate.read('classpath:lib/ip5/api/schemas/type.index.json')
        },
        'subtype': {
            'element': karate.read('classpath:lib/ip5/api/schemas/subtype.element.json'),
            // 'index': karate.read('classpath:lib/ip5/api/schemas/type.index.json')
        },
        'error': karate.read('classpath:lib/ip5/api/schemas/error.json'),
        'sealCertificate': {
            'element': karate.read('classpath:lib/ip5/api/schemas/sealCertificate.element.json'),
            'index': karate.read('classpath:lib/ip5/api/schemas/sealCertificate.index.json')
        },
        'delegation': {
            'element': karate.read('classpath:lib/ip5/api/schemas/delegation.element.json'),
            'index': karate.read('classpath:lib/ip5/api/schemas/delegation.index.json')
        },
        'metadata': {
            'element': karate.read('classpath:lib/ip5/api/schemas/metadata.element.json')
        }
    };

    /**
     * sealCertificate
     */
    config.ip5.api.v1['sealCertificate'] = {};
    config.ip5.api.v1.sealCertificate['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant/' + tenantId + '/sealCertificate')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('page', 0)
            .param('size', 100)
            .param('searchTerm', name)
            .param('sort', 'ID,ASC')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting seal certificate id by its name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'sealCertificate', 'name', name, containing);
        return element['id'];
    };
    config.ip5.api.v1.sealCertificate['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    /**
     * type
     */
    config.ip5.api.v1['type'] = {};
    config.ip5.api.v1.type['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/internal/admin/tenant/' + tenantId + '/typology')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting type by its tenantId and name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'type', 'name', name, containing);
        return element['id'];
    };
    config.ip5.api.v1.type['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    /**
     * subtype
     */
    config.ip5.api.v1['subtype'] = {};
    config.ip5.api.v1.subtype['getIdByName'] = function (tenantId, typeId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant/' + tenantId + '/typology/type/' + typeId + '/subtype')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting type by its tenantId and name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'type', 'name', name, containing);
        return element['id'];
    };


    /**
     * utils
     */
    config.ip5.api.v1['utils'] = {};
    config.ip5.api.v1.utils['filterSingleElementFromGetResponse'] = function (response, entity, field, value, containing = false) {
        var key, matching = containing === true ? 'containing' : 'matching', message;
        value = value.replace("'", "\\'");

        key = (typeof response.body.content !== "undefined") ? "content" : "data";

        if (containing === true) {
            //@todo: still filter, but reduce results
            filtered = [karate.jsonPath(response.body, "$." + key + "[0]")];
        } else {
            filtered = karate.jsonPath(response.body, "$." + key + "[?(@." + field + "=='" + value + "')]");
            karate.log("$.content[?(@." + field + "=='" + value + "')]");
            karate.log(filtered);
        }

        if (filtered.length === 0) {
            message = 'No ' + entity + ' found ' + matching + ' field ' + field + ' ' + '"' + value + '"';
        } else if (filtered.length > 1) {
            message = filtered.length + ' ' + entity + ' found ' + matching + ' field ' + field + ' ' + '"' + value + '": ' + JSON.stringify(filtered);
        }

        if (typeof message === 'undefined') {
            return filtered[0];
        } else {
            karate.fail(message);
            return {};
        }
    };

    /**
     * workflow
     */
    config.ip5.api.v1['workflow'] = {};
    config.ip5.api.v1.workflow['getKeyByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/provisioning/v1/admin/tenant/' + tenantId + '/workflowDefinition')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + ip5.api.v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting workflow by its tenantId and name');
        }

        var element = ip5.api.v1.utils.filterSingleElementFromGetResponse(response, 'workflow', 'name', name, containing);
        return element['key'];
    };

    return config;
}
