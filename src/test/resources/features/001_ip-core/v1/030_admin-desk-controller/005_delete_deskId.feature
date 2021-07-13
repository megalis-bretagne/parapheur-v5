@ip-core @api-v1
Feature: DELETE /api/v1/admin/tenant/{tenantId}/desk/{deskId} (Delete desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        * def deskData = api_v1.desk.getById(existingTenantId, existingDeskId)

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'delete an existing desk from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

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
    Scenario Outline: ${scenario.title.permissions(role, 'delete an existing desk from a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

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
    Scenario Outline: ${scenario.title.permissions(role, 'delete a non-existing desk from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'delete a non-existing desk from a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
