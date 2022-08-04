@ignore
Feature:

    Scenario:
        * def result = call read('classpath:lib/api/draft/create-multidoc-without-annex.feature') __arg

        Given url baseUrl
            And path path + '/' + result.response.id
            And header Accept = 'application/json'
            And request { 'publicAnnotation': '', 'privateAnnotation': '' }
        When method PUT
        Then status 200
