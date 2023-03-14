@legacy-bridge @ip4 @ip5 @soap @tests
Feature: GetListeTypes

    Scenario: Récupération des types
        Given def params = { sousType: "Auto monodoc", username: "ws@legacy-bridge", password: "a123456a123456" }
        When def rv = call read('classpath:lib/ip/api/soap/requests/GetListeTypes/simple.feature') params
        Then match karate.xmlPath(rv.response, 'count(/Envelope/Body/GetListeTypesResponse/TypeTechnique)') == 3
            And match ip.utils.xmlPathSortedUnique(rv.response, '/Envelope/Body/GetListeTypesResponse/TypeTechnique') == ["Auto monodoc","Auto multidoc","PAdES"]
            And match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/GetListeTypesResponse/OK.xml')
