@legacy-bridge @ip4 @ip5 @soap @tests
Feature: GetCircuit

    Scenario Outline: Récupération du circuit du sous-types "${type} / ${sousType}"
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "Ilenfautpeupouretreheureux" })
        When def rv = call read('classpath:lib/ip/api/soap/requests/GetCircuit/simple.feature') params
            And match rv.response /Envelope/Body/GetCircuitResponse/EtapeCircuit/Parapheur == Parapheurs
            And match rv.response /Envelope/Body/GetCircuitResponse/EtapeCircuit/Prenom == Prenoms
            And match rv.response /Envelope/Body/GetCircuitResponse/EtapeCircuit/Nom == Noms
            And match rv.response /Envelope/Body/GetCircuitResponse/EtapeCircuit/Role == Roles
            And match karate.xmlPath(rv.response, 'count(/Envelope/Body/GetCircuitResponse/EtapeCircuit)') == count
            And match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/GetCircuitResponse/OK.xml')

        Examples:
            | type         | sousType       | count! | Parapheurs!                 | Prenoms! | Noms!                              | Roles!                  |
            | Auto monodoc | visa sans meta | 2      | ['Vermillon', 'WebService'] | ['', ''] | ['Lukas Vermillon', 'Service Web'] | ['VISEUR', 'ARCHIVAGE'] |
