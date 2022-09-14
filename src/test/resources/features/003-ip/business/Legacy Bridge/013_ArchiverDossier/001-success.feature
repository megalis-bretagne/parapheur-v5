@legacy-bridge @ip4 @ip5 @soap @tests
Feature: ArchiverDossier

    Scenario Outline: Purge d'un dossier (${archivageAction})
        # 1. Création d'un dossier
        * def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        * def rv = call read('classpath:lib/ip/api/soap/requests/CreerDossier/simple_success.feature') params
        * def dossierId = rv.dossierId

        * pause(5)

        # 2. Forçage de l'étape
        * def params =
"""
{
    username: "lvermillon@legacy-bridge",
    password: "a123456",
    dossierId: "#(dossierId)",
    codeTransition: "OK"
}
"""
        * call read('classpath:lib/ip/api/soap/requests/ForcerEtape/success.feature') params

        * pause(5)

        # 3. Archivage du dossier
        Given def params = karate.merge(__row, { archivageAction: "<archivageAction>", dossierId: dossierId, username: "ws@legacy-bridge", password: "a123456" })
        When def rv = call read('classpath:lib/ip/api/soap/requests/ArchiverDossier/simple.feature') params
            And match rv.response /Envelope/Body/ArchiverDossierResponse/MessageRetour/message == (archivageAction == 'ARCHIVER' ? 'Dossier ' + dossierId + ' archivé.' : 'Dossier ' + dossierId + ' supprimé du Parapheur.')
            And match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/ArchiverDossierResponse/OK.xml')

        Examples:
            | type         | sousType       | nom                       | documentPrincipal                                       | visibilite   | dateLimite | archivageAction |
            | Auto monodoc | visa sans meta | SOAP archivage (ARCHIVER) | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | ARCHIVER        |
            | Auto monodoc | visa sans meta | SOAP archivage (EFFACER)  | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | EFFACER         |
