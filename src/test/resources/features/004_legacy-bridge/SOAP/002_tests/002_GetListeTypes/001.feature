@legacy-bridge @soap @tests
Feature: GetListeTypes

    Scenario: Récupération des types
        Given def params = { sousType: "Auto monodoc", username: "ws@legacy-bridge", password: "a123456" }
        When def rv = call read('classpath:lib/soap/requests/GetListeTypes/simple.feature') params
        Then match karate.xmlPath(rv.response, 'count(/Envelope/Body/GetListeTypesResponse/TypeTechnique)') == 3
            And match utils.xmlPathSortedUnique(rv.response, '/Envelope/Body/GetListeTypesResponse/TypeTechnique') == ["Auto monodoc","Auto multidoc","PAdES"]
