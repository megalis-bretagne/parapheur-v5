@karate-function @ignore
Feature: SOAP GetListeMetaDonnees lib

    Scenario: GetListeMetaDonnees
        * def defaults =
"""
{
    username: null,
    password: null
}
"""
        * def args = karate.merge(defaults, __arg)

        Given configure cookies = null
            And url api.soap.url()
            And header Authorization = api.soap.user.authorization(args.username, args.password)
            And request
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
