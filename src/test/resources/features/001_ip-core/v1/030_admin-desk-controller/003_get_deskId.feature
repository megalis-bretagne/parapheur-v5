@ip-core @api-v1
Feature: GET /api/admin/tenant/{tenantId}/desk/{deskId} (getDeskInfo)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role can get an existing desk from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
        When method GET
        Then status 200
            And match $ == schemas.desk.element
            And match $ contains { 'name': 'Transparent' }

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "ADMIN" role cannot get a non-existing desk from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
        When method GET
        Then status 404

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "ADMIN" role cannot get a desk from an non-existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
        When method GET
        Then status 404

    # @todo @permissions @fixme-karate-functional-admin-should-have-rights-?
    # Scenario: Permissions - a user with an "FUNCTIONAL_ADMIN" role cannot get an existing desk from an existing tenant
    # Scenario: Permissions - a user with an "FUNCTIONAL_ADMIN" role cannot get a non-existing desk from an existing tenant
    # Scenario: Permissions - a user with an "FUNCTIONAL_ADMIN" role cannot get a desk from an non-existing tenant
    # Scenario: Permissions - a user with an "NONE" role cannot get an existing desk from an existing tenant
    # Scenario: Permissions - a user with an "NONE" role cannot get a non-existing desk from an existing tenant
    # Scenario: Permissions - a user with an "NONE" role cannot get a desk from an non-existing tenant
    # Scenario: Permissions - an unauthenticated user cannot get an existing desk from an existing tenant
    # Scenario: Permissions - an unauthenticated user cannot get a non-existing desk from an existing tenant
    # Scenario: Permissions - an unauthenticated user cannot get a desk from an non-existing tenant
