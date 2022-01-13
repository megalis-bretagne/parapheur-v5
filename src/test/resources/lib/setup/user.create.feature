@karate-function @ignore
    Feature: User setup lib

    Scenario: Create user
        * def tenantId = api_v1.entity.getIdByName(tenant)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/user'
            And header Accept = 'application/json'
            And request
"""
{
    userName : '#(userName)',
    email: '#(email)',
    firstName: '#(firstName)',
    lastName: '#(lastName)',
    password: '#(password)',
    privilege: '#(privilege)',
    notificationsCronFrequency: '#(notificationsCronFrequency)'
}
"""
            When method POST
            Then status 201

        * def userId = api_v1.user.getIdByEmail(tenantId, email)

        Given url baseUrl
            And path '/api/v1/admin/user/' + userId
            And header Accept = 'application/json'
            And request
"""
{
    userName : '#(userName)',
    email: '#(email)',
    firstName: '#(firstName)',
    lastName: '#(lastName)',
    password: '#(password)',
    privilege: '#(privilege)',
    notificationsCronFrequency: '#(notificationsCronFrequency)'
}
"""
        When method PUT
        Then status 200
