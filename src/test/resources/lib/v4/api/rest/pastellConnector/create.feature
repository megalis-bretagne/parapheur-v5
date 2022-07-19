@karate-function @ignore
Feature: IP v.4 REST pastell-connector lib

    Scenario: Create pastell-connector
        * def payload =
"""
{
  "isNew": true,
  "title": "#(__arg.title)",
  "editing": true,
  "connected": true,
  "type": "mailsec",
  "url": "#(__arg.url)",
  "login": "#(__arg.login)",
  "password": "#(__arg.password)",
  "entity": #(__arg.entity)
}
"""
        Given url baseUrl
            And path "/iparapheur/proxy/pastell-connector/api/server"
            And header Accept = "application/json"
            And request payload

        When method POST
        Then status 201
            And match response contains { id: "#number" }

      * def serverId = response.id

      Given url baseUrl
          And path "/iparapheur/proxy/alfresco/parapheur/pastell/mailsec"
          And header Accept = "application/json"
          And request { serverId: #(serverId), title: "#(__arg.title)" }
      When method POST
      Then status 200
          And match response == { id: "#uuid", serverId: "#string", title: "#string" }
