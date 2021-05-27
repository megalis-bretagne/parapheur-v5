@ip-core @api-v1
Feature: POST /api/admin/tenant/{tenantId}/user (Create a new user)
    # @fixme: status 400 missing from swagger

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def unique = 'tmp-' + utils.getUUID()
        * def email = unique + '@dom.local'
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

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a user in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        @question-ip-core
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a user in a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>
            And match $ == schemas.error

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('ADMIN', 'create a user in an existing tenant', status, data)}
        * api_v1.auth.login('cnoir', 'a123456')
        * def requestData = uniqueRequestData
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request requestData

        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | status | field                        | value!                                                   | data                                                |
            # @fixme: created user isn't returned by further calls to the API, but trying to re-create it leads to a 409
            | 201    | userName                     | 't'                                                      | a user name that is 1 character long                |
            | 201    | userName                     | eval(utils.string.getRandom(255, 'tmp-'))                | a user name that is 255 characters long             |
            | 400    | userName                     | ''                                                       | an empty user name                                  |
            | 400    | userName                     | ' '                                                      | a space as a user name                              |
            | 400    | userName                     | eval(utils.string.getRandom(256, 'tmp-'))                | a user name that is 256 characters long             |
            | 409    | userName                     | 'user'                                                   | a user name that already exists                     |
            | 201    | firstName                    | 't'                                                      | a first name that is 1 character long               |
            | 201    | firstName                    | eval(utils.string.getRandom(255, 'tmp-'))                | a first name that is 255 characters long            |
            | 400    | firstName                    | eval(utils.string.getRandom(256, 'tmp-'))                | a first name that is 256 characters long            |
            | 201    | lastName                     | 't'                                                      | a last name that is 1 character long                |
            | 201    | lastName                     | eval(utils.string.getRandom(255, 'tmp-'))                | a last name that is 255 characters long             |
            | 400    | lastName                     | eval(utils.string.getRandom(256, 'tmp-'))                | a last name that is 256 characters long             |
            | 201    | email                        | eval(utils.string.getRandom(245, 'tmp-') + '@dom.local') | an email that is 255 characters long                |
            | 400    | email                        | eval(utils.string.getRandom(246, 'tmp-') + '@dom.local') | an email that is 256 characters long                |
            | 409    | email                        | 'sample-user@dom.local'                                  | an email that already exists                        |
            | 201    | privilege                    | 'ADMIN'                                                  | "ADMIN" privilege                                   |
            | 201    | privilege                    | 'FUNCTIONAL_ADMIN'                                       | "FUNCTIONAL_ADMIN" privilege                        |
            | 201    | privilege                    | 'NONE'                                                   | "NONE" privilege                                    |
            | 400    | privilege                    | ''                                                       | an empty privilege                                  |
            | 400    | privilege                    | ' '                                                      | a space as privilege                                |
            | 400    | privilege                    | 'foo'                                                    | a privilege that is not amongst the accepted values |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field                        | value!                                                   | data                                                |
            | 400    | email                        | ''                                                       | an empty email                                      |
            | 400    | email                        | ' '                                                      | a space as email                                    |
            | 400    | email                        | 'foo'                                                    | a value that is not an email                        |
            | 400    | firstName                    | ''                                                       | an empty first name                                 |
            | 400    | firstName                    | ' '                                                      | a space as a first name                             |
            | 400    | lastName                     | ''                                                       | an empty last name                                  |
            | 400    | lastName                     | ' '                                                      | a space as last name                                |
            | 400    | password                     | ''                                                       | an empty password                                   |
            | 400    | password                     | ' '                                                      | a space as password                                 |
            | 400    | notificationsCronFrequency   | ''                                                       | an empty frequency                                  |
            | 400    | notificationsCronFrequency   | ' '                                                      | a space as frequency                                |
            | 400    | notificationsCronFrequency   | 'foo'                                                    | a frequency that is not amongst the accepted values |
            | 400    | notificationsCronFrequency   | eval(utils.string.getRandom(257, 'tmp-'))                | a frequency that is too long                        |
            | 400    | notificationsRedirectionMail | ' '                                                      | a space as notification email                       |
            | 400    | notificationsRedirectionMail | 'foo'                                                    | a value that is not a notification email            |
            | 400    | notificationsRedirectionMail | eval(utils.string.getRandom(257, 'tmp-') + '@dom.local') | a notification email that is too long               |
