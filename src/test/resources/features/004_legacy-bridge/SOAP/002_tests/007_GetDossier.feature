@legacy-bridge @soap @tests

Feature: GetDossier

  Background:
    * url api.soap.url()
    * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

  Scenario Outline: ...
    Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:RechercherDossiersRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>#(type)</ns0:TypeTechnique>
            <ns0:SousType>#(sousType)</ns0:SousType>
            <ns0:Status>#(status)</ns0:Status>
        </ns0:RechercherDossiersRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
    When soap action 'RechercherDossiers'
    Then status 200
        And def dossierId = karate.xmlPath(response, '(/Envelope/Body/RechercherDossiersResponse/LogDossier/nom)[1]')

    Given header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")
        And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(dossierId)</ns0:GetDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
    When soap action 'GetDossier'
    Then print 'response:\n', response
        And api.soap.schema.match(response, 'classpath:lib/soap/schemas/GetDossierResponse/OK.xml')
        And match /Envelope/Body/GetDossierResponse/DossierID == dossierId

    Examples:
        | type         | sousType       | status  |
        | Auto monodoc | visa avec meta | Archive |
