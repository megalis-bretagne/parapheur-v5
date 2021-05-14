@ip-core @api-v1
Feature: DELETE POST /api/admin/tenant/{tenantId}/sealCertificate/{sealCertificateId} (Delete the given seal certificate)

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} delete an existing seal certificate in an existing tenant
        # Create a temporary seal certificate
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'
        When method POST
        Then status 201
            And def existingSealCertificateId = $.id

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/sealCertificate/' + existingSealCertificateId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 204    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot delete a non-existing seal certificate in an existing tenant
        # Get informations
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingSealCertificateId = api_v1.sealCertificate.getNonExistingId()

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/sealCertificate/' + nonExistingSealCertificateId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot delete an existing seal certificate in a non-existing tenant
        # Create a temporary seal certificate
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'
        When method POST
        Then status 201
            And def existingSealCertificateId = $.id

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/admin/tenant/' + nonExistingTenantId + '/sealCertificate/' + existingSealCertificateId
        And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot delete a non-existing seal certificate in a non-existing tenant
        # Create a seal certificate
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingSealCertificateId = api_v1.sealCertificate.getNonExistingId()
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/admin/tenant/' + nonExistingTenantId + '/sealCertificate/' + nonExistingSealCertificateId
        And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |
