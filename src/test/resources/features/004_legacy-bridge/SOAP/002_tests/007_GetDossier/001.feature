@legacy-bridge @soap @tests

Feature: GetDossier

    Scenario Outline: Récupération du dossier en fin de circuit (type "${type}", sous-type "${sousType}", status "${status}")
          # Récupération de la liste des dossier
          Given def params = karate.merge(__row, { schema: "OK.xml", username: "ws@legacy-bridge", password: "a123456" })
          When def rv = call read('classpath:lib/soap/requests/RechercherDossiers/simple.feature') params
          Then def dossierId = karate.xmlPath(rv.response, '(/Envelope/Body/RechercherDossiersResponse/LogDossier/nom)[1]')

          # Récupération d'un dossier particulier
          Given def params = karate.merge(__row, { dossierId: dossierId, username: "ws@legacy-bridge", password: "a123456" })
          When def rv = call read('classpath:lib/soap/requests/GetDossier/simple.feature') params
              And match rv.response /Envelope/Body/GetDossierResponse/DossierID == dossierId

    Examples:
        | type         | sousType       | status  |
        | Auto monodoc | visa avec meta | Archive |
