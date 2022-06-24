@legacy-bridge @soap @tests
Feature: GetListeTypes

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario: Récupération des types
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
    <soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetListeTypesRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0"></ns0:GetListeTypesRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetListeTypes'
        Then status 200
            And match karate.xmlPath(response, 'count(/Envelope/Body/GetListeTypesResponse/TypeTechnique)') == 3
            And match utils.xmlPathSortedUnique(response, '/Envelope/Body/GetListeTypesResponse/TypeTechnique') == ["Auto monodoc","Auto multidoc","PAdES"]
