@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: PUT /api/v1/admin/tenant/{tenantId}/user/{userId}/signatureImage (Replace user's signature image)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'replace a signature image for an existing user in an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - ltransparent.png', 'contentType': 'image/png' }
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'replace a signature image for a non-existing user in an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
        When method PUT
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        @fixme-ip5 @issue-todo
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'replace a signature image for an existing user in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, 'stranslucide@dom.local')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'replace a signature image for a non-existing user in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
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

    @data-validation
    Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'replace a signature image for an existing user in an existing tenant', status, data)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def existingUserId = email == null ? ip5.api.v1.user.createTemporary(existingTenantId) : ip5.api.v1.user.getIdByEmail(existingTenantId, '<email>')

        * ip5.api.v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: <path>, 'contentType': '<contentType>' }
        When method PUT
        Then status <status>
            And if (<status> === 200) ip.utils.assert("response == ''")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | status | email                  | path!                                                 | contentType | data                                        |
            | 200    | ltransparent@dom.local | 'classpath:files/images/signature - ltransparent.png' | image/png   | a PNG file                                  |
            | 404    |                        | 'classpath:files/images/signature - stranslucide.png' | image/png   | a PNG file while none is already configured |
        @fixme-ip5 @issue-todo
        Examples:
            | status | email                  | path!                             | contentType          | data       |
            | 400    | ltransparent@dom.local | 'classpath:files/certificate.p12' | application/x-pkcs12 | a P12 file |
