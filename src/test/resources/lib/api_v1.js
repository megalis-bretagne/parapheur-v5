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
    config.api_v1['auth'] = {};
    // @todo: as pure javascript functions
    config.api_v1.auth['login'] = function(username, password, success = true) {
        if (username === '' || success !== true) {
            return karate.call('classpath:lib/auth/failure.feature', { username: username, password: password });
        } else {
            return karate.call('classpath:lib/auth/success.feature', { username: username, password: password });
        }
    };
    /*
    // karate.toJava(kittens)
    config.api_v1.auth['login'] = function(username, password, success = true) {
        data = {
            'client_id': 'admin-cli',
            'username': username,
            'password': password,
            'grant_type': 'password'
        }
        response = karate
            .http(baseUrl)
            .path('/auth/realms/api/protocol/openid-connect/token')
            .header('Accept', 'application/json')
            .header('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8')
            .post();
// karate.log(JSON.stringify(data));
// karate.log(response);
        if (username === '' || success !== true) {
            if (response.status !== 401) {
                karate.fail('Connection not failed: got status code ' + response.status + ' while trying to connect with username "' + username + '" and password "' + password + '"');
            } else {
                // And match $ == { "error":"invalid_grant","error_description":"Invalid user credentials" }
            }
        } else {
            if (response.status !== 200) {
                karate.fail('Connection failed: got status code ' + response.status + ' while trying to connect with username "' + username + '" and password "' + password + '"');
            } else {
                // And match $.access_token == '#string'
                // And def access_token = $.access_token
            }
        }
    };
    */

    /**
     * desk
     */
    config.api_v1['desk'] = {};
    config.api_v1.desk['getIdByName'] = function(tenantId, name) {
        response = karate
            .http(baseUrl)
            .path('/api/admin/tenant/' + tenantId + '/desk')
            .header('Accept', 'application/json')
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and name');
        }

        filtered = karate.jsonPath(response.body, "$.data[?(@.name=='" + name + "')]");

        if (filtered.length === 0) {
            karate.fail('No desk named "' + name + '" found');
        } else if (filtered.length > 1) {
            karate.fail(filtered.length + ' desks named "' + name + '" found: ' + JSON.stringify(filtered));
        } else if ('id' in filtered[0] === false) {
            karate.fail('Desk with name "' + name + '" has no "id" field: ' + JSON.stringify(filtered[0]));
        }

        return filtered[0]['id'];
    };

    /**
     * entity
     * @fixme: rename as tenant
     */
    config.api_v1['entity'] = {};
    config.api_v1.entity['createTemporary'] = function() {
        var name = 'tmp-' + java.util.UUID.randomUUID() + '';
        karate.call('classpath:lib/tenant/createTemporary.feature', { name : name });
        return api_v1.entity.getIdByName(name);
    };
    config.api_v1.entity['getIdByName'] = function(name) {
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

        filtered = karate.jsonPath(response.body, "$.data[?(@.name=='" + name + "')]");

        if (filtered.length === 0) {
            karate.fail('No entity named "' + name + '" found');
        } else if (filtered.length > 1) {
            karate.fail(filtered.length + ' entities named "' + name + '" found: ' + JSON.stringify(filtered));
        } else if ('id' in filtered[0] === false) {
            karate.fail('Entity named "' + name + '" has no "id" field: ' + JSON.stringify(filtered[0]));
        }

        return filtered[0]['id'];
    };
    config.api_v1.entity['getNameById'] = function(id) {
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

        filtered = karate.jsonPath(response.body, "$.data[?(@.id=='" + id + "')]");

        if (filtered.length === 0) {
            karate.fail('No entity with id "' + id + '" found');
        } else if (filtered.length > 1) {
            karate.fail(filtered.length + ' entities with id "' + id + '" found: ' + JSON.stringify(filtered));
        } else if ('name' in filtered[0] === false) {
            karate.fail('Entity with id "' + id + '" has no "name" field: ' + JSON.stringify(filtered[0]));
        }

        return filtered[0]['name'];
    };
    config.api_v1.entity['getNonExistingId'] = function() {
        // @todo: check if it really does not exist
        return '00000000-0000-0000-0000-000000000000';
    };

    /**
     * user
     */
    config.api_v1['user'] = {};
    config.api_v1.user['createTemporary'] = function(tenantId) {
        var unique = 'tmp-' + java.util.UUID.randomUUID() + '';
        var email = unique + '@test';
        var data = {
            userName : unique,
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
    config.api_v1.user['getCurrentUserId'] = function() {
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
    config.api_v1.user['getById'] = function(tenantId, userId) {
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
    config.api_v1.user['getIdByEmail'] = function(tenantId, email) {
        response = karate
            .http(baseUrl)
            .path('/api/admin/tenant/' + tenantId + '/user')
            .header('Accept', 'application/json')
            .param('searchTerm', email)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting user id by its tenantId and email');
        }

        filtered = karate.jsonPath(response.body, "$.data[?(@.email=='" + email + "')]");

        if (filtered.length === 0) {
            karate.fail('No user with email "' + email + '" found');
        } else if (filtered.length > 1) {
            karate.fail(filtered.length + ' user with email "' + email + '" found: ' + JSON.stringify(filtered));
        } else if ('id' in filtered[0] === false) {
            karate.fail('User with email "' + email + '" has no "id" field: ' + JSON.stringify(filtered[0]));
        }

        return filtered[0]['id'];
    };
    config.api_v1.user['getNonExistingId'] = function() {
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
            'failure': karate.read('classpath:lib/schemas/auth.failure.json'),
            'success': karate.read('classpath:lib/schemas/auth.success.json')
        },
        'tenant': {
            'element': karate.read('classpath:lib/schemas/tenant.element.json'),
            'index': karate.read('classpath:lib/schemas/tenant.index.json')
        },
        'user': {
            'element': karate.read('classpath:lib/schemas/user.element.json'),
            'index': karate.read('classpath:lib/schemas/user.index.json')
        }
    };

    /**
     * type
     */
    config.api_v1['type'] = {};
    config.api_v1.type['getIdByName'] = function(tenantId, name) {
        response = karate
            .http(baseUrl)
            .path('/api/admin/tenant/' + tenantId + '/typology')
            .header('Accept', 'application/json')
            .param('searchTerm', name)
            .get();
karate.log(response);
        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting type by its tenantId and name');
        }

        filtered = karate.jsonPath(response.body, "$.data[?(@.name=='" + name + "')]");

        if (filtered.length === 0) {
            karate.fail('No type named "' + name + '" found');
        } else if (filtered.length > 1) {
            karate.fail(filtered.length + ' types named "' + name + '" found: ' + JSON.stringify(filtered));
        } else if ('id' in filtered[0] === false) {
            karate.fail('Type named "' + name + '" has no "id" field: ' + JSON.stringify(filtered[0]));
        }

        return filtered[0]['id'];
    };

    /**
     * utils
     * @todo -> common ?
     */
    config['utils'] = {};
    config.utils['getUUID'] = function (length = 32) {
        // @see https://github.com/intuit/karate#commonly-needed-utilities
        return java.util.UUID.randomUUID() + '';
    };
    config.utils['getUniqueName'] = function(prefix) {
        return String(prefix) + Date.now();
    };

    /**
     * workflow
     */
    config.api_v1['workflow'] = {};
    config.api_v1.workflow['getKeyByName'] = function(tenantId, name) {
        response = karate
            .http(baseUrl)
            .path('/api/admin/tenant/' + tenantId + '/workflowDefinition')
            .header('Accept', 'application/json')
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting workflow by its tenantId and name');
        }

        filtered = karate.jsonPath(response.body, "$.data[?(@.name=='" + name + "')]");

        if (filtered.length === 0) {
            karate.fail('No workflow named "' + name + '" found');
        } else if (filtered.length > 1) {
            karate.fail(filtered.length + ' workflows named "' + name + '" found: ' + JSON.stringify(filtered));
        } else if ('id' in filtered[0] === false) {
            karate.fail('Workflow named "' + name + '" has no "id" field: ' + JSON.stringify(filtered[0]));
        }

        return filtered[0]['key'];
    };

    return config;
}
