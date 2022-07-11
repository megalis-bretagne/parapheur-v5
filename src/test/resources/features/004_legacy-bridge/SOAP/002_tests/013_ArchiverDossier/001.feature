@legacy-bridge @soap @tests

Feature: ArchiverDossier

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario Outline: Purge d'un dossier (${archivageAction})
        # 1. Création d'un dossier
        * def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        * def rv = call read('classpath:lib/soap/requests/CreerDossier/simple_success.feature') params
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
        * call read('classpath:lib/soap/ForcerEtape/success.feature') params

        * pause(5)

        # 3. Archivage du dossier
        Given configure cookies = null
            And header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")
            And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:ArchiverDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:DossierID>#(dossierId)</ns0:DossierID>
            <ns0:ArchivageAction>#(archivageAction)</ns0:ArchivageAction>
        </ns0:ArchiverDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'ArchiverDossier'
        * def cleanedResponse = response
        * remove cleanedResponse /Envelope/Body/ArchiverDossierResponse/URL/@xsi
        Then status 200
            And match /Envelope/Body/ArchiverDossierResponse/MessageRetour/codeRetour == 'OK'
            And match /Envelope/Body/ArchiverDossierResponse/MessageRetour/message == (archivageAction == 'ARCHIVER' ? 'Dossier ' + dossierId + ' archivé.' : 'Dossier ' + dossierId + ' supprimé du Parapheur.')
            And match /Envelope/Body/ArchiverDossierResponse/MessageRetour/severite == 'INFO'
            And match cleanedResponse == karate.read('classpath:lib/soap/schemas/ArchiverDossierResponse/OK.xml')

        Examples:
            | type         | sousType       | nom                       | documentPrincipal                                       | visibilite   | dateLimite | archivageAction |
            | Auto monodoc | visa sans meta | SOAP archivage (ARCHIVER) | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | ARCHIVER        |
            | Auto monodoc | visa sans meta | SOAP archivage (EFFACER)  | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | EFFACER         |
