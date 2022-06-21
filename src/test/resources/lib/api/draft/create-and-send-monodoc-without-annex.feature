@ignore
Feature:
    Scenario:
        * def result = call read('classpath:lib/api/draft/create-monodoc-without-annex.feature') __arg
        * karate.log(result)

        Given url baseUrl
            And path path + '/' + result.response.id
            And header Accept = 'application/json'
            And request { 'metadata': {}, 'privateAnnotation': '', 'publicAnnotation': '' }
        When method PUT
        Then status 200
