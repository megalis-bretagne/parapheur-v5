@karate-function
Feature: User lib

    Scenario: Create temporary user
        * def requestData =
"""
    {
        userName : '#(userName)',
        email: '#(email)',
        firstName: '#(firstName)',
        lastName: '#(lastName)',
        password: '#(password)',
        privilege: '#(privilege)',
        notificationsCronFrequency: '#(notificationsCronFrequency)',
        notificationsRedirectionMail: '#(notificationsRedirectionMail)'
    }
"""

        Given url baseUrl
            And path '/api/admin/tenant/', tenantId, '/user'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status 201
