@legacy-bridge @soap @tests

Feature: ExercerDroitRemordDossier

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario Outline: ...
        # 1. Création d'un dossier
        * def documentPrincipal = api.soap.file.encode(documentPrincipal)
        * def annotationPublique = "Annotation publique (" + nom + ")"
        * def annotationPrivee = "Annotation privée (" + nom + ")"

      Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:CreerDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>#(type)</ns0:TypeTechnique>
            <ns0:SousType>#(sousType)</ns0:SousType>
            <ns0:DossierID></ns0:DossierID>
            <ns0:DossierTitre>#(nom)</ns0:DossierTitre>
            <ns0:DocumentPrincipal xmlns:ns1="http://www.w3.org/2005/05/xmlmime" ns1:contentType="application/pdf">#(documentPrincipal)</ns0:DocumentPrincipal>
            <ns0:NomDocPrincipal>monDoc.pdf</ns0:NomDocPrincipal>
            <ns0:VisuelPDF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:XPathPourSignatureXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:MetaDataTdtACTES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:AnnotationPublique>#(annotationPublique)</ns0:AnnotationPublique>
            <ns0:AnnotationPrivee>#(annotationPrivee)</ns0:AnnotationPrivee>
            <ns0:Visibilite>#(visibilite)</ns0:Visibilite>
            <ns0:DateLimite>#(dateLimite)</ns0:DateLimite>
        </ns0:CreerDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
      When soap action 'CreerDossier'
      Then status 200
          And match /Envelope/Body/CreerDossierResponse/MessageRetour/message == "Dossier " + nom + " soumis dans le circuit"
          And def dossierId = karate.xmlPath(response, '/Envelope/Body/CreerDossierResponse/DossierID')

        # 2. Exercice du droit de remords
        * pause(5)
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
        Examples:
            | type         | sousType       | nom                   | documentPrincipal                                       | visibilite   | dateLimite |
            | Auto monodoc | visa sans meta | SOAP droit de remords | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            |
