@karate-function @ignore
Feature: Secure mail setup lib

    Scenario: Create a secure mail configuration
        * def tenantId = api_v1.entity.getIdByName(tenant)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/secureMail/server'
            And header Accept = 'application/json'
            And request
"""
{
    name: '#(name)',
    url: '#(url)',
    login: '#(login)',
    password: '#(password)',
    entity: #(entity),
    type: 'mailsec',
    tenantId: '#(tenantId)'
}
"""
        When method POST
        Then status 201
