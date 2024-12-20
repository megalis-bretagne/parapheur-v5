@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: GET /api/provisioning/v1/admin/tenant/{tenantId}/user/{userId}/signatureImage (Get user's signature image)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get an existing user\'s signature image from an existing tenant', status)}
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, '<email>')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) ip.utils.assert("header Content-Type == 'image/png;charset=UTF-8'")
            And if (<status> === 200) ip.utils.assert("response == read('<path>')")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | email                  | status | path                                                |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | ltransparent@dom.local | 200    | classpath:files/images/signature - ltransparent.png |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | cnoir@dom.local        | 404    |                                                     |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | ltransparent@dom.local | 200    | classpath:files/images/signature - ltransparent.png |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | cnoir@dom.local        | 404    |                                                     |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | ltransparent@dom.local | 403    |                                                     |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | ltransparent@dom.local | 403    |                                                     |
            |                  |              |          | ltransparent@dom.local | 401    |                                                     |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get a non-existing user\'s signature image from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get an existing user\'s signature image from a non-existing tenant', status)}
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, '<email>')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | email                  | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | ne-pas-repondre@dom.local  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | ltransparent@dom.local | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | ltransparent@dom.local | 404    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | ltransparent@dom.local | 404    |
            |                  |              |          | ltransparent@dom.local | 404    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get a non-existing user\'s signature image from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/signatureImage'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 404    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 404    |
            |                  |              |          | 404    |
