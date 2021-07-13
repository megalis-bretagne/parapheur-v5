@ip-core @api-v1
Feature: POST /api/v1/admin/tenant/{tenantId}/user/{userId}/signatureImage (Create user's signature image)

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a signature image for an existing user in an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def existingUserId = email == null ? api_v1.user.createTemporary(existingTenantId) : api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: '<path>', 'contentType': 'image/png' }
        When method POST
        Then status <status>
            # @todo: file, special schema
            And if (<status> === 201) utils.assert("$ == { 'value': '#uuid' }")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | email                  | path                                         | status |
            | TENANT_ADMIN     | cnoir        | a123456  |                        | classpath:files/signature - stranslucide.png | 201    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | email                  | path                                         | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | stranslucide@dom.local | classpath:files/signature - stranslucide.png | 403    |
            | NONE             | ltransparent | a123456  | stranslucide@dom.local | classpath:files/signature - stranslucide.png | 403    |
            |                  |              |          | stranslucide@dom.local | classpath:files/signature - stranslucide.png | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a signature image for a non-existing user in an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingUserId = api_v1.user.getNonExistingId()
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/signature - stranslucide.png', 'contentType': 'image/png' }
        When method POST
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a signature image for an existing user in a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'stranslucide@dom.local')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/signature - stranslucide.png', 'contentType': 'image/png' }
        When method POST
        Then status <status>
            And match $ == schemas.error

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a signature image for a non-existing user in a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def nonExistingUserId = api_v1.user.getNonExistingId()
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/signature - stranslucide.png', 'contentType': 'image/png' }
        When method POST
        Then status <status>
            And match $ == schemas.error

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('TENANT_ADMIN', 'create a signature image for an existing user in an existing tenant', status, data)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def existingUserId = email == null ? api_v1.user.createTemporary(existingTenantId) : api_v1.user.getIdByEmail(existingTenantId, '<email>')

        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: <path>, 'contentType': '<contentType>' }
        When method POST
        Then status <status>
            # @todo: file, special schema
            And if (<status> === 201) utils.assert("$ == { 'value': '#uuid' }")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | status | email                  | path!                                          | contentType          | data                                                |
            | 201    |                        | 'classpath:files/signature - stranslucide.png' | image/png            | a PNG file                                         |
            | 409    | ltransparent@dom.local | 'classpath:files/signature - ltransparent.png' | image/png            | a PNG file while another one is already configured |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | email                  | path!                                          | contentType          | data                                                |
            | 400    |                        | 'classpath:files/certificate.p12'              | application/x-pkcs12 | a P12 file                                         |
