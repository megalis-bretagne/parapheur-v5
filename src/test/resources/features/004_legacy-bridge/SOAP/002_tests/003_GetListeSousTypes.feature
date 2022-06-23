@legacy-bridge @soap @tests
Feature: GetListeSousTypes

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario: Récupération des sous-types du type "Auto monodoc"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetListeSousTypesRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">Auto monodoc</ns0:GetListeSousTypesRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetListeSousTypes'
        Then status 200
            And match karate.xmlPath(response, 'count(/Envelope/Body/GetListeSousTypesResponse/SousType)') == 4
            And match /Envelope/Body/GetListeSousTypesResponse/SousType contains 'sign avec meta'
            And match /Envelope/Body/GetListeSousTypesResponse/SousType contains 'sign sans meta'
            And match /Envelope/Body/GetListeSousTypesResponse/SousType contains 'visa avec meta'
            And match /Envelope/Body/GetListeSousTypesResponse/SousType contains 'visa sans meta'
