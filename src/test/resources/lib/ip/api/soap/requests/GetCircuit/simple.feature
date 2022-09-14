@karate-function @ignore
Feature: SOAP GetCircuit lib

    Scenario: GetCircuit
        * def defaults =
"""
{
    sousType: null,
    type: null,
    username: null,
    password: null
}
"""
        * def args = karate.merge(defaults, __arg)

        Given configure cookies = null
            And url ip.api.soap.url()
            And header Authorization = ip.api.soap.user.authorization(args.username, args.password)
            And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetCircuitRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>#(args.type)</ns0:TypeTechnique>
            <ns0:SousType>#(args.sousType)</ns0:SousType>
        </ns0:GetCircuitRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetCircuit'
        Then status 200
