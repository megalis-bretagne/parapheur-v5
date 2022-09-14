@api @ip5 @ip-core @api-v1 @admin-tenant-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/sealCertificate (Import a new seal certificate)

    Background:
        * api_v1.auth.login('user', 'password')
        * def list = api_v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'import a new seal certificate into an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'
            And def expected = {'name':'Christian Buffin - Preparation recette IP 5','expirationDate':'2024-02-25T12:11:44.000+00:00'}

        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.sealCertificate.element")
            And if (<status> === 201) utils.assert("$ contains expected")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456  | 201    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip5
    Scenario Outline: ${scenario.title.permissions(role, 'import a new seal certificate into a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'

        When method POST
        Then status <status>
            And utils.assert("$ == schemas.error")

        @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('ADMIN', 'import a new seal certificate into an existing tenant', status, data)}
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: '<path>', 'contentType': 'application/x-pkcs12' }
            And multipart field <field> = utils.eval(value)

        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.sealCertificate.element")
            And if (<status> === 201) utils.assert("$ contains expected")
            And if (<status> === 400) utils.assert("$ == schemas.error")

        Examples:
            | status | field    | value!                                     | data                                    | path                                                | expected!                                                                                               |
            | 201    | password | 'christian.buffin@libriciel.coop'          | a correct certificate file and password | classpath:files/certificate.p12                     | {'name':'Christian Buffin - Preparation recette IP 5','expirationDate':'2024-02-25T12:11:44.000+00:00'} |
            | 400    | password | 'christian.buffin@libriciel.coop'          | a file that is not a certificate        | classpath:files/images/signature - ltransparent.png |                                                                                                         |
            | 400    | password | ''                                         | an empty password                       | classpath:files/certificate.p12                     |                                                                                                         |
            | 400    | password | ' '                                        | a space as a password                   | classpath:files/certificate.p12                     |                                                                                                         |
            | 400    | password | 'foobarbaz'                                | a wrong password                        | classpath:files/certificate.p12                     |                                                                                                         |
            | 400    | password | eval(utils.string.getRandom(1025, 'tmp-')) | a password that is too long             | classpath:files/certificate.p12                     |                                                                                                         |
