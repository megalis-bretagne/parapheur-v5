@ip-core @api-v1 @admin-desk-controller
Feature: PUT /api/v1/admin/tenant/{tenantId}/desk/{deskId}/users (Add user to desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def list = api_v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/api/setup/tenant.delete.feature') list

        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'associate an existing desk to an existing user in an existing tenant', status)}
        # Create a temporary desk
        * api_v1.auth.login('user', 'password')
        * def unique = 'tmp-' + utils.getUUID()

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request
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
    "description": "Bureau #(unique)",
    "parentDeskId": null
}
"""
        When method POST
        Then status 201

        * def existingDeskId = $.value
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        # Associate an existing user to the temporary desk created above
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status <status>
            And if (<status> === 200) utils.assert("response == ''")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
            | TENANT_ADMIN     | vgris        | a123456  | 200    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'associate an existing desk to a non-existing user in an existing tenant', status)}
        # Create a temporary desk
        * api_v1.auth.login('user', 'password')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request
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
    "description": "Bureau #(unique)",
    "parentDeskId": null
}
"""
        When method POST
        Then status 201

        * def existingDeskId = $.value
        * def nonExistingUserId = api_v1.user.getNonExistingId()

        # Associate a non-existing user to the temporary desk created above
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(nonExistingUserId)"] }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 400    |
            | TENANT_ADMIN     | vgris        | a123456  | 403    |
            |                  |              |          | 401    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'associate a non-existing desk to an existing user in an existing tenant', status)}
        # Get data
        * api_v1.auth.login('user', 'password')
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        # Associate an existing user to a non-existing desk
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'associate a non-existing desk to a non-existing user in an existing tenant', status)}
        # Get data
        * api_v1.auth.login('user', 'password')
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()

        # Associate a non-existing user to a non-existing desk
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(nonExistingUserId)"] }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
