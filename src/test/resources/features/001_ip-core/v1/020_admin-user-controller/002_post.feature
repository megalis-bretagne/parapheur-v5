@ip-core @api-v1
Feature: POST /api/admin/tenant/{tenantId}/user (Create a new user)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def unique = 'tmp-' + utils.getUUID()
        * def email = unique + '@test'
        * def uniqueRequestData =
"""
{
    userName : '#(unique)',
    email: '#(email)',
    firstName: 'tmp',
    lastName: 'tmp',
    password: 'a123456',
    privilege: 'NONE',
    notificationsCronFrequency: 'NONE',
    notificationsRedirectionMail: '#(email)'
}
"""

    @permissions @todo-proposal
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} create a user in an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>
            And if (<status> === 201) karate.match("response == ''")
            # proposal: response body should be not null ?
            # And match $ == schemas.user.element

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
        @fixme-ip-core
        Examples:
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |


    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot create a user in a non-existing tenant
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core
        Examples:
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation @proposal
    # @fixme: status 400 missing from swagger
    Scenario: Data validation - a user with an "ADMIN" role cannot create a user with empty data
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request
"""
{
    userName : '',
    email: '',
    firstName: '',
    lastName: '',
    password: '',
    privilege: '',
    notificationsCronFrequency: '',
    notificationsRedirectionMail: ''
}
"""
        When method POST
        Then status 400

    @data-validation @fixme-ip-core @proposal
    Scenario: Data validation - a user with an "ADMIN" role cannot create a user with already existing userName or email values
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request
"""
{
    userName : 'cnoir',
    email: 'cnoir@dom.local',
    firstName: 'Christian',
    lastName: 'Noir',
    password: 'a123456',
    privilege: 'NONE',
    notificationsCronFrequency: '',
    notificationsRedirectionMail: 'cnoir@dom.local'
}
"""
        When method POST
        Then status 400
        * print response

    @data-validation @fixme-ip-core @proposal
    Scenario: Data validation - a user with an "ADMIN" role cannot create a user with invalid data
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request
"""
{
    userName : 'é',
    email: 'é',
    firstName: 'é',
    lastName: 'é',
    password: 'é',
    privilege: 'NONE',
    notificationsCronFrequency: '',
    notificationsRedirectionMail: 'é'
}
"""
        When method POST
        Then status 400
        * print response
