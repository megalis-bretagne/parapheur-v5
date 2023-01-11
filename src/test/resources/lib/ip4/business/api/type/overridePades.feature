@karate-function @ignore
Feature: IP v.4 REST type lib

    Scenario: Update type
        * def payload =
"""
{
  "active": "true",
  "stampPage": "1",
  "stampCoordX": "0",
  "stampCoordY": "0",
  "stampHeight": "100",
  "showStamp": "true",
  "stampWidth": "100",
  "stampFontSize": "6",
  "dateLimite": "",
  "password": "12345678",
  "baseUrlArchivage": "http://localhost:9090/parapheur/",
  "userlogin": "",
  "isPwdGoodForPkcs": "ex",
  "server": "s2low.formations.libriciel.fr",
  "userpassword": "",
  "port": "443"
}
"""
        * if (__arg.stamp.hasOwnProperty('page') && __arg.stamp.page !== null) payload["stampPage"] = __arg.stamp.page
        * if (__arg.stamp.hasOwnProperty('x') && __arg.stamp.x !== null) payload["stampCoordX"] = __arg.stamp.x
        * if (__arg.stamp.hasOwnProperty('y') && __arg.stamp.y !== null) payload["stampCoordY"] = __arg.stamp.y

        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/types/" + encodeURI(__arg.id) + "/overridePades"
            And header Accept = "application/json"
            And request payload

        When method PUT
        Then status 200
