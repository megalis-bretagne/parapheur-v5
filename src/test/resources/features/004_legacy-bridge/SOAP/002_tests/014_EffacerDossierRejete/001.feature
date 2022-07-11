@legacy-bridge @soap @tests

Feature: EffacerDossierRejete

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario Outline: Purge d'un dossier rejeté
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
    codeTransition: "KO"
}
"""
        * call read('classpath:lib/soap/ForcerEtape/success.feature') params

        * pause(5)

        # 3. Effacement du dossier rejeté
        Given configure cookies = null
            And header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")
            And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:EffacerDossierRejeteRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(dossierId)</ns0:EffacerDossierRejeteRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'EffacerDossierRejete'
        Then status 200
            And match /Envelope/Body/EffacerDossierRejeteResponse/MessageRetour/codeRetour == 'OK'
            And match /Envelope/Body/EffacerDossierRejeteResponse/MessageRetour/message == 'Dossier ' + dossierId + ' supprimé du Parapheur.'
            And match /Envelope/Body/EffacerDossierRejeteResponse/MessageRetour/severite == 'INFO'
            And match response == karate.read('classpath:lib/soap/schemas/EffacerDossierRejeteResponse/OK.xml')

        Examples:
            | type         | sousType       | nom          | documentPrincipal                                       | visibilite   | dateLimite |
            | Auto monodoc | visa sans meta | SOAP effacer | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            |
