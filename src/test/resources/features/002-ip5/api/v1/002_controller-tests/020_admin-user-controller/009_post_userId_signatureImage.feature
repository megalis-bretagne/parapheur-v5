@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/user/{userId}/signatureImage (Create user's signature image)

    Background:
        * ip5.api.v1.auth.login('user', 'password')
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a signature image for an existing user in an existing tenant', status)}
        * ip5.api.v1.auth.login('user', 'password')
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def existingUserId = email == null ? ip5.api.v1.user.createTemporary(existingTenantId) : ip5.api.v1.user.getIdByEmail(existingTenantId, '<email>')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: '<path>', 'contentType': 'image/png' }
        When method POST
        Then status <status>
            And if (<status> === 201) ip.utils.assert("$ == { 'value': '#uuid' }")
            And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | email                  | path                                                | status |
            | ADMIN            | cnoir        | a123456  |                        | classpath:files/images/signature - stranslucide.png | 201    |
            | TENANT_ADMIN     | vgris        | a123456  |                        | classpath:files/images/signature - stranslucide.png | 201    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | stranslucide@dom.local | classpath:files/images/signature - stranslucide.png | 403    |
            | NONE             | ltransparent | a123456  | stranslucide@dom.local | classpath:files/images/signature - stranslucide.png | 403    |
            |                  |              |          | stranslucide@dom.local | classpath:files/images/signature - stranslucide.png | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a signature image for a non-existing user in an existing tenant', status)}
        * ip5.api.v1.auth.login('user', 'password')
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
        When method POST
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a signature image for an existing user in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', 'password')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, 'stranslucide@dom.local')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
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

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a signature image for a non-existing user in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', 'password')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
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
    Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'create a signature image for an existing user in an existing tenant', status, data)}
        * ip5.api.v1.auth.login('user', 'password')
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Default tenant')
        * def existingUserId = email == null ? ip5.api.v1.user.createTemporary(existingTenantId) : ip5.api.v1.user.getIdByEmail(existingTenantId, '<email>')

        * ip5.api.v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: <path>, 'contentType': '<contentType>' }
        When method POST
        Then status <status>
            # @todo: file, special schema
            And if (<status> === 201) ip.utils.assert("$ == { 'value': '#uuid' }")
            And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | status | email                  | path!                                                 | contentType | data                                               |
            | 201    |                        | 'classpath:files/images/signature - stranslucide.png' | image/png   | a PNG file                                         |
            | 409    | ltransparent@dom.local | 'classpath:files/images/signature - ltransparent.png' | image/png   | a PNG file while another one is already configured |
        @fixme-ip5 @issue-todo
        Examples:
            | status | email | path!                             | contentType          | data       |
            | 400    |       | 'classpath:files/certificate.p12' | application/x-pkcs12 | a P12 file |
