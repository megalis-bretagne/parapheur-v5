@legacy-bridge @soap
Feature: Appels SOAP sur "Legacy Bridge"

"""
@see  <wsdl:portType name="InterfaceParapheur">
- [ ] ArchiverDossier
- [x] CreerDossier (partiel)
- [ ] CreerDossierPES
- [x] echo (partiel)
- [ ] EnvoyerDossierMailSecurise
- [ ] EffacerDossierRejete
- [ ] EnvoyerDossierPES
- [ ] EnvoyerDossierTdT
- [ ] ExercerDroitRemordDossier
- [ ] ForcerEtape
- [ ] GetCircuit
- [ ] GetCircuitPourUtilisateur
- [ ] GetClassificationActesTdt
- [ ] GetDossier
- [ ] GetHistoDossier
- [ ] GetListeMetaDonnees
- [x] GetListeSousTypes (partiel)
- [ ] GetListeSousTypesPourUtilisateur
- [x] GetListeTypes (partiel)
- [ ] GetListeTypesPourUtilisateur
- [ ] GetMetaDonneesRequisesPourTypeSoustype
- [ ] GetStatutTdT
- [ ] IsUtilisateurExiste
- [x] RechercherDossiers (partiel)
"""

    Background:
        * url baseUrl + "/ws-iparapheur-no-mtom"
        * header Authorization = call read('classpath:lib/basic-auth.js') {username: "ws@legacy-bridge", password: "a123456"}

    Scenario: echo...
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:echoRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">coucou ! ici karate !</ns0:echoRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'echo'
        Then status 200
#            And print 'response: \n', response
            And match response /Envelope/Body/echoResponse == "[ws@legacy-bridge] m'a dit \"coucou ! ici karate !\"!"
            # @fixme: manque le :
            # @fixme: essayer avec plein de caractères accentués
#            And match response /Envelope/Body/echoResponse == "[ws@legacy-bridge] m'a dit: \"coucou ! ici karate !\"!"

    Scenario: Récupération du type "Auto"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetListeTypesRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0"></ns0:GetListeTypesRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetListeTypes'
        Then status 200
#            And print 'response: ', response
            And match /Envelope/Body/GetListeTypesResponse/TypeTechnique == 'Auto'

    Scenario: Récupération des sous-types du type "Auto"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetListeSousTypesRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">Auto</ns0:GetListeSousTypesRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetListeSousTypes'
        Then status 200
#            And print 'response: ', response
            And match /Envelope/Body/GetListeSousTypesResponse/SousType == ["sign avec meta","sign sans meta","visa avec meta","visa sans meta"]

    Scenario Outline: Récupération des dossiers ayant le statut "${status}"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:RechercherDossiersRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>Auto</ns0:TypeTechnique>
            <ns0:SousType>visa avec meta</ns0:SousType>
            <ns0:Status>#(status)</ns0:Status>
        </ns0:RechercherDossiersRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'RechercherDossiers'
        Then status 200
