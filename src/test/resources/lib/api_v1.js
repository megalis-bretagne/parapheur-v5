/*
 * i-Parapheur
 * Copyright (C) 2019-2021 Libriciel SCOP
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
    config['api_v1'] = {};

    /**
     * auth
     */
    config.api_v1['auth'] = {token: {}};

    // @todo: as pure javascript functions
    config.api_v1.auth['login'] = function (username, password, status = null) {
        karate.configure('headers', {
            Accept: 'application/json'
        });
        api_v1.auth.token = {};

        if (utils.isInteger(status) === false) {
            if (status === true || (status === null && username !== '')) {
                status = 200;
            } else if (status === false || (status === null && username === '')) {
                status = 401;
            }
        }

        rv = karate.call('classpath:lib/auth/post_' + String(status) + '.feature', {
            username: username,
            password: password
        });

        if (status === 200) {
            api_v1.auth.token['access_token'] = rv.response.access_token;
            api_v1.auth.token['refresh_token'] = rv.response.refresh_token;

            karate.configure('headers', {
                Accept: 'application/json',
                Authorization: 'Bearer ' + api_v1.auth.token.access_token
            });
        }

        return rv;
    };

    /**
     * desk
     */
    config.api_v1['desk'] = {};
    config.api_v1.desk['createTemporary'] = function (tenantId) {
        var unique = 'tmp-' + java.util.UUID.randomUUID() + '';
        var description = 'Bureau ' + unique;
        var data = {
            name: unique,
            description: description,
            parentDeskId: null,
            tenantId: tenantId
        };
        karate.call('classpath:lib/desk/createTemporary.feature', data);

        return api_v1.desk.getIdByName(tenantId, unique);
    };
    config.api_v1.desk['draft'] = {};
    config.api_v1.desk.draft['getPayloadMonodoc'] = function (params, count, extra, start) {
        start = start === undefined ? 1 : start;

        var result = [],
            max = (count + start - 1),
            tenantId = api_v1.entity.getIdByName(params.tenant),
            deskId = api_v1.desk.getIdByName(tenantId, params.desktop),
            typeId = api_v1.type.getIdByName(tenantId, params.type),
            subtypeId = api_v1.subtype.getIdByName(tenantId, typeId, params.subtype),
            length = max.toString().length,
            nameTemplate = params.nameTemplate === undefined ? params.subtype + '_%counter%' : params.nameTemplate,
            annexFilePath = params.annexFilePath === undefined ? 'classpath:files/pdf/annex-1_1.pdf' : params.annexFilePath,
            mainFilePath = params.mainFile === undefined ? 'classpath:files/pdf/main-1_1.pdf' : params.mainFile
        ;

        for (var i=start;i<=max;i++) {
            var draftFolderParams = {
                limitDate: extra.limitDate === undefined ? null : extra.limitDate,
                metadata: extra.metadata === undefined ? {} : extra.metadata,
                name: nameTemplate.replace('%counter%', i.toString().padStart(length, "0")),
                paperSignable: extra.paperSignable === undefined ? false : extra.paperSignable,
                subtypeId: subtypeId,
                typeId: typeId,
                variableDesksIds: extra.variableDesksIds === undefined ? {} : extra.variableDesksIds,
                visibility: extra.visibility === undefined ? 'Confidentiel' : extra.visibility,
            };
            result.push({
                draftFolderParams: draftFolderParams,
                annexFilePath: annexFilePath,
                mainFilePath: mainFilePath,
                path: '/api/v1/tenant/' + tenantId + '/desk/' + deskId + '/draft',
            });
        }
        return result;
    };
    config.api_v1.desk['getById'] = function (tenantId, deskId) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/desk/' + deskId)
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and deskId');
        }

        return response.body;
    };
    config.api_v1.desk['getCreationPayload'] = function (tenantId, name, owners, parent, associated, permissions) {
        for (var i=0;i<owners.length;i++) {
            owners[i] = api_v1.user.getIdByEmail(tenantId, owners[i]);
        }

        for (var i=0;i<associated.length;i++) {
            associated[i] = api_v1.desk.getIdByName(tenantId, associated[i]);
        }

        var payload = {
            actionAllowed: permissions['action'] === undefined ? false : permissions['action'],
            archivingAllowed: permissions['archiving'] === undefined ? false : permissions['archiving'],
            associatedDeskIdsList: associated,
            availableSubtypeIdsList: [],
            chainAllowed: permissions['chain'] === undefined ? false : permissions['chain'],
            delegatingDesks: [],
            description: 'Bureau ' + name,
            filterableMetadataIdsList:[],
            filterableSubtypeIdsList:[],
            folderCreationAllowed: permissions['creation'] === undefined ? false : permissions['creation'],
            linkedDeskboxIds:[],
            name: name,
            ownerUserIdsList: owners,
            parentDeskId: parent === '' ? null : api_v1.desk.getIdByName(tenantId, parent),
            shortName: name,
        };

        return payload;
    };
    config.api_v1.desk['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/desk')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and name');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'desk', 'name', name, containing);
        return element['id'];
    };
    config.api_v1.desk['getKeyStringFromNameString'] = function (name) {
        return String(name).toLowerCase().replace(/[^a-z0-9]/g, '_');
    };
    config.api_v1.desk['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    /**
     * entity
     * @todo: rename as tenant
     */
    config.api_v1['entity'] = {};
    config.api_v1.entity['createTemporary'] = function () {
        var name = 'tmp-' + java.util.UUID.randomUUID() + '';
        karate.call('classpath:lib/tenant/createTemporary.feature', {name: name});
        return api_v1.entity.getIdByName(name);
    };
    config.api_v1.entity['getIdByName'] = function (name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('asc', 'true')
            .param('page', 0)
            .param('pageSize', 100)
            .param('searchTerm', name)
            .param('sortBy', 'ID')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting entity id by its name');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'entity', 'name', name, containing);
        return element['id'];
    };
    config.api_v1.entity['getNameById'] = function (id) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('asc', 'true')
            .param('page', 0)
            .param('pageSize', 100)
            .param('sortBy', 'ID')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting entity name by its id');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'entity', 'id', id);
        return element['name'];
    };
    config.api_v1.entity['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };
    config.api_v1.entity['getListByPartialName'] = function (partialName) {
        var result = [],
            response = karate
                .http(baseUrl)
                .path('/api/v1/admin/tenant/')
                .param('asc', true)
                .param('pageSize', 100)
                .param('searchTerm', partialName)
                .param('sortBy', 'NAME')
                .header('Accept', 'application/json')
                .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
                .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and deskId');
        }

        response.body.data.forEach(tenant => result.push(tenant));

        return result;
    };

    /**
     * metadata
     */
    config.api_v1['metadata'] = {};
    config.api_v1.metadata['getIdByKey'] = function (tenantId, key) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/metadata')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('pageSize', 100)
            .param('sortBy', 'KEY')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting metadata id by its tenantId and key');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'metadata', 'key', key, false);
        return element['id'];
    };

    /**
     * user
     */
    config.api_v1['user'] = {};
    config.api_v1.user['createTemporary'] = function (tenantId) {
        var unique = 'tmp-' + java.util.UUID.randomUUID() + '';
        var email = unique + '@dom.local';
        var data = {
            userName: unique,
            email: email,
            firstName: 'tmp',
            lastName: 'tmp',
            password: 'a123456',
            privilege: 'NONE',
            notificationsCronFrequency: 'NONE',
            notificationsRedirectionMail: email,
            tenantId: tenantId
        };
        karate.call('classpath:lib/user/createTemporary.feature', data);

        return api_v1.user.getIdByEmail(tenantId, email);
    };
    // @fixme-ip-core: user-controller, /api/v1/currentUser -> 404
    config.api_v1.user['getCurrentUserId'] = function () {
        response = karate
            .http(baseUrl)
            .path('/api/v1/currentUser')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting current user');
        }

        return response.body['id'];
    };
    config.api_v1.user['getById'] = function (tenantId, userId) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/user/' + userId)
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting user id by its tenantId and email');
        }

        return response.body;
    };
    config.api_v1.user['getIdByEmail'] = function (tenantId, email, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/user')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('searchTerm', email)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting user id by its tenantId and email');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'user', 'email', email, containing);
        return element['id'];
    };
    config.api_v1.user['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    /*
    --
    */

    config['matchers'] = {
        'timestamp': '#regex ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}\\+[0-9]{2}:[0-9]{2}$'
    };
    /**
     * schemas -> @todo: api_v1_schemas.js
     */
    config['schemas'] = {
        'auth': {
            'post_200': karate.read('classpath:lib/schemas/auth/post_200.json'),
            'post_401': karate.read('classpath:lib/schemas/auth/post_401.json'),
        },
        'tenant': {
            'element': karate.read('classpath:lib/schemas/tenant.element.json'),
            'index': karate.read('classpath:lib/schemas/tenant.index.json'),
            'index_element': karate.read('classpath:lib/schemas/tenant.index.element.json')
        },
        'user': {
            'element': karate.read('classpath:lib/schemas/user.element.json'),
            'index': karate.read('classpath:lib/schemas/user.index.json')
        },
        'desk': {
            'element': karate.read('classpath:lib/schemas/desk.element.json'),
            'index': karate.read('classpath:lib/schemas/desk.index.json')
        },
        'workflow': {
            'element': karate.read('classpath:lib/schemas/workflow.element.json'),
            'index': karate.read('classpath:lib/schemas/workflow.index.json')
        },
        'type': {
            'element': karate.read('classpath:lib/schemas/type.element.json'),
            // 'index': karate.read('classpath:lib/schemas/type.index.json')
        },
        'subtype': {
            'element': karate.read('classpath:lib/schemas/subtype.element.json'),
            // 'index': karate.read('classpath:lib/schemas/type.index.json')
        },
        'error': karate.read('classpath:lib/schemas/error.json'),
        'sealCertificate': {
            'element': karate.read('classpath:lib/schemas/sealCertificate.element.json'),
            'index': karate.read('classpath:lib/schemas/sealCertificate.index.json')
        },
        'delegation': {
            'element': karate.read('classpath:lib/schemas/delegation.element.json'),
            'index': karate.read('classpath:lib/schemas/delegation.index.json')
        },
        'metadata': {
            'element': karate.read('classpath:lib/schemas/metadata.element.json')
        }
    };

    /**
     * sealCertificate
     */
    config.api_v1['sealCertificate'] = {};
    config.api_v1.sealCertificate['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/sealCertificate')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('asc', 'true')
            .param('page', 0)
            .param('pageSize', 100)
            .param('searchTerm', name)
            .param('sortBy', 'ID')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting seal certificate id by its name');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'sealCertificate', 'name', name, containing);
        return element['id'];
    };
    config.api_v1.sealCertificate['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    /**
     * type
     */
    config.api_v1['type'] = {};
    config.api_v1.type['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/typology')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting type by its tenantId and name');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'type', 'name', name, containing);
        return element['id'];
    };
    config.api_v1.type['getNonExistingId'] = function () {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    /**
     * subtype
     */
    config.api_v1['subtype'] = {};
    config.api_v1.subtype['getIdByName'] = function (tenantId, typeId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/typology/type/' + typeId + '/subtype')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting type by its tenantId and name');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'type', 'name', name, containing);
        return element['id'];
    };

    /**
     * utils
     */
    config.api_v1['utils'] = {};
    config.api_v1.utils['filterSingleElementFromGetResponse'] = function (response, entity, field, value, containing = false) {
        if (response.body.total === 0) {
            filtered = [];
        } else {
            if (containing === true) {
                filtered = [karate.jsonPath(response.body, "$.data[0]")];//@todo: still filter, but reduce results
            } else {
                filtered = karate.jsonPath(response.body, "$.data[?(@." + field + "=='" + value + "')]");
            }
        }

        var matching = containing === true ? 'containing' : 'matching', message;

        if (filtered.length === 0) {
            message = 'No ' + entity + ' found ' + matching + ' field ' + field + ' ' + '""' + value + '""';
            karate.fail(message);
        } else if (filtered.length > 1) {
            message = filtered.length + ' ' + entity + ' found ' + matching + ' field ' + field + ' ' + '""' + value + '"": ' + JSON.stringify(filtered);
            karate.fail(message);
        }

        return filtered[0];
    };

    /**
     * workflow
     */
    config.api_v1['workflow'] = {};
    config.api_v1.workflow['getKeyByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/workflowDefinition')
            .header('Accept', 'application/json')
            .header('Authorization', 'Bearer ' + api_v1.auth.token.access_token)
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting workflow by its tenantId and name');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'workflow', 'name', name, containing);
        return element['key'];
    };

    return config;
}
