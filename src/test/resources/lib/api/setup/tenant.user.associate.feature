@karate-function @ignore
Feature: Tenant user associate setup lib

    Scenario: Associate user with tenant
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def defaultTenantId = api_v1.entity.getIdByName('Default tenant')
        * def userId = api_v1.user.getIdByEmail(defaultTenantId, email)

        Given url baseUrl
            And path '/api/v1/admin/user/', userId, '/tenant/', tenantId
            And header Accept = 'application/json'
            And request
"""
{
	"headers":{
		"normalizedNames":{},
		"lazyUpdate":null,
		"lazyInit":null,
		"headers":{}
	},
	"params":{
		"updates":null,
		"cloneFrom":null,
		"encoder":{},
		"map":null
	}
}
"""
        When method PUT
        Then status 200
