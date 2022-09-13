@karate-function @ignore
Feature: common lib

    Scenario: get
        * url baseUrl
        * path __arg.url
        * method GET
        * status 200
        * copy bytes = responseBytes
