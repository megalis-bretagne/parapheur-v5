@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: PUT /api/provisioning/v1/admin/tenant/{tenantId}/user/{userId}/password (Update user password)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'update the password of an existing user from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'Ilenfautpeupouretreheureux' }
        When method PUT
        Then status <status>
            And if (<status> === 200) ip.utils.assert("response == ''")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 200    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 200    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'update the password of a non-existing user from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'Ilenfautpeupouretreheureux' }
        When method PUT
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'update the password of an existing user from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'Ilenfautpeupouretreheureux' }
        When method PUT
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 404    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 404    |
            |                  |              |          | 404    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'update the password of a non-existing user from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'Ilenfautpeupouretreheureux' }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 403    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 403    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'update the password of an existing user from an existing tenant', status, data)}
        * ip5.api.v1.auth.login('cnoir', 'Ilenfautpeupouretreheureux')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/password'
            And header Accept = 'application/json'
            And request { <field>: <value> }

        When method PUT
        Then status <status>
            And if (<status> === 200) ip.utils.assert("response == ''")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | status | field    | value!    | data                |
            | 200    | password | 'Ilenfautpeupouretreheureux' | a correct password  |
        @fixme-ip5 @issue-todo
        Examples:
            | status | field    | value!    | data                |
            | 400    | password | ''        | an empty password   |
            | 400    | password | ' '       | a space as password |
