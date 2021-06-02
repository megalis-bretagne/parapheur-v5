function fn(config) {
    config['api_v1'] = {};

    /**
     * auth
     */
    config.api_v1['auth'] = {};
    // @todo: as pure javascript functions
    config.api_v1.auth['login'] = function (username, password, status = null) {
        if (utils.isInteger(status) === false) {
            if (status === true || (status === null && username !== '')) {
                status = 200;
            } else if (status === false || (status === null && username === '')) {
                status = 401;
            }
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
    config.api_v1.desk['getById'] = function (tenantId, deskId) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/desk/' + deskId)
            .header('Accept', 'application/json')
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and deskId');
        }

        return response.body;
    };
    config.api_v1.desk['getIdByName'] = function (tenantId, name, containing = false) {
        response = karate
            .http(baseUrl)
            .path('/api/v1/admin/tenant/' + tenantId + '/desk')
            .header('Accept', 'application/json')
            .param('searchTerm', name)
            .get();

        if (response.status !== 200) {
            karate.fail('Got status code ' + response.status + ' while getting desk id by its tenantId and name');
        }

        var element = api_v1.utils.filterSingleElementFromGetResponse(response, 'desk', 'name', name, containing);
        return element['id'];
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
        }
    };

    /**
     * sealCertificate
     */
    config.api_v1['sealCertificate'] = {};
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
