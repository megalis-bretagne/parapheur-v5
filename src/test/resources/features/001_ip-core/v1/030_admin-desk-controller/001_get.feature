@ip-core @api-v1
Feature: GET /api/admin/tenant/{tenantId}/desk (List desks)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role can get the list from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status 200
            And match $ == schemas.desk.index
            And match $.total == 2
            And match $.data[*].name == [ 'Translucide', 'Transparent' ]

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "ADMIN" role cannot get the list from a non-existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status 404

    # @todo @permissions @fixme-karate-functional-admin-should-have-rights-?
    # Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot get the list from an existing tenant
    # Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot get the list from a non-existing tenant
    # Scenario: Permissions - a user with a "NONE" role cannot get the list from an existing tenant
    # Scenario: Permissions - a user with a "NONE" role cannot get the list from a non-existing tenant
    # Scenario: Permissions - an unauthenticated user cannot get the list from an existing tenant
    # Scenario: Permissions - an unauthenticated user cannot get the list from a non-existing tenant

    @searching @todo-karate-better-test-for-sorting
    Scenario: Searching - a user with an "ADMIN" role can filter and sort the list based on the username
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And param asc = false
            And param sortBy = 'NAME'
            And param searchTerm = 'lucide'
        When method GET
        Then status 200
            And match $ == schemas.desk.index
            And match $.total == 1
            And match $.data[*].userName == [ 'Translucide' ]
