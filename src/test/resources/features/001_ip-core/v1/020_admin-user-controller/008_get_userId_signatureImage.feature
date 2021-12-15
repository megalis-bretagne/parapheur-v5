@ip-core @api-v1
Feature: GET /api/v1/admin/tenant/{tenantId}/user/{userId}/signatureImage (Get user's signature image)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def nonExistingUserId = api_v1.user.getNonExistingId()

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get an existing user\'s signature image from an existing tenant', status)}
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) utils.assert("header Content-Type == 'image/png;charset=UTF-8'")
            And if (<status> === 200) utils.assert("response == read('<path>')")
            And if (<status> === 404) utils.assert("response == '404 NOT_FOUND \"Lutilisateur na pas dimage de signature définie\"'")
            And if (<status> !== 200 && <status> !== 404) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | email                  | status | path                                         |
            | TENANT_ADMIN     | cnoir        | a123456  | ltransparent@dom.local | 200    | classpath:files/signature - ltransparent.png |
            | TENANT_ADMIN     | cnoir        | a123456  | cnoir@dom.local        | 404    |                                              |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | ltransparent@dom.local | 403    |                                              |
            | NONE             | ltransparent | a123456  | ltransparent@dom.local | 403    |                                              |
            |                  |              |          | ltransparent@dom.local | 401    |                                              |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get a non-existing user\'s signature image from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 404) utils.assert("response == '404 NOT_FOUND \"LID de lentité est introuvable\"'")
            And if (<status> !== 404) utils.assert("$ == schemas.error")

        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get an existing user\'s signature image from a non-existing tenant', status)}
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 404) utils.assert("response == '404 NOT_FOUND \"LID de lentité est introuvable\"'")
            And if (<status> !== 404) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | email                  | status |
            | TENANT_ADMIN     | cnoir        | a123456  | sample-user@dom.local  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | ltransparent@dom.local | 403    |
            | NONE             | ltransparent | a123456  | ltransparent@dom.local | 403    |
            |                  |              |          | ltransparent@dom.local | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get a non-existing user\'s signature image from a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 404) utils.assert("response == '404 NOT_FOUND \"LID de lentité est introuvable\"'")
            And if (<status> !== 404) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
