@karate-function @ignore
Feature: Tenant user associate setup lib

    Scenario: Associate user with tenant
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
        * def defaultTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def userId = ip5.api.v1.user.getIdByEmail(defaultTenantId, email)

        Given url baseUrl
            And path '/api/provisioning/v1/admin/user/', userId, '/tenant/', tenantId
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
