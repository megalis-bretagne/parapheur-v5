@api @ip5 @ip-core @api-v1 @admin-tenant-controller
Feature: PUT /api/v1/admin/tenant/{tenantId} (Edit tenant)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def unique = 'tmp-' + ip.utils.getUUID()
        * def cleanRequestData = { name: '#(unique)' }

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'edit an existing tenant', status)}
        # Create a temporary tenant
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def id = ip5.api.v1.entity.createTemporary()

		# Try to edit it
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', id
            And header Accept = 'application/json'
            And request cleanRequestData
        When method PUT
        Then status <status>
            And if (<status> === 200) ip.utils.assert("$ == schemas.tenant.element")
            And if (<status> === 200) ip.utils.assert("$ contains cleanRequestData")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
            | TENANT_ADMIN     | vgris        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'edit a non-existing tenant', status)}
        * def id = ip5.api.v1.entity.getNonExistingId()
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', id
            And header Accept = 'application/json'
            And request cleanRequestData
        When method PUT
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    @data-validation
    Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'edit an existing tenant', status, data)}
        # Create a temporary tenant
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def id = ip5.api.v1.entity.createTemporary()

        # Try to edit it
        * ip5.api.v1.auth.login('cnoir', 'a123456')
        * def requestData = cleanRequestData
        * requestData[field] = ip.utils.eval(value)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', id
            And header Accept = 'application/json'
            And request requestData
        When method PUT
        Then status <status>
            And if (<status> === 200) ip.utils.assert("$ == schemas.tenant.element")
            And if (<status> === 200) ip.utils.assert("$ contains requestData")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | status | field | value!                                      | data                                    |
            | 200    | name  | eval(ip.utils.string.getRandom(1))             | a name that is at least 1 character     |
            | 200    | name  | eval(ip.utils.string.getRandom(64, 'tmp-'))    | a name that is up to 64 characters long |
        @fixme-ip5 @issue-todo
        Examples:
            | status | field | value!                                      | data                                    |
            | 400    | name  | ''                                          | an empty name                           |
            | 400    | name  | ' '                                         | a space as a name                       |
            | 400    | name  | eval(ip.utils.string.getRandom(65, 'tmp-'))    | a name that is above 64 characters long |
            | 409    | name  | 'Montpellier Méditerranée Métropole'        | a name that already exists              |

