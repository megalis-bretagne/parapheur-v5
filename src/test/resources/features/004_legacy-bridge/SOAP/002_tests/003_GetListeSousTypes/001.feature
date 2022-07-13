@legacy-bridge @soap @tests
Feature: GetListeSousTypes - Interrogation des sous-types disponibles

    Scenario: Récupération des sous-types du type "Auto monodoc"
        Given def params = { sousType: "Auto monodoc", username: "ws@legacy-bridge", password: "a123456" }
        When def rv = call read('classpath:lib/soap/requests/GetListeSousTypes/simple.feature') params
        Then match karate.xmlPath(rv.response, 'count(/Envelope/Body/GetListeSousTypesResponse/SousType)') == 4
            And match utils.xmlPathSortedUnique(rv.response, '/Envelope/Body/GetListeSousTypesResponse/SousType') == ["sign avec meta","sign sans meta","visa avec meta","visa sans meta"]
            And match rv.response == karate.read('classpath:lib/soap/schemas/GetListeSousTypesResponse/OK.xml')
