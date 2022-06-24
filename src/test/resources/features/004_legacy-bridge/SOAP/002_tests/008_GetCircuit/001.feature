@legacy-bridge @soap @tests
Feature: GetCircuit

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")
    @fixme-ip5
    Scenario Outline: Récupération du circuit du sous-types "${type} / ${sousType}"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetCircuitRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>#(type)</ns0:TypeTechnique>
            <ns0:SousType>#(sousType)</ns0:SousType>
        </ns0:GetCircuitRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetCircuit'
        Then status 200
            And match /Envelope/Body/GetCircuitResponse/EtapeCircuit/Parapheur == Parapheurs
            And match /Envelope/Body/GetCircuitResponse/EtapeCircuit/Prenom == Prenoms
            And match /Envelope/Body/GetCircuitResponse/EtapeCircuit/Nom == Noms
            And match /Envelope/Body/GetCircuitResponse/EtapeCircuit/Role == Roles
            And match karate.xmlPath(response, 'count(/Envelope/Body/GetCircuitResponse/EtapeCircuit)') == count

        Examples:
            | type         | sousType       | count! | Parapheurs!                 | Prenoms! | Noms!                              | Roles!                  |
            | Auto monodoc | visa sans meta | 2      | ['Vermillon', 'WebService'] | ['', ''] | ['Lukas Vermillon', 'Service Web'] | ['VISEUR', 'ARCHIVAGE'] |
