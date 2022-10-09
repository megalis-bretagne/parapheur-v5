@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: PUT /api/v1/admin/tenant/{tenantId}/user/{userId} (Update user)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingUserId = ip5.api.v1.user.createTemporary(existingTenantId)
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()
        * def existingUserData = ip5.api.v1.user.getById(existingTenantId, existingUserId)

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'edit an existing user from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request existingUserData
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
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'edit an existing user from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request existingUserData
        When method PUT
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'edit a non-existing user from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
            And request existingUserData
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'edit a non-existing user from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
            And request existingUserData
        When method PUT
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    # @fixme: status 400 missing from swagger
    @data-validation
    Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'edit an existing user in an existing tenant', status, data)}
        * ip5.api.v1.auth.login('cnoir', 'a123456')
        * def requestData = existingUserData
        * requestData[field] = ip.utils.eval(value)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request requestData

        When method PUT
        Then status <status>
            And if (<status> === 200) ip.utils.assert("response == ''")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | status | field                        | value!                                                   | data                                                |
            | 200    | userName                     | 'u'                                                      | a user name that is 1 character long                |
            | 200    | userName                     | eval(ip.utils.string.getRandom(255, 'tmp-'))                | a user name that is 255 characters long             |
            | 200    | firstName                    | 'u'                                                      | a first name that is 1 character long               |
            | 200    | firstName                    | eval(ip.utils.string.getRandom(255, 'tmp-'))                | a first name that is 255 characters long            |
            | 200    | lastName                     | 'u'                                                      | a last name that is 1 character long                |
            | 200    | lastName                     | eval(ip.utils.string.getRandom(255, 'tmp-'))                | a last name that is 255 characters long             |
            | 200    | email                        | eval(ip.utils.string.getRandom(245, 'tmp-') + '@dom.local') | an email that is 255 characters long                |
            | 200    | privilege                    | 'TENANT_ADMIN'                                                  | "TENANT_ADMIN" privilege                                   |
            | 200    | privilege                    | 'FUNCTIONAL_ADMIN'                                       | "FUNCTIONAL_ADMIN" privilege                        |
            | 200    | privilege                    | 'NONE'                                                   | "NONE" privilege                                    |
            | 400    | privilege                    | ''                                                       | an empty privilege                                  |
            | 400    | privilege                    | ' '                                                      | a space as privilege                                |
            | 400    | privilege                    | 'foo'                                                    | a privilege that is not amongst the accepted values |
        @fixme-ip5 @issue-todo
        Examples:
            | status | field                        | value!                                                   | data                                                |
            | 400    | userName                     | ''                                                       | an empty user name                                  |
            | 400    | userName                     | ' '                                                      | a space as a user name                              |
            | 400    | userName                     | eval(ip.utils.string.getRandom(256, 'tmp-'))                | a user name that is 256 characters long             |
            | 409    | userName                     | 'user'                                                   | a user name that already exists                     |
            | 400    | firstName                    | ''                                                       | an empty first name                                 |
            | 400    | firstName                    | ' '                                                      | a space as a first name                             |
            | 400    | firstName                    | eval(ip.utils.string.getRandom(256, 'tmp-'))                | a first name that is 256 characters long            |
            | 400    | lastName                     | ''                                                       | an empty last name                                  |
            | 400    | lastName                     | ' '                                                      | a space as last name                                |
            | 400    | lastName                     | eval(ip.utils.string.getRandom(256, 'tmp-'))                | a last name that is 256 characters long             |
            | 400    | email                        | ''                                                       | an empty email                                      |
            | 400    | email                        | ' '                                                      | a space as email                                    |
            | 400    | email                        | 'foo'                                                    | a value that is not an email                        |
            | 400    | email                        | eval(ip.utils.string.getRandom(246, 'tmp-') + '@dom.local') | an email that is 256 characters long                |
            | 409    | email                        | 'sample-user@dom.local'                                  | an email that already exists                        |
            | 400    | password                     | ''                                                       | an empty password                                   |
            | 400    | password                     | ' '                                                      | a space as password                                 |
            | 400    | notificationsCronFrequency   | ''                                                       | an empty frequency                                  |
            | 400    | notificationsCronFrequency   | ' '                                                      | a space as frequency                                |
            | 400    | notificationsCronFrequency   | 'foo'                                                    | a frequency that is not amongst the accepted values |
            | 400    | notificationsCronFrequency   | eval(ip.utils.string.getRandom(257, 'tmp-'))                | a frequency that is too long                        |
            | 400    | notificationsRedirectionMail | ' '                                                      | a space as notification email                       |
            | 400    | notificationsRedirectionMail | 'foo'                                                    | a value that is not a notification email            |
            | 400    | notificationsRedirectionMail | eval(ip.utils.string.getRandom(257, 'tmp-') + '@dom.local') | a notification email that is too long               |
