@karate-function @ignore
Feature: SOAP GetListeSousTypes lib

    Scenario: GetListeSousTypes
        * def defaults =
"""
{
    sousType: null,
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
        <ns0:GetListeSousTypesRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(args.sousType)</ns0:GetListeSousTypesRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetListeSousTypes'
        Then status 200
