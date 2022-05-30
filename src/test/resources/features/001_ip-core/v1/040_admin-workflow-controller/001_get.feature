@ip-core @api-v1 @admin-workflow-controller
Feature: GET /api/v1/admin/tenant/{tenantId}/workflowDefinition (getWorkflowDefinitions)

    Background:
        * api_v1.auth.login('user', 'password')
        * def list = api_v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get the workflow definition list from an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) utils.assert("$ == schemas.workflow.index")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
            | TENANT_ADMIN     | vgris        | a123456  | 200    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get the workflow definition list from a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @searching
    Scenario Outline: ${scenario.title.searching('ADMIN', 'get the workflow definition list from an existing tenant', 200, total, searchTerm, sortBy, asc)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')

        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And param asc = <asc>
            And param sortBy = '<sortBy>'
            And param searchTerm = '<searchTerm>'
        When method GET
        Then status 200
            And match $ == schemas.workflow.index
            And match $.total == <total>
            And match $.data[*]['<field>'] == <value>

        Examples:
            | searchTerm | sortBy | asc!  | total | field | value!                                                                                                                 |
            | foo        | NAME   | false | 0     | name  | []                                                                                                                     |
            |            | NAME   | true  | 4     | name  | [ 'Transparent - Cachet Serveur', 'Transparent - Signature', 'Transparent - Signature externe', 'Transparent - Visa' ] |
            |            | NAME   | false | 4     | name  | [ 'Transparent - Visa', 'Transparent - Signature externe', 'Transparent - Signature', 'Transparent - Cachet Serveur' ] |
            | Signature  | NAME   | true  | 2     | name  | [ 'Transparent - Signature', 'Transparent - Signature externe' ]                                                       |
            | Signature  | NAME   | false | 2     | name  | [ 'Transparent - Signature externe', 'Transparent - Signature' ]                                                       |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | searchTerm | sortBy | asc!  | total | field | value!                                                                                                                 |
            | signature  | NAME   | true  | 2     | name  | [ 'Transparent - Signature', 'Transparent - Signature externe' ]                                                       |
            | signature  | NAME   | false | 2     | name  | [ 'Transparent - Signature externe', 'Transparent - Signature' ]                                                       |
