@legacy-bridge @ip4 @ip5 @soap @tests
Feature: EffacerDossierRejete

    Scenario Outline: Purge d'un dossier rejeté
        # 1. Création d'un dossier
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456a123456" })
        When def rv = call read('classpath:lib/ip/api/soap/requests/CreerDossier/simple_success.feature') params
        Then def dossierId = rv.dossierId

        * ip.pause(5)

        # 2. Forçage de l'étape
        Given def params =
"""
{
    username: "lvermillon@legacy-bridge",
    password: "a123456a123456",
    dossierId: "#(dossierId)",
    codeTransition: "KO"
}
"""
        Then call read('classpath:lib/ip/api/soap/requests/ForcerEtape/success.feature') params

        * ip.pause(5)

        # 3. Effacement du dossier rejeté
        Given def params = { dossierId: "#(dossierId)", username: "ws@legacy-bridge", password: "a123456a123456" }
        When def rv = call read('classpath:lib/ip/api/soap/requests/EffacerDossierRejete/simple.feature') params
        Then match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/EffacerDossierRejeteResponse/OK.xml')

        Examples:
            | type         | sousType       | nom          | documentPrincipal                                       | visibilite   | dateLimite |
            | Auto monodoc | visa sans meta | SOAP effacer | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            |
