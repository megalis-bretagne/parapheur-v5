@ip-core @api-v1
Feature: DELETE /api/v1/admin/tenant/{tenantId}/desk/{deskId}/users (Remove user from desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'remove an existing user from an existing desk in an existing tenant', status)}
        # Create a temporary desk
        * api_v1.auth.login('user', 'password')
        * def unique = 'tmp-' + utils.getUUID()

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(unique)',
    "shortName": "#(unique)",
    'description': 'Bureau #(unique)',
    'parentDeskId': null
}
"""
        When method POST
        Then status 201

        * def existingDeskId = $.id
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        # Associate an existing user to the temporary desk created above
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status 200

        # Remove the user from the desk
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/users/?userIdList=' + existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) utils.assert("response == ''")
            And if (<status> !== 204) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 204    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'remove an existing user from an existing desk in a non-existing tenant', status)}
        # Create a temporary desk
        * api_v1.auth.login('user', 'password')
        * def unique = 'tmp-' + utils.getUUID()

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(unique)',
    'shortName': '#(unique)',
    'description': 'Bureau #(unique)',
    'parentDeskId': null
}
"""
        When method POST
        Then status 201

        * def existingDeskId = $.id
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        # Associate an existing user to the temporary desk created above
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status 200

        # Remove the user from the desk
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/users/?userIdList=' + existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 404) utils.assert("response == '404 NOT_FOUND \"LID de lentité est introuvable\"'")
            And if (<status> !== 404) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'remove an existing user from a non-existing desk in an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/users/?userIdList=' + existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |


    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'remove a non-existing user from an existing desk in an existing tenant', status)}
        # Create a temporary desk
        * api_v1.auth.login('user', 'password')
        * def unique = 'tmp-' + utils.getUUID()

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(unique)',
    'description': 'Bureau #(unique)',
    'parentDeskId': null
}
"""
        When method POST
        Then status 201

        * def existingDeskId = $.id
        * def nonExistingUserId = api_v1.user.getNonExistingId()

        # Remove the user from the desk
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/users/?userIdList=' + nonExistingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) utils.assert("response == ''")
            And if (<status> !== 204) utils.assert("$ == schemas.error")

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
