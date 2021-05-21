@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId}/desk/{deskId}/users (Add user to desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def unique = 'tmp-' + utils.getUUID()

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} associate an existing desk to an existing user in an existing tenant
        # Create a temporary desk
        * api_v1.auth.login('user', 'password')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
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
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        # Associate an existing user to the temporary desk created above
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status <status>
            # @proposal: return at least the id of the created element in JSON

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot associate an existing desk to a non-existing user in an existing tenant
        # Create a temporary desk
        * api_v1.auth.login('user', 'password')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
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

        # Associate a non-existing user to the temporary desk created above
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', existingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(nonExistingUserId)"] }
        When method PUT
        Then status <status>

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 400    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot associate a non-existing desk to an existing user in an existing tenant
        # Get data
        * api_v1.auth.login('user', 'password')
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')

        # Associate an existing user to a non-existing desk
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(existingUserId)"] }
        When method PUT
        Then status <status>

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot associate a non-existing desk to a non-existing user in an existing tenant
        # Get data
        * api_v1.auth.login('user', 'password')
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()

        # Associate a non-existing user to a non-existing desk
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId, '/users'
            And header Accept = 'application/json'
            And request { "userIdList": ["#(nonExistingUserId)"] }
        When method PUT
        Then status <status>

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
