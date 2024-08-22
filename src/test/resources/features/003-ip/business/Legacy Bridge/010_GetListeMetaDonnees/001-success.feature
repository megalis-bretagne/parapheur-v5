@legacy-bridge @ip4 @ip5 @soap @tests
Feature: GetListeMetaDonnees
    @fixme-ip5
    Scenario: Récupération des méta-données
        Given def params = { username: "ws@legacy-bridge", password: "Ilenfautpeupouretreheureux" }
        When def rv = call read('classpath:lib/ip/api/soap/requests/GetListeMetaDonnees/simple.feature') params
            And match karate.xmlPath(rv.response, 'count(/Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee)') == 1
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nomCourt == 'mameta_bool'
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nomLong == 'Ma métadonnée booléenne'
            And match rv.response /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nature == 'BOOLEAN'
            And match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/GetListeMetaDonneesResponse/OK.xml')
