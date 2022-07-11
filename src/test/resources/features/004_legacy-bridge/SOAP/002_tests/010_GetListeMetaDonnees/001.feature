@legacy-bridge @soap @tests
Feature: GetListeMetaDonnees

    Scenario: Récupération des types
        Given def params = { username: "ws@legacy-bridge", password: "a123456" }
        When def rv = call read('classpath:lib/soap/requests/GetListeMetaDonnees/simple.feature') params
            And match karate.xmlPath(rv.response, 'count(/Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee)') == 1
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nomCourt == 'mameta_bool'
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nomLong == 'Ma métadonnée booléenne'
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nature == 'BOOLEAN'
