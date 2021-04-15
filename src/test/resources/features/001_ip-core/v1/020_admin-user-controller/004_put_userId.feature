@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId}/user/{userId} (Update user)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingUserId = api_v1.user.createTemporary(existingTenantId)
        * def nonExistingUserId = api_v1.user.getNonExistingId()
        * def userData = api_v1.user.getById(existingTenantId, existingUserId)

    @permissions @proposal
    Scenario: Permissions - a user with an "ADMIN" role can edit an existing user from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 200

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role cannot edit an existing user from a non-existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 404


    @permissions
    Scenario: Permissions - a user with an "ADMIN" role cannot edit a non-existing user from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 404

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot edit an existing user from an existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot edit an existing user from a non-existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 403


    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot edit a non-existing user from an existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "NONE" role cannot edit an existing user from an existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "NONE" role cannot edit an existing user from a non-existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 403


    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "NONE" role cannot edit a non-existing user from an existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot edit an existing user from an existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 401

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot edit an existing user from a non-existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 401


    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot edit a non-existing user from an existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
            And request userData
        When method PUT
        Then status 401

    @data-validation @proposal
    Scenario: Data validation - a user with an "ADMIN" role cannot edit a user with empty values
    * api_v1.auth.login('cnoir', 'a123456')

    Given url baseUrl
        And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
        And header Accept = 'application/json'
        And request
"""
{
    userName : '',
    email: '',
    firstName: '',
    lastName: '',
    password: '',
    privilege: '',
    notificationsCronFrequency: '',
    notificationsRedirectionMail: ''
}
"""
    When method PUT
    Then status 400

    @data-validation @fixme-ip-core @proposal
    Scenario: Data validation - a user with an "ADMIN" role cannot edit a user with already existing userName or email values
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
            And request
"""
{
    userName : 'cnoir',
    email: 'cnoir@dom.local',
    firstName: 'Christian',
    lastName: 'Noir',
    password: 'a123456',
    privilege: 'NONE',
    notificationsCronFrequency: '',
    notificationsRedirectionMail: 'cnoir@dom.local'
}
"""
        When method PUT
        Then status 409
