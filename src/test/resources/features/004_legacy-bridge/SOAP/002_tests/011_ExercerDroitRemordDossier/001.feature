@legacy-bridge @soap @tests

Feature: ExercerDroitRemordDossier

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario Outline: ...
        # 1. Création d'un dossier
        * def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        * def rv = call read('classpath:lib/soap/CreerDossier/simple_success.feature') params
        * def dossierId = rv.dossierId

        * pause(5)

        # 2. Exercice du droit de remords
        Given header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")
            And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:ExercerDroitRemordDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(dossierId)</ns0:ExercerDroitRemordDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'ExercerDroitRemordDossier'
        Then status 200
            And match /Envelope/Body/ExercerDroitRemordDossierResponse/MessageRetour/codeRetour == 'OK'
            And match /Envelope/Body/ExercerDroitRemordDossierResponse/MessageRetour/message == 'Dossier ' + dossierId + ' récupéré.'
            And match /Envelope/Body/ExercerDroitRemordDossierResponse/MessageRetour/severite == 'INFO'
            And match response == karate.read('classpath:lib/soap/schemas/ExercerDroitRemordDossierResponse/OK.xml')

        Examples:
            | type         | sousType       | nom                   | documentPrincipal                                       | visibilite   | dateLimite |
            | Auto monodoc | visa sans meta | SOAP droit de remords | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            |
