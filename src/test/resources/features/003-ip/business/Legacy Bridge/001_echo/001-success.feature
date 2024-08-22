@legacy-bridge @ip4 @ip5 @soap @tests
Feature: echo

    Scenario Outline: echo "${message}"
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "Ilenfautpeupouretreheureux" })
        When def rv = call read('classpath:lib/ip/api/soap/requests/echo/simple.feature') params
        Then match rv.response /Envelope/Body/echoResponse == "[ws@legacy-bridge] m'a dit: \"" + ( message == null ? '' : message ) + "\"!"
            And match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/echoResponse/OK.xml')

        Examples:
            | message                                                                                                                  |
            |                                                                                                                          |
            | coucou ! ici karate !                                                                                                    |
            | Dès Noël, où un zéphyr haï me vêt de glaçons würmiens, je dîne d’exquis rôtis de bœuf au kir, à l’aÿ d’âge mûr, &cætera. |