#            And print 'response: ', response
            And match /Envelope/Body/RechercherDossiersResponse/LogDossier/annotation == expected
        Examples:
            | status    | expected!                                                                                                           |
            | Archive   | ["Annotation publique lvermillon (Auto_visa_avec_meta_1)","Annotation publique lvermillon (Auto_visa_avec_meta_3)"] |
            | RejetVisa | ["Annotation publique lvermillon (Auto_visa_avec_meta_2)","Annotation publique lvermillon (Auto_visa_avec_meta_4)"] |
            | Rejet*    | ["Annotation publique lvermillon (Auto_visa_avec_meta_2)","Annotation publique lvermillon (Auto_visa_avec_meta_4)"] |

    Scenario: Création d'un dossier simple pour le type "visa sans meta"
        * def name = 'Test karate SOAP 1'
        * def Base64 = Java.type('java.util.Base64')
        * def documentPrincipal = Base64.encoder.encodeToString(karate.read('classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf'))

        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:CreerDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>Auto</ns0:TypeTechnique>
            <ns0:SousType>visa sans meta</ns0:SousType>
            <ns0:DossierID></ns0:DossierID>
            <ns0:DossierTitre>#(name)</ns0:DossierTitre>
            <ns0:DocumentPrincipal xmlns:ns1="http://www.w3.org/2005/05/xmlmime" ns1:contentType="application/pdf">#(documentPrincipal)</ns0:DocumentPrincipal>
            <ns0:NomDocPrincipal>monDoc.pdf</ns0:NomDocPrincipal>
            <ns0:VisuelPDF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:XPathPourSignatureXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:MetaDataTdtACTES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:AnnotationPublique>Annotation publique (#(name))</ns0:AnnotationPublique>
            <ns0:AnnotationPrivee>Annotation privée (#(name))</ns0:AnnotationPrivee>
            <ns0:Visibilite>PUBLIC</ns0:Visibilite>
            <ns0:DateLimite>2020-05-12</ns0:DateLimite>
        </ns0:CreerDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'CreerDossier'
        Then status 200
#            And print 'response: ', response
            And def expected =
"""
<MessageRetour>
    <codeRetour>OK</codeRetour>
    <message>Dossier Test karate SOAP 1 soumis dans le circuit</message>
    <severite>INFO</severite>
</MessageRetour>
"""
            And match /Envelope/Body/CreerDossierResponse/MessageRetour == expected
@wip
    # @fixme: A mandatory metadata was not filled, abort
    Scenario: Création d'un dossier simple pour le type "visa avec meta"
        * def name = 'Test karate SOAP 1'
        * def Base64 = Java.type('java.util.Base64')
        * def documentPrincipal = Base64.encoder.encodeToString(karate.read('classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf'))

        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:CreerDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>Auto</ns0:TypeTechnique>
            <ns0:SousType>visa avec meta</ns0:SousType>
            <ns0:DossierID></ns0:DossierID>
            <ns0:DossierTitre>#(name)</ns0:DossierTitre>
            <ns0:DocumentPrincipal xmlns:ns1="http://www.w3.org/2005/05/xmlmime" ns1:contentType="application/pdf">#(documentPrincipal)</ns0:DocumentPrincipal>
            <ns0:NomDocPrincipal>monDoc.pdf</ns0:NomDocPrincipal>
            <ns0:VisuelPDF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:MetaData>
                <ns0:MetaDonnee>
                    <ns0:nom>mameta_bool</ns0:nom>
                    <ns0:valeur>true</ns0:valeur>
                </ns0:MetaDonnee>
            </ns0:MetaData>
            <ns0:XPathPourSignatureXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:MetaDataTdtACTES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:AnnotationPublique>Annotation publique (#(name))</ns0:AnnotationPublique>
            <ns0:AnnotationPrivee>Annotation privée (#(name))</ns0:AnnotationPrivee>
            <ns0:Visibilite>PUBLIC</ns0:Visibilite>
            <ns0:DateLimite>2020-05-12</ns0:DateLimite>
        </ns0:CreerDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'CreerDossier'
        Then status 200
#            And print 'response: ', response
            And def expected =
"""
<MessageRetour>
    <codeRetour>OK</codeRetour>
    <message>Dossier Test karate SOAP 1 soumis dans le circuit</message>
    <severite>INFO</severite>
</MessageRetour>
"""
            And match /Envelope/Body/CreerDossierResponse/MessageRetour == expected
@x-wip @fixme
    # 507 Insufficient Storage from POST http://core:8080/api/v1/tenant/05000656-c437-4377-9586-be9b3da5f7d4/desk/7b497ecb-8f81-48e0-9383-8fceb85c3ccb/draft
    Scenario: Création d'un dossier avec annexe pour le type "visa sans meta"
        * def name = 'Test karate SOAP 1'
        * def Base64 = Java.type('java.util.Base64')
        * def documentPrincipal = Base64.encoder.encodeToString(karate.read('classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf'))
        * def annexe = Base64.encoder.encodeToString(karate.read('classpath:files/pdf/annex-1_1.pdf'))

        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:CreerDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>Auto</ns0:TypeTechnique>
            <ns0:SousType>visa sans meta</ns0:SousType>
            <ns0:DossierID></ns0:DossierID>
            <ns0:DossierTitre>#(name)</ns0:DossierTitre>
            <ns0:DocumentPrincipal xmlns:ns1="http://www.w3.org/2005/05/xmlmime" ns1:contentType="application/pdf">#(documentPrincipal)</ns0:DocumentPrincipal>
            <ns0:NomDocPrincipal>monDoc.pdf</ns0:NomDocPrincipal>
            <ns0:DocumentsSupplementaires>
                <ns0:DocAnnexe>
                    <ns0:nom>annexe1.pdf</ns0:nom>
                    <ns0:fichier xmlns:ns3="http://www.w3.org/2005/05/xmlmime" ns3:contentType="application/pdf">#(annexe)</ns0:fichier>
                    <ns0:mimetype>application/pdf</ns0:mimetype>
                    <ns0:encoding>UTF-8</ns0:encoding>
                </ns0:DocAnnexe>
            </ns0:DocumentsSupplementaires>
            <ns0:DocumentsAnnexes>
                <ns0:DocAnnexe>
                    <ns0:nom>annexe1.pdf</ns0:nom>
                    <ns0:fichier xmlns:ns6="http://www.w3.org/2005/05/xmlmime" ns6:contentType="application/pdf">#(annexe)</ns0:fichier>
                    <ns0:mimetype>application/pdf</ns0:mimetype>
                    <ns0:encoding>UTF-8</ns0:encoding>
                </ns0:DocAnnexe>
            </ns0:DocumentsAnnexes>
            <ns0:VisuelPDF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:XPathPourSignatureXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:MetaDataTdtACTES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:AnnotationPublique>Annotation publique (#(name))</ns0:AnnotationPublique>
            <ns0:AnnotationPrivee>Annotation privée (#(name))</ns0:AnnotationPrivee>
            <ns0:Visibilite>PUBLIC</ns0:Visibilite>
            <ns0:DateLimite>2020-05-12</ns0:DateLimite>
        </ns0:CreerDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'CreerDossier'
        Then status 200
            And def expected =
"""
<MessageRetour>
    <codeRetour>OK</codeRetour>
    <message>Dossier Test karate SOAP 1 soumis dans le circuit</message>
    <severite>INFO</severite>
</MessageRetour>
"""
            And match /Envelope/Body/CreerDossierResponse/MessageRetour == expected

#@x-wip
#     # @info: createDraftFolder - A mandatory metadata was not filled, abort -> créer un sous-type sans et avec métadonnée
#    Scenario: Création d'un dossier avec signature détachée et annexes
#        * def Base64 = Java.type('java.util.Base64')
#        * def documentPrincipal = Base64.encoder.encodeToString(karate.read('classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf'))
#        * xmlstring signatureXml = karate.read('classpath:files/formats/PDF_avec_tags/signature_xades.xml')
#        * def signature = Base64.encoder.encodeToString(signatureXml.getBytes())
#        * def annexe = Base64.encoder.encodeToString(karate.read('classpath:files/pdf/annex-1_1.pdf'))
#
#        Given request
#"""
#<?xml version='1.0' encoding='utf-8'?>
#<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
#    <soap-env:Body>
#        <ns0:CreerDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
#            <ns0:TypeTechnique>Auto</ns0:TypeTechnique>
#            <ns0:SousType>sign</ns0:SousType>
#            <ns0:DossierID></ns0:DossierID>
#            <ns0:DossierTitre>Test karate SOAP 1</ns0:DossierTitre>
#            <ns0:DocumentPrincipal xmlns:ns1="http://www.w3.org/2005/05/xmlmime" ns1:contentType="application/pdf">#(documentPrincipal)</ns0:DocumentPrincipal>
#            <ns0:NomDocPrincipal>monDoc.pdf</ns0:NomDocPrincipal>
#            <ns0:SignatureDocPrincipal xmlns:ns2="http://www.w3.org/2005/05/xmlmime" ns2:contentType="text/xml">#(signature)</ns0:SignatureDocPrincipal>
#            <ns0:VisuelPDF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
#            <ns0:DocumentsSupplementaires>
#                <ns0:DocAnnexe>
#                    <ns0:nom>annexe1.pdf</ns0:nom>
#                    <ns0:fichier xmlns:ns3="http://www.w3.org/2005/05/xmlmime" ns3:contentType="application/pdf">#(annexe)</ns0:fichier>
#                    <ns0:mimetype>application/pdf</ns0:mimetype>
#                    <ns0:encoding>UTF-8</ns0:encoding>
#                </ns0:DocAnnexe>
#                <ns0:DocAnnexe>
#                    <ns0:nom>annexe1.pdf</ns0:nom>
#                    <ns0:fichier xmlns:ns4="http://www.w3.org/2005/05/xmlmime" ns4:contentType="application/pdf">#(annexe)</ns0:fichier>
#                    <ns0:mimetype>application/pdf</ns0:mimetype>
#                    <ns0:encoding>UTF-8</ns0:encoding>
#                    <ns0:signature xmlns:ns5="http://www.w3.org/2005/05/xmlmime" ns5:contentType="text/xml">#(signature)</ns0:signature>
#                </ns0:DocAnnexe>
#            </ns0:DocumentsSupplementaires>
#            <ns0:DocumentsAnnexes>
#                <ns0:DocAnnexe>
#                    <ns0:nom>annexe1.pdf</ns0:nom>
#                    <ns0:fichier xmlns:ns6="http://www.w3.org/2005/05/xmlmime" ns6:contentType="application/pdf">#(annexe)</ns0:fichier>
#                    <ns0:mimetype>application/pdf</ns0:mimetype>
#                    <ns0:encoding>UTF-8</ns0:encoding>
#                </ns0:DocAnnexe>
#                <ns0:DocAnnexe>
#                    <ns0:nom>annexe1.pdf</ns0:nom>
#                    <ns0:fichier xmlns:ns7="http://www.w3.org/2005/05/xmlmime" ns7:contentType="application/pdf">#(annexe)</ns0:fichier>
#                    <ns0:mimetype>application/pdf</ns0:mimetype>
#                    <ns0:encoding>UTF-8</ns0:encoding>
#                    <ns0:signature xmlns:ns8="http://www.w3.org/2005/05/xmlmime" ns8:contentType="text/xml">#(signature)</ns0:signature>
#                </ns0:DocAnnexe>
#            </ns0:DocumentsAnnexes>
#            <ns0:MetaData>
#                <ns0:MetaDonnee>
#                    <ns0:nom>mameta_bool</ns0:nom>
#                    <ns0:valeur>false</ns0:valeur>
#                </ns0:MetaDonnee>
#            </ns0:MetaData>
#            <ns0:XPathPourSignatureXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
#            <ns0:MetaDataTdtACTES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
#            <ns0:AnnotationPublique>Annotation publique (Test karate SOAP 1)</ns0:AnnotationPublique>
#            <ns0:AnnotationPrivee>Annotation privée (Test karate SOAP 1)</ns0:AnnotationPrivee>
#            <ns0:Visibilite>PUBLIC</ns0:Visibilite>
#            <ns0:DateLimite>2020-05-12</ns0:DateLimite>
#        </ns0:CreerDossierRequest>
#    </soap-env:Body>
#</soap-env:Envelope>
#"""
#        When soap action 'CreerDossier'
#        Then status 200
#        And print 'response: ', response
