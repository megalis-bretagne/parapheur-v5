@ip-core @api-v1 @fixme-no-wip-?
Feature: DELETE /api/v1/admin/tenant/{tenantId}/sealCertificate/{sealCertificateId} (Delete the given seal certificate)

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'delete an existing seal certificate in an existing tenant', status)}
        # Create a temporary seal certificate
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'
        When method POST
        Then status 201
            And def existingSealCertificateId = $.id

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/sealCertificate/' + existingSealCertificateId
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
    Scenario Outline: ${scenario.title.permissions(role, 'delete a non-existing seal certificate in an existing tenant', status)}
        # Get informations
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingSealCertificateId = api_v1.sealCertificate.getNonExistingId()

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/sealCertificate/' + nonExistingSealCertificateId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) utils.assert("response == ''")
            And if (<status> !== 204) utils.assert("$ == schemas.error")

        @fixme-ip-core @issue-ip-core-todo
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
    Scenario Outline: ${scenario.title.permissions(role, 'delete an existing seal certificate in a non-existing tenant', status)}
        # Create a temporary seal certificate
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'
        When method POST
        Then status 201
            And def existingSealCertificateId = $.id

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/sealCertificate/' + existingSealCertificateId
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
    Scenario Outline: ${scenario.title.permissions(role, 'delete a non-existing seal certificate in a non-existing tenant', status)}
        # Create a seal certificate
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingSealCertificateId = api_v1.sealCertificate.getNonExistingId()
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/sealCertificate/' + nonExistingSealCertificateId
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
            |                  |              |          | 401    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
