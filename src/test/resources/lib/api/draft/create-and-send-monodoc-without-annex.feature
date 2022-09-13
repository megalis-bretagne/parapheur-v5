@ignore
Feature:
    Scenario:
        * def result = call read("classpath:lib/api/draft/create-monodoc-without-annex.feature") __arg

        * def publicAnnotation = templates.annotations.getPublic(username, "démarrage", __arg.draftFolderParams.name)
        * def privateAnnotation = templates.annotations.getPrivate(username, "démarrage", __arg.draftFolderParams.name)

        Given url baseUrl
            And path path + "/" + result.response.id
            And header Accept = "application/json"
            And request { "metadata": {}, "publicAnnotation": "#(publicAnnotation)", "privateAnnotation": "#(privateAnnotation)" }
        When method PUT
        Then status 200
