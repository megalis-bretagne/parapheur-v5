@legacy-bridge @soap @tests
Feature: echo

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    @fixme-ip-5
    Scenario Outline: echo "${message}"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:echoRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(message)</ns0:echoRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'echo'
        Then status 200
        And api.soap.schema.match(response, 'classpath:lib/soap/schemas/echoResponse/OK.xml')
        And match response /Envelope/Body/echoResponse == "[ws@legacy-bridge] m'a dit: \"" + message + "\"!"

        Examples:
            | message                                                                                                                  |
            | coucou ! ici karate !                                                                                                    |
            | Dès Noël, où un zéphyr haï me vêt de glaçons würmiens, je dîne d’exquis rôtis de bœuf au kir, à l’aÿ d’âge mûr, &cætera. |
