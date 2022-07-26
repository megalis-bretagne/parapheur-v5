@karate-function @ignore
Feature: IP v.4 REST metadata lib

    Scenario: Create metadata
        * def defaults =
"""
{
    "isNew":false,
    "oldValues":[],
    "values":[],
    "hasValues":false,
    "deletable":true,
    "isAlphaOrdered":true
}
"""
        * def args = karate.merge(defaults, __arg)
        * args["hasValues"] = args.values.length > 0

        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/metadonnees/" + encodeURI(args.id)
            And header Accept = "application/json"
            And request args
        * karate.log(args)
        When method POST
        Then status 200
            And match response == ""
