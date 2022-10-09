@api @ip5 @ip-core @api-v1 @admin-desk-controller
Feature: PUT /api/v1/admin/tenant/{tenantId}/desk/{deskId}/users (Add user to desk)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'associate an existing desk to an existing user in an existing tenant', status)}
        # Create a temporary desk
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def unique = 'tmp-' + ip.utils.getUUID()

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
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        # Associate an existing user to the temporary desk created above
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status <status>
            And if (<status> === 200) ip.utils.assert("response == ''")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
            | TENANT_ADMIN     | vgris        | a123456  | 200    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'associate an existing desk to a non-existing user in an existing tenant', status)}
        # Create a temporary desk
        * ip5.api.v1.auth.login('user', adminUserPwd)

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
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()

        # Associate a non-existing user to the temporary desk created above
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(nonExistingUserId)"] }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-todo
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'associate a non-existing desk to an existing user in an existing tenant', status)}
        # Get data
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingDeskId = ip5.api.v1.desk.getNonExistingId()
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        # Associate an existing user to a non-existing desk
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'associate a non-existing desk to a non-existing user in an existing tenant', status)}
        # Get data
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingDeskId = ip5.api.v1.desk.getNonExistingId()

        # Associate a non-existing user to a non-existing desk
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(nonExistingUserId)"] }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
