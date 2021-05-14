@ip-core @api-v1
Feature: POST /api/admin/tenant/{tenantId}/sealCertificate (Import a new seal certificate)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} import a new seal certificate in an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'
            And def expected = {'name':'Christian Buffin - Preparation recette IP 5','expirationDate':'2024-02-25T12:11:44.000+00:00'}

        When method POST
        Then status <status>
            And if (<status> === 201) karate.match("$ == schemas.sealCertificate.element")
            And if (<status> === 201) karate.match("$ contains expected")

        # @fixme: it's not really imported ?
        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot import a new seal certificate in a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'

        When method POST
        Then status <status>
            And match $ == schemas.error

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: Data validation - a user with an "ADMIN" role cannot import a new seal certificate with ${wrong_data}
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field <field> = utils.eval(value)

        When method POST
        Then status <status>
        And match $ == schemas.error

        Examples:
            | status | field    | value!                                       | wrong_data                  |
            | 400    | password | ''                                           | an empty password           |
            | 400    | password | ' '                                          | a space as a password       |
            | 400    | password | 'foobarbaz'                                  | a wrong password            |
            | 400    | password | eval(utils.string.getByLength(1025, 'tmp-')) | a password that is too long |
