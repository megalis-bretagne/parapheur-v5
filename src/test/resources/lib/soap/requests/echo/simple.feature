@karate-function @ignore
Feature: SOAP echo lib

    Scenario: echo
        * def defaults =
"""
{
    message: null,
    username: null,
    password: null
}
"""
        * def args = karate.merge(defaults, __arg)

        Given url api.soap.url()
            And header Authorization = api.soap.user.authorization(args.username, args.password)
            And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:echoRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(args.message)</ns0:echoRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'echo'
        Then status 200
            And match response == karate.read('classpath:lib/soap/schemas/echoResponse/OK.xml')
