@ignore
Feature:
    Scenario:
        * def result = call read('classpath:lib/ip5/api/draft/create-monodoc-with-annex.feature') __arg

        * def publicAnnotation = templates.annotations.getPublic(username, "démarrage", __arg.draftFolderParams.name)
        * def privateAnnotation = templates.annotations.getPrivate(username, "démarrage", __arg.draftFolderParams.name)

        Given url baseUrl
            And path path + "/" + result.response.id
            And header Accept = "application/json"
            And request { "publicAnnotation": "#(publicAnnotation)", "privateAnnotation": "#(privateAnnotation)" }
        When method PUT
        Then status 200
