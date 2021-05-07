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

    # @fixme: status 400 missing from swagger
    @data-validation @proposal @wip
    Scenario Outline: Data validation - a user with an "ADMIN" role cannot create a user with ${wrong_data}
        * api_v1.auth.login('cnoir', 'a123456')
        * def requestData = uniqueRequestData
        * requestData[field] = value

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request requestData

        When method POST
        Then status <status>
            And match $ ==
"""
{
	"path":"#string",
	"error":"##string",
	"message":"#string",
	"timestamp":"#string",
	"status":#number
}
"""

        Examples:
            | status | field                        | value!                                          | wrong_data                                          |
            | 400    | userName                     | ''                                              | an empty userName                                   |
            | 400    | userName                     | ' '                                             | a space as a userName                               |
            | 400    | userName                     | 'tmp-' + '0123456789'.repeat(30)                | a userName that is too long                         |
            | 409    | userName                     | 'user'                                          | a userName that already exists                      |
            | 400    | email                        | 'tmp-' + '0123456789'.repeat(30) + '@dom.local' | an email that is too long                           |
            | 409    | email                        | 'sample-user@dom.local'                         | an email that already exists                        |
            | 400    | firstName                    | 'tmp-' + '0123456789'.repeat(30)                | a first name that is too long                       |
            | 400    | lastName                     | 'tmp-' + '0123456789'.repeat(30)                | a last name that is too long                        |
            | 400    | privilege                    | ''                                              | an empty privilege                                  |
            | 400    | privilege                    | ' '                                             | a space as privilege                                |
            | 400    | privilege                    | 'foo'                                           | a privilege that is not amongst the accepted values |
            | 400    | privilege                    | 'tmp-' + '0123456789'.repeat(30)                | a privilege that is too long                        |
        @fixme-ip-core
        Examples:
            | status | field                        | value!                                          | wrong_data                                          |
            | 400    | email                        | ''                                              | an empty email                                      |
            | 400    | email                        | ' '                                             | a space as email                                    |
            | 400    | email                        | 'foo'                                           | a value that is not an email                        |
            | 400    | firstName                    | ''                                              | an empty first name                                 |
            | 400    | firstName                    | ' '                                             | a space as a first name                             |
            | 400    | lastName                     | ''                                              | an empty last name                                  |
            | 400    | lastName                     | ' '                                             | a space as last name                                |
            | 400    | password                     | ''                                              | an empty password                                   |
            | 400    | password                     | ' '                                             | a space as password                                 |
            | 400    | password                     | 'tmp-' + '0123456789'.repeat(30)                | a password that is too long                         |
            | 400    | notificationsCronFrequency   | ''                                              | an empty frequency                                  |
            | 400    | notificationsCronFrequency   | ' '                                             | a space as frequency                                |
            | 400    | notificationsCronFrequency   | 'foo'                                           | a frequency that is not amongst the accepted values |
            | 400    | notificationsCronFrequency   | 'tmp-' + '0123456789'.repeat(30)                | a frequency that is too long                        |
            | 400    | notificationsRedirectionMail | ' '                                             | a space as notification email                       |
            | 400    | notificationsRedirectionMail | 'foo'                                           | a value that is not a notification email            |
            | 400    | notificationsRedirectionMail | 'tmp-' + '0123456789'.repeat(30) + '@dom.local' | a notification email that is too long               |
