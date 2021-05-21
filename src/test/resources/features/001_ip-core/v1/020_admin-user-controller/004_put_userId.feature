@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId}/user/{userId} (Update user)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingUserId = api_v1.user.createTemporary(existingTenantId)
        * def nonExistingUserId = api_v1.user.getNonExistingId()
        * def existingUserData = api_v1.user.getById(existingTenantId, existingUserId)

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} edit an existing user from an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request existingUserData
        When method PUT
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.tenant.element")
            And if (<status> === 201) utils.assert("$ contains { id: '#(id)', name: '#(name)' }")

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
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} edit an existing user from a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request existingUserData
        When method PUT
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} edit a non-existing user from an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
            And request existingUserData
        When method PUT
        Then status <status>

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403s   |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} edit a non-existing user from a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
            And request existingUserData
        When method PUT
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    #-------------------------------------------------------------------------------------------------------------------
    # @fixme: status 400 missing from swagger
    @data-validation
    Scenario Outline: Data validation - a user with an "ADMIN" role cannot edit a user with ${wrong_data}
        * api_v1.auth.login('cnoir', 'a123456')
        * def requestData = existingUserData
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request requestData
        #* print requestData

        When method PUT
        Then status <status>
            And match $ == schemas.error


        Examples:
            | status | field                        | value!                                                     | wrong_data                                          |
            | 400    | privilege                    | ''                                                         | an empty privilege                                  |
            | 400    | privilege                    | ' '                                                        | a space as privilege                                |
            | 400    | privilege                    | 'foo'                                                      | a privilege that is not amongst the accepted values |
            | 400    | privilege                    | eval(utils.string.getByLength(257, 'tmp-'))                | a privilege that is too long                        |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field                        | value!                                                     | wrong_data                                          |
            | 400    | userName                     | ''                                                         | an empty userName                                   |
            | 400    | userName                     | ' '                                                        | a space as a userName                               |
            | 400    | userName                     | eval(utils.string.getByLength(257, 'tmp-'))                | a userName that is too long                         |
            | 409    | userName                     | 'user'                                                     | a userName that already exists                      |
            | 400    | email                        | eval(utils.string.getByLength(257, 'tmp-') + '@dom.local') | an email that is too long                           |
            | 409    | email                        | 'sample-user@dom.local'                                    | an email that already exists                        |
            | 400    | firstName                    | eval(utils.string.getByLength(257, 'tmp-'))                | a first name that is too long                       |
            | 400    | lastName                     | eval(utils.string.getByLength(257, 'tmp-'))                | a last name that is too long                        |
            | 400    | email                        | ''                                                         | an empty email                                      |
            | 400    | email                        | ' '                                                        | a space as email                                    |
            | 400    | email                        | 'foo'                                                      | a value that is not an email                        |
            | 400    | firstName                    | ''                                                         | an empty first name                                 |
            | 400    | firstName                    | ' '                                                        | a space as a first name                             |
            | 400    | lastName                     | ''                                                         | an empty last name                                  |
            | 400    | lastName                     | ' '                                                        | a space as last name                                |
            | 400    | password                     | ''                                                         | an empty password                                   |
            | 400    | password                     | ' '                                                        | a space as password                                 |
            | 400    | password                     | eval(utils.string.getByLength(257, 'tmp-'))                | a password that is too long                         |
            | 400    | notificationsCronFrequency   | ''                                                         | an empty frequency                                  |
            | 400    | notificationsCronFrequency   | ' '                                                        | a space as frequency                                |
            | 400    | notificationsCronFrequency   | 'foo'                                                      | a frequency that is not amongst the accepted values |
            | 400    | notificationsCronFrequency   | eval(utils.string.getByLength(257, 'tmp-'))                | a frequency that is too long                        |
            | 400    | notificationsRedirectionMail | ' '                                                        | a space as notification email                       |
            | 400    | notificationsRedirectionMail | 'foo'                                                      | a value that is not a notification email            |
            | 400    | notificationsRedirectionMail | eval(utils.string.getByLength(257, 'tmp-') + '@dom.local') | a notification email that is too long               |
