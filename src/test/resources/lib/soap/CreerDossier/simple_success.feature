@karate-function @ignore
Feature: SOAP CreerDossier lib

    Scenario: Création d'un dossier simple
        * configure cookies = null
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization(username, password)

        * def dossierId = typeof dossierId !== 'undefined' ? dossierId : ''
        * def documentPrincipal = api.soap.file.encode(documentPrincipal)
        * def annotationPublique = typeof annotationPublique !== 'undefined' ? annotationPublique : "Annotation publique (" + nom + ")"
        * def annotationPrivee = typeof annotationPrivee !== 'undefined' ? annotationPrivee : "Annotation privée (" + nom + ")"

        * def payload =
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:CreerDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>#(type)</ns0:TypeTechnique>
            <ns0:SousType>#(sousType)</ns0:SousType>
            <ns0:DossierID>#(dossierId)</ns0:DossierID>
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
        Given request payload
        When soap action 'CreerDossier'
        Then status 200
            And match /Envelope/Body/CreerDossierResponse/MessageRetour/message == "Dossier " + nom + " soumis dans le circuit"
            And match /Envelope/Body/CreerDossierResponse/DossierID == (dossierId == '' ? '#uuid' : '#notpresent')
            And def dossierId = (dossierId == '' ? karate.xmlPath(response, '/Envelope/Body/CreerDossierResponse/DossierID') : dossierId)
