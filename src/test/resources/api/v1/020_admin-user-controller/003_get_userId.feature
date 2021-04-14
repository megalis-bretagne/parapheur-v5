Feature: GET /api/admin/tenant/{tenantId}/user/{userId} (Get a single user)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'sample-user@example')
        * def nonExistingUserId = api_v1.user.getNonExistingId()

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role can get an existing user from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 200
            And match $ == schemas.user.element
            And match $ contains { 'email': 'sample-user@example' }

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "ADMIN" role cannot get a non-existing user from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 404

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "ADMIN" role cannot get a user from an non-existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 404

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "FUNCTIONAL_ADMIN" role cannot get an existing user from an existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "FUNCTIONAL_ADMIN" role cannot get a non-existing user from an existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "FUNCTIONAL_ADMIN" role cannot get a user from an non-existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "NONE" role cannot get an existing user from an existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "NONE" role cannot get a non-existing user from an existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "NONE" role cannot get a user from an non-existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot get an existing user from an existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 401

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot get a non-existing user from an existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 401

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot get a user from an non-existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method GET
        Then status 401
