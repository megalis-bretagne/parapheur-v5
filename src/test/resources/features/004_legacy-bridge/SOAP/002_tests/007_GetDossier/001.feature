@legacy-bridge @soap @tests @fixme-ip

Feature: GetDossier - Récupération du dossier en fin de circuit

    Scenario Outline: Récupération du dossier en fin de circuit (type "${type}", sous-type "${sousType}", status "${status}")
          # Récupération de la liste des dossier
          Given def params = karate.merge(__row, { schema: "OK.xml", username: "ws@legacy-bridge", password: "a123456" })
          When def rv = call read('classpath:lib/soap/requests/RechercherDossiers/simple.feature') params
          Then def dossierId = karate.xmlPath(rv.response, '(/Envelope/Body/RechercherDossiersResponse/LogDossier/nom)[1]')

          # Récupération d'un dossier particulier
          Given def params = karate.merge(__row, { dossierId: dossierId, username: "ws@legacy-bridge", password: "a123456" })
          When def rv = call read('classpath:lib/soap/requests/GetDossier/simple.feature') params
              And match rv.response /Envelope/Body/GetDossierResponse/DossierID == dossierId

          Given def cleanedResponse = rv.response
          When remove cleanedResponse /Envelope/Body/GetDossierResponse/DateLimite/@nil
              And remove cleanedResponse /Envelope/Body/GetDossierResponse/DateLimite/@xsi
              And remove cleanedResponse /Envelope/Body/GetDossierResponse/DocumentsAnnexes/DocAnnexe/fichier/@contentType
              And remove cleanedResponse //@contentType
          Then match cleanedResponse == karate.read('classpath:lib/soap/schemas/GetDossierResponse/OK.xml')

    Examples:
        | type         | sousType       | status  |
        | Auto monodoc | visa avec meta | Archive |
