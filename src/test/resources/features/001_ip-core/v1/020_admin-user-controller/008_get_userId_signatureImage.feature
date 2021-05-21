@ip-core @api-v1
Feature: GET /api/admin/tenant/{tenantId}/user/{userId}/signatureImage (Get user's signature image)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def nonExistingUserId = api_v1.user.getNonExistingId()

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} get an existing user's signature image from an existing tenant
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) utils.assert("header Content-Type == 'image/png;charset=UTF-8'")
            And if (<status> === 200) utils.assert("response == read('<path>')")

        Examples:
            | role             | username     | password | email                  | status | path                                         |
            | ADMIN            | cnoir        | a123456  | stranslucide@dom.local | 404    |                                              |
            | ADMIN            | cnoir        | a123456  | ltransparent@dom.local | 200    | classpath:files/signature - ltransparent.png |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | email                  | status | path                                         |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | ltransparent@dom.local | 403    |                                              |
            | NONE             | ltransparent | a123456  | ltransparent@dom.local | 403    |                                              |
            |                  |              |          | ltransparent@dom.local | 401    |                                              |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot get a non-existing user's signature image from an existing tenant
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot get an existing user's signature image from a non-existing tenant
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | email                  | status |
            | ADMIN            | cnoir        | a123456  | sample-user@dom.local  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | email                  | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | ltransparent@dom.local | 403    |
            | NONE             | ltransparent | a123456  | ltransparent@dom.local | 403    |
            |                  |              |          | ltransparent@dom.local | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot get a non-existing user's signature image from a non-existing tenant
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
