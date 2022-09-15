@api @ip5 @ip-core @api-v1 @admin-desk-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/desk (Create a new desk)

    Background:
        * ip5.api.v1.auth.login('user', 'password')
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def unique = 'tmp-' + ip.utils.getUUID()
        * def description = 'Bureau ' + unique
        * def uniqueRequestData =
"""
{
	"actionAllowed": true,
	"archivingAllowed": true,
	"associatedDeskIdsList":[],
	"availableSubtypeIdsList":[],
	"chainAllowed":true,
	"delegatingDesks":[],
	"filterableMetadataIdsList":[],
	"filterableSubtypeIdsList":[],
	"folderCreationAllowed": true,
	"linkedDeskboxIds":[],
	"ownerUserIdsList": [],
    "name": "#(unique)",
    "shortName": "#(unique)",
    "description": "#(description)",
    "parentDeskId": null
}
"""

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a desk in an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>
            And if (<status> === 201) ip.utils.assert("$ == { 'value': '#uuid' }")
            And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456  | 201    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a desk in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
            And request uniqueRequestData
        When method POST
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    @data-validation
    Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'create a desk in an existing tenant', status, data)}
        * ip5.api.v1.auth.login('cnoir', 'a123456')
        * copy requestData = uniqueRequestData
        * requestData[field] = ip.utils.eval(value)
        * copy expected = requestData
        * remove expected.parentDeskId
        * if (requestData['parentDeskId'] == null) expected['directParent'] = null
        * if (requestData['parentDeskId'] != null) expected['directParent'] = { id: requestData['parentDeskId'] }

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And if (<status> === 201) ip.utils.assert("$ == { 'value': '#uuid' }")
            And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | status | field        | value!                                                        | data                                       |
            | 201    | name         | eval(ip.utils.string.getRandom(1))                               | a name that is 1 character long            |
            | 201    | name         | eval(ip.utils.string.getRandom(255, 'tmp-'))                     | a name that is up to 255 characters        |
            | 201    | parentDeskId | eval(ip5.api.v1.desk.getIdByName(existingTenantId, 'tmp-', true)) | a parent desk that does exist              |
        @fixme-ip5 @issue-todo
        Examples:
            | status | field        | value!                                                        | data                                       |
            | 201    | description  | eval(ip.utils.string.getRandom(300))                             | a description that is up to 300 characters |
            | 400    | name         | ''                                                            | an empty name                              |
            | 400    | name         | ' '                                                           | a space as a name                          |
            | 400    | name         | eval(ip.utils.string.getRandom(256))                             | a name that is too long                    |
            | 409    | name         | eval(ip5.api.v1.desk.getIdByName(existingTenantId, 'tmp-', true)) | a name that already exists                 |
            | 400    | description  | eval(ip.utils.string.getRandom(301))                             | a description that is too long             |
            | 400    | parentDeskId | eval(ip5.api.v1.desk.getNonExistingId())                          | a parent desk that doesn't exist           |
