@ignore
Feature:

    Scenario:
        * def result = call read("classpath:lib/api/draft/create-multidoc-without-annex.feature") __arg
        * __arg["annotations"] = templates.annotations.default(__arg.username, __arg.annotation)

        Given url baseUrl
            And path path + "/" + result.response.id
            And header Accept = "application/json"
            And request { "publicAnnotation": "#(__arg.annotations.public)", "privateAnnotation": "#(__arg.annotations.private)" }
        When method PUT
        Then status 200
