# @legacy-bridge @ip4 @ip5 @soap @tests @fixme-ip5
Feature: ExercerDroitRemordDossier

    Scenario Outline: Exercice du droit de remord sur un dossier
        # 1. Création d'un dossier
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        When def rv = call read('classpath:lib/ip/api/soap/requests/CreerDossier/simple_success.feature') params
        Then def dossierId = rv.dossierId

        * ip.pause(5)

        # 2. Exercice du droit de remords
        Given def params = { dossierId: "#(dossierId)", username: "ws@legacy-bridge", password: "a123456" }
        When def rv = call read('classpath:lib/ip/api/soap/requests/ExercerDroitRemordDossier/simple.feature') params
        Then match rv.response /Envelope/Body/ExercerDroitRemordDossierResponse/MessageRetour/message == 'Dossier ' + dossierId + ' récupéré.'
            And match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/ExercerDroitRemordDossierResponse/OK.xml')

        Examples:
            | type         | sousType       | nom                   | documentPrincipal                                       | visibilite   | dateLimite |
            | Auto monodoc | visa sans meta | SOAP droit de remords | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            |
