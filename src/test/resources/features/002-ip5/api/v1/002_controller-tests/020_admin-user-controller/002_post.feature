@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/user (Create a new user)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def unique = 'tmp-' + ip.utils.getUUID()
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
    notificationsCronFrequency: '0 7 * * 1',
    notificationsRedirectionMail: '#(email)'
}
"""

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a user in an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>
            And if (<status> === 201) ip.utils.assert("$ == {'value': '#uuid'}")
            And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456  | 201    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a user in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/user'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    @data-validation
    Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'create a user in an existing tenant', status, data)}
        * ip5.api.v1.auth.login('cnoir', 'a123456')
        * def requestData = uniqueRequestData
        * requestData[field] = ip.utils.eval(value)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/user'
            And header Accept = 'application/json'
            And request requestData

        When method POST
        Then status <status>
            And if (<status> === 201) ip.utils.assert("$ == {'value': '#uuid'}")
            And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | status | field                        | value!                                                   | data                                                |
            | 201    | userName                     | eval(ip.utils.string.getRandom(255, 'tmp-'))                | a user name that is 255 characters long             |
            | 400    | userName                     | ''                                                       | an empty user name                                  |
            | 400    | userName                     | ' '                                                      | a space as a user name                              |
            | 400    | userName                     | eval(ip.utils.string.getRandom(256, 'tmp-'))                | a user name that is 256 characters long             |
            | 409    | userName                     | 'user'                                                   | a user name that already exists                     |
            | 201    | firstName                    | 't'                                                      | a first name that is 1 character long               |
            | 201    | firstName                    | eval(ip.utils.string.getRandom(255, 'tmp-'))                | a first name that is 255 characters long            |
            | 201    | lastName                     | 't'                                                      | a last name that is 1 character long                |
            | 201    | lastName                     | eval(ip.utils.string.getRandom(255, 'tmp-'))                | a last name that is 255 characters long             |
            | 201    | email                        | eval(ip.utils.string.getRandom(245, 'tmp-') + '@dom.local') | an email that is 255 characters long                |
            | 409    | email                        | 'ne-pas-repondre@dom.local'                                  | an email that already exists                        |
            | 201    | privilege                    | 'TENANT_ADMIN'                                           | "TENANT_ADMIN" privilege                                   |
            | 201    | privilege                    | 'FUNCTIONAL_ADMIN'                                       | "FUNCTIONAL_ADMIN" privilege                        |
            | 201    | privilege                    | 'NONE'                                                   | "NONE" privilege                                    |
            | 400    | privilege                    | ''                                                       | an empty privilege                                  |
            | 400    | privilege                    | ' '                                                      | a space as privilege                                |
            | 400    | privilege                    | 'foo'                                                    | a privilege that is not amongst the accepted values |
        @fixme-ip5 @issue-todo
        Examples:
            | status | field                        | value!                                                   | data                                                |
            # @fixme: the following test makes user cnoir lose TENANT_ADMIN rights / tenant association ??
            # Une erreur importante est survenue, et empêche l'application de fonctionner normalement
            # Aucun tenant trouvé pour l'utilisateur actuellement connecté. Rechargez la page. si le problème persiste, contactez votre administrateur.
            # | 201    | userName                     | 't'                                                      | a user name that is 1 character long                |
            | 400    | email                        | ''                                                       | an empty email                                      |
            | 400    | email                        | ' '                                                      | a space as email                                    |
            | 400    | email                        | 'foo'                                                    | a value that is not an email                        |
            | 400    | firstName                    | ''                                                       | an empty first name                                 |
            | 400    | firstName                    | ' '                                                      | a space as a first name                             |
            | 400    | firstName                    | eval(ip.utils.string.getRandom(256, 'tmp-'))                | a first name that is 256 characters long            |
            | 400    | lastName                     | ''                                                       | an empty last name                                  |
            | 400    | lastName                     | ' '                                                      | a space as last name                                |
            | 400    | lastName                     | eval(ip.utils.string.getRandom(256, 'tmp-'))                | a last name that is 256 characters long             |
            | 400    | email                        | eval(ip.utils.string.getRandom(246, 'tmp-') + '@dom.local') | an email that is 256 characters long                |
            | 400    | password                     | ''                                                       | an empty password                                   |
            | 400    | password                     | ' '                                                      | a space as password                                 |
            | 400    | notificationsCronFrequency   | ''                                                       | an empty frequency                                  |
            | 400    | notificationsCronFrequency   | ' '                                                      | a space as frequency                                |
            | 400    | notificationsCronFrequency   | 'foo'                                                    | a frequency that is not amongst the accepted values |
            | 400    | notificationsCronFrequency   | eval(ip.utils.string.getRandom(257, 'tmp-'))                | a frequency that is too long                        |
            | 400    | notificationsRedirectionMail | ' '                                                      | a space as notification email                       |
            | 400    | notificationsRedirectionMail | 'foo'                                                    | a value that is not a notification email            |
            | 400    | notificationsRedirectionMail | eval(ip.utils.string.getRandom(257, 'tmp-') + '@dom.local') | a notification email that is too long               |
