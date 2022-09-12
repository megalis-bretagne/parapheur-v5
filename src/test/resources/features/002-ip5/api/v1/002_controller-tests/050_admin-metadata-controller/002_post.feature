@api @ip5 @ip-core @api-v1 @admin-metadata-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/metadata (Create metadata)

    Background:
        * api_v1.auth.login('user', 'password')
        * def list = api_v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a simple test metadata and associate it to an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def name = 'tmp-' + utils.getUUID()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/metadata'
            And header Accept = 'application/json'
        And request
"""
{
    "key": "#(name)",
    "name": "#(name)",
    "type": "TEXT",
    "restrictedValues": [],
    "ipngMetadataKeys": []
}
"""
        When method POST
        Then status <status>
        And if (<status> === 201) utils.assert("$ == schemas.metadata.element")
        And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456  | 201    |
        @fixme-ip5 @issue-todo
        Examples:
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
