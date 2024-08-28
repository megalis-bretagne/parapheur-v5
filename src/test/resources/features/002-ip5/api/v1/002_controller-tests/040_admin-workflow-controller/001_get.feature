@api @ip5 @ip-core @api-v1 @admin-workflow-controller
Feature: GET /api/v1/admin/tenant/{tenantId}/workflowDefinition (getWorkflowDefinitions)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the workflow definition list from an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')

        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) ip.utils.assert("$ == schemas.workflow.index")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 200    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 200    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the workflow definition list from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @searching
    Scenario Outline: ${ip5.scenario.title.searching('ADMIN', 'get the workflow definition list from an existing tenant', 200, total, searchTerm, sort, direction)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')

        * ip5.api.v1.auth.login('cnoir', 'Ilenfautpeupouretreheureux')

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
