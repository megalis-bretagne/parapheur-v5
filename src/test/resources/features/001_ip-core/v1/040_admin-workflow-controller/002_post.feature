@ip-core @api-v1 @admin-workflow-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/workflowDefinition (Create a workflow definition)

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a one-step "VISA" workflow and associate it to an existing desk in an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)

        * api_v1.auth.login('<username>', '<password>')
        * def unique = 'tmp-' + utils.getUUID()
        * def key = api_v1.desk.getKeyStringFromNameString(unique)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request
"""
{
    "steps": [
        {
            "validators": [
                "#(existingDeskId)"
            ],
            "validationMode": "SIMPLE",
            "name": "#(unique)",
            "type": "VISA",
            "parallelType": "OR"
        }
    ],
    "name": "#(unique)",
    "id": "#(key)",
    "key": "#(key)",
    "deploymentId": "#(key)"
}
"""
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456  | 201    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a one-step "VISA" workflow and associate it to an existing desk in a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)

        * api_v1.auth.login('<username>', '<password>')
        * def unique = 'tmp-' + utils.getUUID()
        * def key = api_v1.desk.getKeyStringFromNameString(unique)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request
"""
{
    "steps": [
        {
            "validators": [
                "#(existingDeskId)"
            ],
            "validationMode": "SIMPLE",
            "name": "#(unique)",
            "type": "VISA",
            "parallelType": "OR"
        }
    ],
    "name": "#(unique)",
    "id": "#(key)",
    "key": "#(key)",
    "deploymentId": "#(key)"
}
"""
        When method POST
        Then status <status>
            And utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    # ------------------------------------------------------------------------------------------------------------------

    @data-validation
    Scenario Outline: ${scenario.title.validation('ADMIN', 'create a one-step "VISA" workflow and associate it to an existing desk in an existing tenant', status, data)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)

        * api_v1.auth.login('cnoir', 'a123456')
        * def unique = 'tmp-' + utils.getUUID()
        * def key = api_v1.desk.getKeyStringFromNameString(unique)

        * def requestData =
"""
{
    "steps": [
        {
            "validators": [
                "#(existingDeskId)"
            ],
            "validationMode": "SIMPLE",
            "name": "#(unique)",
            "type": "VISA",
            "parallelType": "OR"
        }
    ],
    "name": "#(unique)",
    "id": "#(key)",
    "key": "#(key)",
    "deploymentId": "#(key)"
}
"""
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request requestData

        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | status | field        | value!                                     | data                                                 |
            | 201    | id           | eval(utils.string.getRandom(1))            | an id that is 1 character long                       |
            | 201    | id           | eval(utils.string.getRandom(244, 'tmp-'))  | an id that is up to 244 characters long              |
            | 201    | deploymentId | eval(utils.string.getRandom(1))            | a deploymentId that is 1 character long              |
            | 201    | deploymentId | eval(utils.string.getRandom(2000, 'tmp-')) | a deploymentId that is at least 2000 characters long |
            | 201    | key          | eval(utils.string.getRandom(1))            | a key that is 1 character long                       |
            | 201    | key          | eval(utils.string.getRandom(2000))         | a key that is at least 2000 characters long          |
            | 201    | name         | eval(utils.string.getRandom(1))            | a name that is 1 character long                      |
            | 201    | name         | eval(utils.string.getRandom(255, 'tmp-'))  | a name that is up to 255 characters long             |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field        | value!                                     | data                                                 |
            | 400    | id           | ''                                         | an empty id                                          |
            | 400    | id           | ' '                                        | a space as an id                                     |
            | 400    | id           | eval(utils.string.getRandom(245, 'tmp-'))  | an id that is 245 characters long                    |
            | 400    | key          | ''                                         | an empty key                                         |
            | 400    | key          | ' '                                        | a space as an id                                     |
            | 400    | deploymentId | ''                                         | an empty deploymentId                                |
            | 400    | deploymentId | ' '                                        | a space as an deploymentId                           |
            | 400    | name         | ''                                         | an empty name                                        |
            | 400    | name         | ' '                                        | a space as a name                                    |
            | 400    | name         | eval(utils.string.getRandom(256, 'tmp-'))  | a name that is 256 characters long                   |

#    @data-validation @666
#    Scenario Outline: ${scenario.title.validation('ADMIN', 'create a workflow and associate it to a desk in an existing tenant', status, path)}
#        * api_v1.auth.login('user', 'password')
#        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
#        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)
#
#        * def requestData = karate.read('classpath:fixtures/ip-core/v1/admin-workflow-controller/post/data-validation/' + path + '.js')
#
#        Given url baseUrl
#            And path '/api/v1/admin/tenant/', existingTenantId, '/workflowDefinition'
#            And header Accept = 'application/json'
#            And request requestData
#
#        When method POST
#        Then status <status>
#            And if (<status> === 201) utils.assert("response == ''")
#            And if (<status> !== 201) utils.assert("$ == schemas.error")
#
#        Examples:
#            | status | path |
#            | 201    | xxx  |
##        Examples:
##            | status | field | value!               | data                         |
##            | 201    | type  | 'EXTERNAL_SIGNATURE' | an "EXTERNAL_SIGNATURE" type |
##            | 201    | type  | 'SEAL'               | a "SEAL" type                |
##            | 201    | type  | 'SIGNATURE'          | a "SIGNATURE" type           |
##            | 201    | type  | 'VISA'               | a "VISA" type                |
##            | 400    | type  | 'FOO'               | an unknown type                |
##        @fixme-ip-core @issue-ip-core-todo
##        Examples:
##            | status | field | value!               | data                         |
##            | 201    | type  | 'MAIL'               | a "MAIL" type                |
#
## @todo: validation with data in more than one step
