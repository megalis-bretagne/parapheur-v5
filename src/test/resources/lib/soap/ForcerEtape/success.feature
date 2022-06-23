@karate-function @ignore
Feature: SOAP ForcerEtape lib

    Scenario: Création d'un dossier simple
        * configure cookies = null
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization(username, password)

        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:ForcerEtapeRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:DossierID>#(dossierId)</ns0:DossierID>
            <ns0:CodeTransition>#(codeTransition)</ns0:CodeTransition>
            <ns0:AnnotationPublique>Annotation publique</ns0:AnnotationPublique>
            <ns0:AnnotationPrivee>Annotation privée</ns0:AnnotationPrivee>
        </ns0:ForcerEtapeRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'ForcerEtape'
        Then status 200
            And match /Envelope/Body/ForcerEtapeResponse/MessageRetour/codeRetour == 'OK'
            And match /Envelope/Body/ForcerEtapeResponse/MessageRetour/message == ''
            And match /Envelope/Body/ForcerEtapeResponse/MessageRetour/severite == 'INFO'
