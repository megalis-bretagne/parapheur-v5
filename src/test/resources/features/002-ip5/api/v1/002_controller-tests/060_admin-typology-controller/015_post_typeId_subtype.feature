@api @ip5 @ip-core @api-v1 @admin-typology-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/typology/type/{typeId}/subtype (Create subtype)

    Background:
        * ip5.api.v1.auth.login('user', 'password')
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def getEmptyPayload =
"""
function() {
    return {
        "annotationsAllowed": null,
        "creationPermittedDeskIds": null,
        "description": "Description",
        "externalSignatureConfig": {},
        "externalSignatureConfigId": null,
        "filterableByDeskIds": null,
        "ipngTypeKeys": [],
        "name": null,
        "sealCertificateId": null,
        "subtypeLayerRequestList": [],
        "subtypeMetadataList": [],
        "validationWorkflowId": null
    };
}
"""
        * def getCleanPayload =
"""
function() {
    var payload = getEmptyPayload();
    var existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant');

    payload.annotationsAllowed = true
    payload.name = 'tmp-' + ip.utils.getUUID()
    payload.validationWorkflowId = ip5.api.v1.workflow.getKeyByName(existingTenantId, 'tmp-', true)

    return payload;
}
"""

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a subtype and associate it to an existing type in an existing tenant', status)}
        * ip5.api.v1.auth.login('user', 'password')
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def existingTypeId = ip5.api.v1.type.getIdByName(existingTenantId, 'tmp-', true)

        * def payload = getCleanPayload()

        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/v1/admin/tenant/', existingTenantId, 'typology/type/', existingTypeId, '/subtype'
            And header Accept = 'application/json'
            And request payload

        When method POST
        Then status <status>
            And if (<status> === 201) ip.utils.assert("$ == {'value': '#uuid'}")
            And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456  | 201    |
        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a subtype and associate it to an existing type in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', 'password')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingTypeId = ip5.api.v1.type.getIdByName(ip5.api.v1.entity.getIdByName('Default tenant'), 'tmp-', true)

        * def payload = getCleanPayload()

        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/v1/admin/tenant/', nonExistingTenantId, 'typology/type/', existingTypeId, '/subtype'
            And header Accept = 'application/json'
            And request payload

        When method POST
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a subtype and associate it to a non-existing type in an existing tenant', status)}
        * ip5.api.v1.auth.login('user', 'password')
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def nonExistingTypeId = ip5.api.v1.type.getNonExistingId()

        * def payload = getCleanPayload()

        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/v1/admin/tenant/', existingTenantId, 'typology/type/', nonExistingTypeId, '/subtype'
            And header Accept = 'application/json'
            And request payload

        When method POST
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a subtype and associate it to a non-existing type in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', 'password')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def nonExistingTypeId = ip5.api.v1.type.getNonExistingId()

        * def payload = getCleanPayload()

        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/v1/admin/tenant/', nonExistingTenantId, 'typology/type/', nonExistingTypeId, '/subtype'
            And header Accept = 'application/json'
            And request payload

        When method POST
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'create a subtype and associate it to an existing type in an existing tenant', status, data)}
        * ip5.api.v1.auth.login('user', 'password')
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def existingTypeId = ip5.api.v1.type.getIdByName(existingTenantId, 'tmp-', true)

        * def payload = getCleanPayload()
        * payload[field] = ip.utils.eval(value)

        * ip5.api.v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, 'typology/type/', existingTypeId, '/subtype'
            And header Accept = 'application/json'
            And request payload

        When method POST
        Then status <status>
            And if (<status> === 201) ip.utils.assert("$ == {'value': '#uuid'}")
            And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | status | field | value!                             | data                                |
            | 201    | name  | eval(ip.utils.string.getRandom(1))    | a name that is 1 character long     |
            | 201    | name  | eval(ip.utils.string.getRandom(255))  | a name that is 255 characters long  |
        @fixme-ip5 @issue-todo
        Examples:
            | status | field | value!                             | data                                |
            | 400    | name  | ''                                 | an empty name                       |
            | 400    | name  | eval(ip.utils.string.getRandom(1024)) | a name that is 1024 characters long |
