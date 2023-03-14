@api @ip5 @ip-core @api-v1 @admin-metadata-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/metadata (Create metadata)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a simple test metadata and associate it to an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def name = 'tmp-' + ip.utils.getUUID()

        * ip5.api.v1.auth.login('<username>', '<password>')

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
        And if (<status> === 201) ip.utils.assert("$ == schemas.metadata.element")
        And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 201    |
        @fixme-ip5 @issue-todo
        Examples:
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |
