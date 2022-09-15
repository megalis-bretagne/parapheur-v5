@karate-function @ignore
Feature: IP v.5 REST draft lib

    Scenario: Send draft folder
        * def publicAnnotation = ip.templates.annotations.getPublic(__arg.username, "démarrage", __arg.name)
        * def privateAnnotation = ip.templates.annotations.getPrivate(__arg.username, "démarrage", __arg.name)

        Given url baseUrl
            And path __arg.path + "/" + __arg.draft.id
            And header Accept = "application/json"
            And request { "publicAnnotation": "#(publicAnnotation)", "privateAnnotation": "#(privateAnnotation)" }
        When method PUT
        Then status 200
