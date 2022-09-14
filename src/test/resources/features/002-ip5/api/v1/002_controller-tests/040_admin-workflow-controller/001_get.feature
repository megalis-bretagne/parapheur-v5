@api @ip5 @ip-core @api-v1 @admin-workflow-controller
Feature: GET /api/v1/admin/tenant/{tenantId}/workflowDefinition (getWorkflowDefinitions)

    Background:
        * api_v1.auth.login('user', 'password')
        * def list = api_v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the workflow definition list from an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) ip.utils.assert("$ == schemas.workflow.index")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
            | TENANT_ADMIN     | vgris        | a123456  | 200    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the workflow definition list from a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @searching
    Scenario Outline: ${ip5.scenario.title.searching('ADMIN', 'get the workflow definition list from an existing tenant', 200, total, searchTerm, sort, direction)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')

        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And param sort = '<sort>,<direction>'
            And param searchTerm = '<searchTerm>'
        When method GET
        Then status 200
            And match $ == schemas.workflow.index
            And match $.total == <total>
            And match $.data[*]['<field>'] == <value>

        Examples:
            | searchTerm | sort | direction | total | field | value!                                                                                                                 |
            | foo        | NAME | DESC      | 0     | name  | []                                                                                                                     |
            |            | NAME | ASC       | 4     | name  | [ 'Transparent - Cachet Serveur', 'Transparent - Signature', 'Transparent - Signature externe', 'Transparent - Visa' ] |
            |            | NAME | DESC      | 4     | name  | [ 'Transparent - Visa', 'Transparent - Signature externe', 'Transparent - Signature', 'Transparent - Cachet Serveur' ] |
            | Signature  | NAME | ASC       | 2     | name  | [ 'Transparent - Signature', 'Transparent - Signature externe' ]                                                       |
            | Signature  | NAME | DESC      | 2     | name  | [ 'Transparent - Signature externe', 'Transparent - Signature' ]                                                       |
        @fixme-ip5 @issue-todo
        Examples:
            | searchTerm | sort | direction | total | field | value!                                                                                                                 |
            | signature  | NAME | ASC       | 2     | name  | [ 'Transparent - Signature', 'Transparent - Signature externe' ]                                                       |
            | signature  | NAME | DESC      | 2     | name  | [ 'Transparent - Signature externe', 'Transparent - Signature' ]                                                       |
