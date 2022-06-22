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
            And api.soap.schema.match(response, 'classpath:lib/soap/schemas/GetListeTypesResponse/OK.xml')
            And match /Envelope/Body/GetListeTypesResponse/TypeTechnique == ['Auto monodoc', 'Auto multidoc']
