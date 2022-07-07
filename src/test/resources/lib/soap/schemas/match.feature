@karate-function @ignore @deprecated
Feature: soap schema helper lib

    Scenario: match XML converted to JSON
        * json jsonResponse = __arg.response
        * json jsonSchema = karate.read(__arg.schema)
        * match jsonResponse == jsonSchema
