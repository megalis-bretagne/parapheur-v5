@legacy-bridge @soap @tests

Feature: EffacerDossierRejete - Purge de dossier rejeté

    Scenario Outline: Purge d'un dossier rejeté
        # 1. Création d'un dossier
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        When def rv = call read('classpath:lib/soap/requests/CreerDossier/simple_success.feature') params
        Then def dossierId = rv.dossierId

        * pause(5)

        # 2. Forçage de l'étape
        Given def params =
"""
{
    username: "lvermillon@legacy-bridge",
    password: "a123456",
    dossierId: "#(dossierId)",
    codeTransition: "KO"
}
"""
        Then call read('classpath:lib/soap/requests/ForcerEtape/success.feature') params

        * pause(5)

        # 3. Effacement du dossier rejeté
        Given def params = { dossierId: "#(dossierId)", username: "ws@legacy-bridge", password: "a123456" }
        When def rv = call read('classpath:lib/soap/requests/EffacerDossierRejete/simple.feature') params
        Then match rv.response == karate.read('classpath:lib/soap/schemas/EffacerDossierRejeteResponse/OK.xml')

        Examples:
            | type         | sousType       | nom          | documentPrincipal                                       | visibilite   | dateLimite |
            | Auto monodoc | visa sans meta | SOAP effacer | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            |
