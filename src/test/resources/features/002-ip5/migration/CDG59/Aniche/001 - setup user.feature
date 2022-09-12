@ip5 @migration @cdg59 @aniche
Feature: Vérification de l'entité "CDG59/Aniche" et ajout de user à celle-ci entité

    Background:
        * api_v1.auth.login("user", "password")
        * def tenant = "aniche"

    Scenario: Vérification de l'existence de l'entité
        * call read("classpath:lib/v5/business/api/tenant/adminFilterByName.feature") { name: "#(tenant)" }

    Scenario: Association de l'utilisateur "user" à l'entité
        # Récupération des ids
        * api_v1.auth.login("user", "password")
        * def rv = call read("classpath:lib/v5/business/api/tenant/adminFilterByName.feature") { name: "#(tenant)" }
        * def tenantId = rv.response.content[0].id
        * def rv = call read("classpath:lib/api/admin-user/getByUsername.feature") { username: "user" }
        * def userId = rv.response.data[0].id

        # Association de l'utilisateur à l'entité
        Given url baseUrl
            And path "/api/v1/admin/user/" + userId + "/tenant/" + tenantId
            And header Accept = "application/json"
        When method PUT
        Then status 200
            And match response == ""
