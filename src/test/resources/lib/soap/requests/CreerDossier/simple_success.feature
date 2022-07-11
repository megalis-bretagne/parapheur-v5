@karate-function @ignore
Feature: SOAP CreerDossier lib

    Scenario: Création d'un dossier simple avec succès
        * call read('classpath:lib/soap/requests/CreerDossier/simple.feature') __arg
            And match /Envelope/Body/CreerDossierResponse/MessageRetour/message == "Dossier " + nom + " soumis dans le circuit"
            And match /Envelope/Body/CreerDossierResponse/DossierID == (dossierId == '' ? '#uuid' : '#notpresent')
            And def dossierId = (dossierId == '' ? karate.xmlPath(response, '/Envelope/Body/CreerDossierResponse/DossierID') : dossierId)
            And match response == karate.read('classpath:lib/soap/schemas/CreerDossierResponse/OK.xml')
