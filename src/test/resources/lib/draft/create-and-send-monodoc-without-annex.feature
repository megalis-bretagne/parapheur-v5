@ignore
Feature:
    Scenario:
        * def result = call read('classpath:lib/draft/create-monodoc-without-annex.feature') __arg

        Given url baseUrl
            And path path + '/' + result.response.id
            And header Accept = 'application/json'
        When method PUT
        Then status 200
