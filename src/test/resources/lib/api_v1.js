/*
 * i-Parapheur
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
    config['api_v1'] = {};

    /**
     * auth
     */
    config.api_v1['auth'] = {};
    // @todo: as pure javascript functions
    config.api_v1.auth['login'] = function (username, password, status = null) {
        if (status === true || status === null) {
            status = 200;
        } else if (status === false || username === '') {
            status = 401;
        }

        return karate.call('classpath:lib/auth/post_' + String(status) + '.feature', {
            username: username,
            password: password
        });
    };

    /**
     * desk
     */
    config.api_v1['desk'] = {};
    config.api_v1.desk['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/admin/tenant/' + tenantId + '/desk')
            .header('Accept', 'application/json')
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and name');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'desk', 'name', name, containing);
        return element['id'];
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
            .path('/api/admin/tenant')
            .header('Accept', 'application/json')
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
            .path('/api/admin/tenant')
            .header('Accept', 'application/json')
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

    /**
     * user
     */
    config.api_v1['user'] = {};
    config.api_v1.user['createTemporary'] = function (tenantId) {
        var unique = 'tmp-' + java.util.UUID.randomUUID() + '';
        var email = unique + '@test';
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
    // @fixme-ip-core: user-controller, /api/currentUser -> 404
    config.api_v1.user['getCurrentUserId'] = function () {
        response = karate
            .http(baseUrl)
            .path('/api/currentUser')
            .header('Accept', 'application/json')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting current user');
        }

        return response.body['id'];
    };
    config.api_v1.user['getById'] = function (tenantId, userId) {
        response = karate
            .http(baseUrl)
            .path('/api/admin/tenant/' + tenantId + '/user/' + userId)
            .header('Accept', 'application/json')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting user id by its tenantId and email');
        }

        return response.body;
    };
    config.api_v1.user['getIdByEmail'] = function (tenantId, email, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/admin/tenant/' + tenantId + '/user')
            .header('Accept', 'application/json')
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
            'index': karate.read('classpath:lib/schemas/tenant.index.json')
        },
        'user': {
            'element': karate.read('classpath:lib/schemas/user.element.json'),
            'index': karate.read('classpath:lib/schemas/user.index.json')
        },
        'desk': {
            'element': karate.read('classpath:lib/schemas/desk.element.json'),
            // 'index': karate.read('classpath:lib/schemas/desk.index.json')
        },
        'workflow': {
            'element': karate.read('classpath:lib/schemas/workflow.element.json'),
            // 'index': karate.read('classpath:lib/schemas/workflow.index.json')
        },
    };

    /**
     * type
     */
    config.api_v1['type'] = {};
    config.api_v1.type['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/admin/tenant/' + tenantId + '/typology')
            .header('Accept', 'application/json')
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
                filtered = [karate.jsonPath(response.body, "$.data[1]")];//@todo: still filter, but reduce results
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
            .path('/api/admin/tenant/' + tenantId + '/workflowDefinition')
            .header('Accept', 'application/json')
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
