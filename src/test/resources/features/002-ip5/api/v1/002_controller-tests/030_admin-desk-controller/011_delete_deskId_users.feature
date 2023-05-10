@api @ip5 @ip-core @api-v1 @admin-desk-controller
Feature: DELETE /api/v1/admin/tenant/{tenantId}/desk/{deskId}/users (Remove user from desk)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'remove an existing user from an existing desk in an existing tenant', status)}
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
	"ownerIds": [],
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
        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status 200

        # Remove the user from the desk
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/users/?userIdList=' + existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) ip.utils.assert("response == ''")
            And if (<status> !== 204) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 204    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 204    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'remove an existing user from an existing desk in a non-existing tenant', status)}
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
	"ownerIds": [],
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
        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status 200

        # Remove the user from the desk
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/users/?userIdList=' + existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 404    |
            | NONE             | ltransparent | a123456a123456  | 404    |
            |                  |              |          | 404    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'remove an existing user from a non-existing desk in an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingDeskId = ip5.api.v1.desk.getNonExistingId()
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/users/?userIdList=' + existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |


    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'remove a non-existing user from an existing desk in an existing tenant', status)}
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
	"ownerIds": [],
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

        # Remove the user from the desk
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/users/?userIdList=' + nonExistingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) ip.utils.assert("response == ''")
            And if (<status> !== 204) ip.utils.assert("$ == schemas.error")

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
            |                  |              |          | 401    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
