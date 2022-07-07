@legacy-bridge @soap @tests
Feature: GetListeMetaDonnees

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario: Récupération des types
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
    <soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetListeMetaDonneesRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0"></ns0:GetListeMetaDonneesRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetListeMetaDonnees'
        Then status 200
            And match karate.xmlPath(response, 'count(/Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee)') == 1
            And match /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nomCourt == 'mameta_bool'
            And match /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nomLong == 'Ma métadonnée booléenne'
            And match /Envelope/Body/GetListeMetaDonneesResponse/MetaDonnee/nature == 'BOOLEAN'
            And match response == karate.read('classpath:lib/soap/schemas/GetListeMetaDonneesResponse/OK.xml')
