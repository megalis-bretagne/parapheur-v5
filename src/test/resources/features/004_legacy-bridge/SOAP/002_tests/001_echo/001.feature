@legacy-bridge @soap @tests
Feature: echo

    Scenario Outline: echo "${message}"
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        When def rv = call read('classpath:lib/soap/requests/echo/simple.feature') params
        Then match rv.response /Envelope/Body/echoResponse == "[ws@legacy-bridge] m'a dit: \"" + ( message == null ? '' : message ) + "\"!"

        Examples:
            | message                                                                                                                  |
            |                                                                                                                          |
            | coucou ! ici karate !                                                                                                    |
            | Dès Noël, où un zéphyr haï me vêt de glaçons würmiens, je dîne d’exquis rôtis de bœuf au kir, à l’aÿ d’âge mûr, &cætera. |
