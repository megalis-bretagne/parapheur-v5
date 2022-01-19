@ip-core @api-v1
Feature: My feature

#    Background:
#        * api_v1.auth.login('user', 'password')
#
##        * def id = { tenant: {} }
##        * id.tenant.existing = api_v1.entity.getIdByName('Default tenant')
##        * id.tenant.non_existing = api_v1.entity.getNonExistingId()
#        * def tenantId = function(exists, name = 'Default tenant') { return exists == true ? api_v1.entity.getIdByName(name) : api_v1.entity.getNonExistingId() }
#
##    Scenario Outline: WIP - ${title.role(role)} ${title.status(status)} associate an existing desk to an existing user in an existing tenant
#    Scenario Outline: ... ${title.role(role)} ... ${title.existing(tenant)} tenant
##        * print '/api/v1/admin/tenant/', id.tenant[<tenant> ? 'existing' : 'non_existing'] ,'/desk'
#
##        * def tenant = <tenant> == true ? api_v1.entity.getIdByName('Default tenant') : api_v1.entity.getNonExistingId()
##        * print '/api/v1/admin/tenant/', tenant ,'/desk'
#
#        * print '/api/v1/admin/tenant/' + tenantId(tenant)  + '/desk'
#
#        * print <tenant>
#        * match <status> == '#number'
#
##        Examples:
##            | role             | username | password | status | tenant!            |
##            | FUNCTIONAL_ADMIN | ablanc   | a123456  | 403    | id.tenant.existing |
#        Examples:
#            | role             | username | password | status | tenant! |
#            | ADMIN            | ablanc   | a123456  | 403    | true    |
#            | FUNCTIONAL_ADMIN | ablanc   | a123456  | 403    | false   |

#    Background:
#        * api_v1.auth.login('user', 'password')
#        * def tenantId = function(exists, name = 'Default tenant') { return exists == true ? api_v1.entity.getIdByName(name) : api_v1.entity.getNonExistingId() }
#
#    Scenario Outline: ... ${title.role(role)} ${scenario.title.status(status)} associate ${title.existing(desk_exists)} desk to ${title.existing(user_exists)} user in ${title.existing(tenant_exists)} tenant
#        * print '/api/v1/admin/tenant/' + tenantId(tenant_exists)  + '/desk'
#        * match <status> == '#number'
#
##        Examples:
##            | role  | username | password | status | tenant_exists! | desk_exists! | user_exists! |
##            | ADMIN | cnoir    | a123456  | 200    | true           | true         | true         |
##            | ADMIN | cnoir    | a123456  | 404    | false          | true         | true         |
##            | ADMIN | cnoir    | a123456  | 404    | true           | false        | true         |
##            | ADMIN | cnoir    | a123456  | 404    | true           | true         | false        |
##            | ADMIN | cnoir    | a123456  | 404    | false          | false        | true         |
##            | ADMIN | cnoir    | a123456  | 404    | false          | true         | false        |
##            | ADMIN | cnoir    | a123456  | 404    | true           | false        | false        |
##            | ADMIN | cnoir    | a123456  | 404    | false          | false        | false        |
#        Examples:
#            | role  | username | password | status | tenant_exists! | desk_exists! | user_exists! |
#            | ADMIN | cnoir    | a123456  | 200    | true           | true         | true         |
#            | ADMIN | cnoir    | a123456  | 404    | false          | true         | true         |
#            | ADMIN | cnoir    | a123456  | 404    | true           | false        | true         |
#            | ADMIN | cnoir    | a123456  | 404    | false          | false        | true         |
#            | ADMIN | cnoir    | a123456  | 404    | true           | true         | false        |
#            | ADMIN | cnoir    | a123456  | 404    | false          | true         | false        |
#            | ADMIN | cnoir    | a123456  | 404    | true           | false        | false        |
#            | ADMIN | cnoir    | a123456  | 404    | false          | false        | false        |

    Background:
        * api_v1.auth.login('user', 'password')
        * def tenantId = function(exists, name = 'Default tenant') { return exists == true ? api_v1.entity.getIdByName(name) : api_v1.entity.getNonExistingId() }
        * def userId = function(exists, name = 'ltransparent@dom.local', tenant = 'Default tenant') { return exists == true ? api_v1.user.getIdByEmail(tenantId(tenant), name) : api_v1.user.getNonExistingId() }
        #* @todo: deskId

    @x-wip
    Scenario Outline: ... ${title.role(role)} ${scenario.title.status(status)} associate ${title.existing(desk_exists)} desk to ${title.existing(user_exists)} user in ${title.existing(tenant_exists)} tenant
        * print '/api/v1/admin/tenant/' + tenantId(tenant_exists)  + '/desk'
#        * print '/api/v1/admin/tenant/' + tenantId(tenant_exists)  + '/desk/', + deskId(tenant_exists)  +, '/users'
#        * print userId(user_exists)
        * print { "userIdList": [ userId(user_exists) ] }

        Examples:
            | role             | username     | password | status | tenant_exists! | desk_exists! | user_exists! |
#            | ADMIN            | cnoir        | a123456  | 200    | true           | true         | true         |
#            | ADMIN            | cnoir        | a123456  | 404    | false          | true         | true         |
#            | ADMIN            | cnoir        | a123456  | 404    | true           | false        | true         |
#            | ADMIN            | cnoir        | a123456  | 404    | false          | false        | true         |
#            | ADMIN            | cnoir        | a123456  | 404    | true           | true         | false        |
#            | ADMIN            | cnoir        | a123456  | 404    | false          | true         | false        |
#            | ADMIN            | cnoir        | a123456  | 404    | true           | false        | false        |
#            | ADMIN            | cnoir        | a123456  | 404    | false          | false        | false        |
#            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    | true           | true         | true         |
#            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    | false          | true         | true         |
#            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    | true           | false        | true         |
#            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    | false          | false        | true         |
#            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    | true           | true         | false        |
#            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    | false          | true         | false        |
#            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    | true           | false        | false        |
#            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    | false          | false        | false        |
#            | NONE             | ltransparent | a123456  | 403    | true           | true         | true         |
#            | NONE             | ltransparent | a123456  | 403    | false          | true         | true         |
#            | NONE             | ltransparent | a123456  | 403    | true           | false        | true         |
#            | NONE             | ltransparent | a123456  | 403    | false          | false        | true         |
#            | NONE             | ltransparent | a123456  | 403    | true           | true         | false        |
#            | NONE             | ltransparent | a123456  | 403    | false          | true         | false        |
#            | NONE             | ltransparent | a123456  | 403    | true           | false        | false        |
#            | NONE             | ltransparent | a123456  | 403    | false          | false        | false        |
#            |                  |              |          | 401    | true           | true         | true         |
#            |                  |              |          | 401    | false          | true         | true         |
#            |                  |              |          | 401    | true           | false        | true         |
#            |                  |              |          | 401    | false          | false        | true         |
#            |                  |              |          | 401    | true           | true         | false        |
#            |                  |              |          | 401    | false          | true         | false        |
            |                  |              |          | 401    | true           | false        | false        |
            |                  |              |          | 401    | false          | false        | false        |
