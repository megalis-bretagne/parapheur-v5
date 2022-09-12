@legacy-bridge @soap @tests
Feature: GetListeMetaDonnees - Interrogation des méta-données disponibles
    @fixme-ip
    Scenario: Récupération des méta-données
        Given def params = { username: "ws@legacy-bridge", password: "a123456" }
        When def rv = call read('classpath:lib/soap/requests/GetListeMetaDonnees/simple.feature') params
            And match karate.xmlPath(rv.response, 'count(/Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee)') == 1
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nomCourt == 'mameta_bool'
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nomLong == 'Ma métadonnée booléenne'
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nature == 'BOOLEAN'
            And match rv.response == karate.read('classpath:lib/soap/schemas/GetListeMetaDonneesResponse/OK.xml')
