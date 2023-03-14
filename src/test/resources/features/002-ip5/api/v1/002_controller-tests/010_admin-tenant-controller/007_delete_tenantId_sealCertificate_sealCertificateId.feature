@api @ip5 @ip-core @api-v1 @admin-tenant-controller
Feature: DELETE /api/v1/admin/tenant/{tenantId}/sealCertificate/{sealCertificateId} (Delete the given seal certificate)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete an existing seal certificate in an existing tenant', status)}
        # Create a temporary seal certificate
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'
        When method POST
        Then status 201
            And def existingSealCertificateId = $.id

        # Try to delete it
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/sealCertificate/' + existingSealCertificateId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) ip.utils.assert("response == ''")
            And if (<status> !== 204) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 204    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 204    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete a non-existing seal certificate in an existing tenant', status)}
        # Get informations
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingSealCertificateId = ip5.api.v1.sealCertificate.getNonExistingId()

        # Try to delete it
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/sealCertificate/' + nonExistingSealCertificateId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) ip.utils.assert("response == ''")
            And if (<status> !== 204) ip.utils.assert("$ == schemas.error")

        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete an existing seal certificate in a non-existing tenant', status)}
        # Create a temporary seal certificate
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/certificate.p12', 'contentType': 'application/x-pkcs12' }
            And multipart field password = 'christian.buffin@libriciel.coop'
        When method POST
        Then status 201
            And def existingSealCertificateId = $.id

        # Try to delete it
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/sealCertificate/' + existingSealCertificateId
        And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete a non-existing seal certificate in a non-existing tenant', status)}
        # Create a seal certificate
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingSealCertificateId = ip5.api.v1.sealCertificate.getNonExistingId()
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

        # Try to delete it
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
        And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/sealCertificate/' + nonExistingSealCertificateId
        And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |
