@legacy-bridge @soap @tests
Feature: CreerDossier
    # @see https://gitlab.libriciel.fr/libriciel/pole-signature/iparapheur-v5/iparapheur/legacy-bridge/-/issues/16
    # @fixme: @fixme-ip4, je peux créer des dossiers multidoc dans une typologie monodoc
    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario Outline: Création du dossier "${nom}" pour le type "${type} / ${sousType}"
        * def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        * call read('classpath:lib/soap/requests/CreerDossier/simple_success.feature') params

        Examples:
            | type         | sousType       | nom                          | documentPrincipal                                       | visibilite   | dateLimite |
            | Auto monodoc | visa sans meta | SOAP public avec date limite | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | PUBLIC       | 2020-05-12 |
            | Auto monodoc | visa sans meta | SOAP confidentiel            | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            |

    Scenario: Création du dossier "SOAP public avec DossierID" pour le type "Auto monodoc / visa sans meta"
        * def params =
"""
{
    type: "Auto monodoc",
    sousType: "visa sans meta",
    nom: "SOAP public avec DossierID",
    documentPrincipal: "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf",
    dossierId: "J'aime développer",
    visibilite: "PUBLIC",
    dateLimite: "",
    password: "a123456",
    username: "ws@legacy-bridge"
}
"""
        * call read('classpath:lib/soap/requests/CreerDossier/simple_success.feature') params

    Scenario: Création du dossier "SOAP avec DossierID en doublon" pour le type "Auto monodoc / visa sans meta"
        * def uuid = utils.getUUID()
        * def params =
"""
{
    type: "Auto monodoc",
    sousType: "visa sans meta",
    nom: "SOAP avec DossierID en doublon",
    documentPrincipal: "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf",
    dossierId: "",
    visibilite: "PUBLIC",
    dateLimite: "",
    password: "a123456",
    username: "ws@legacy-bridge"
}
"""
        * params['dossierId'] = uuid;

        # 1. Création du premier dossier avec ce DossierID
        * call read('classpath:lib/soap/requests/CreerDossier/simple_success.feature') params

        # 2. Tentative de création du second dossier avec le même DossierID
        * call read('classpath:lib/soap/requests/CreerDossier/simple.feature') params
            And match /Envelope/Body/CreerDossierResponse/MessageRetour/message == "Le nom de dossier est déjà présent dans le Parapheur: dossierID = " + uuid
            And match response == karate.read('classpath:lib/soap/schemas/CreerDossierResponse/KO.xml')

    @fixme-ip5
    Scenario Outline: Création du dossier "${nom}" pour le type "${type} / ${sousType}"
        * def documentPrincipal = api.soap.file.encode('classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf')
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
            <ns0:MetaData>
                <ns0:MetaDonnee>
                    <ns0:nom>mameta_bool</ns0:nom>
                    <ns0:valeur>#(mameta_bool)</ns0:valeur>
                </ns0:MetaDonnee>
            </ns0:MetaData>
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
            And match /Envelope/Body/CreerDossierResponse/DossierID == '#uuid'
            And match response == karate.read('classpath:lib/soap/schemas/CreerDossierResponse/OK.xml')

        Examples:
            | type         | sousType       | nom                                  | documentPrincipal                                       | visibilite   | dateLimite | mameta_bool |
            | Auto monodoc | visa avec meta | SOAP confidentiel, mameta_bool false | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | false       |
            | Auto monodoc | visa avec meta | SOAP confidentiel, mameta_bool true  | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | true        |

    @fixme-ip5
    Scenario Outline: Création du dossier "${nom}" pour le type "${type} / ${sousType}" avec une annexe PDF
        * def documentPrincipal = api.soap.file.encode('classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf')
        * def annexe = api.soap.file.encode('classpath:files/pdf/annex-1_1.pdf')
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
            And match /Envelope/Body/CreerDossierResponse/DossierID == '#uuid'
            And match response == karate.read('classpath:lib/soap/schemas/CreerDossierResponse/OK.xml')

        Examples:
            | type         | sousType       | nom                                | documentPrincipal                                       | visibilite   | dateLimite |
            | Auto monodoc | visa sans meta | SOAP confidentiel, avec annexe PDF | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            |
    @fixme-ip-5
    # @todo: il est bien créé mais sans la signarture détachée
    Scenario Outline: Création d'un dossier monodoc "${nom}" pour le type "${type} / ${sousType}", avec une signature détachée XAdES
        * def documentPrincipal = api.soap.file.encode('classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf')
        * def signature = api.soap.file.encode('classpath:files/formats/PDF_avec_tags/signature_xades.xml')
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
            <ns0:SignatureDocPrincipal xmlns:ns2="http://www.w3.org/2005/05/xmlmime" ns2:contentType="text/xml">#(signature)</ns0:SignatureDocPrincipal>
            <ns0:VisuelPDF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:XPathPourSignatureXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:MetaDataTdtACTES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:AnnotationPublique>#(annotationPublique)</ns0:AnnotationPublique>
            <ns0:AnnotationPrivee>#(annotationPrivee)</ns0:AnnotationPrivee>
            <ns0:Visibilite>#(visibilite)</ns0:Visibilite>
            <ns0:DateLimite></ns0:DateLimite>
        </ns0:CreerDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'CreerDossier'
        Then status 200
            And match /Envelope/Body/CreerDossierResponse/MessageRetour/message == "Dossier " + nom + " soumis dans le circuit"
            And match /Envelope/Body/CreerDossierResponse/DossierID == '#uuid'
            And match response == karate.read('classpath:lib/soap/schemas/CreerDossierResponse/OK.xml')

        Examples:
            | type         | sousType       | nom                                               | documentPrincipal                                       | visibilite   |
            | Auto monodoc | visa sans meta | SOAP confidentiel monodoc avec signature détachée | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |

    @fixme-ip4 @fixme-ip5
    # @info: IP 5 -> createDraftFolder - A mandatory metadata was not filled, abort -> créer un sous-type sans et avec métadonnée
    # @info: IP 4 -> Pas de circuit défini pour ce dossier (avec l'utilisateur lvermillon@legacy-bridge)
    #               https://iparapheur47.test.libriciel.fr/iparapheur/proxy/alfresco/parapheur/dossiers/e8c6abfb-6fb0-4801-8def-996b0a7890ba/circuit -> 500
    Scenario Outline: Création d'un dossier multidoc "${nom}" pour le type "${type} / ${sousType}", dont un avec une signature détachée XAdES et des annexes
        * def documentPrincipal = api.soap.file.encode('classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf')
        * def signature = api.soap.file.encode('classpath:files/formats/PDF_avec_tags/signature_xades.xml')
        * def annexe = api.soap.file.encode('classpath:files/pdf/annex-1_1.pdf')
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
            <ns0:SignatureDocPrincipal xmlns:ns2="http://www.w3.org/2005/05/xmlmime" ns2:contentType="text/xml">#(signature)</ns0:SignatureDocPrincipal>
            <ns0:VisuelPDF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            <ns0:DocumentsSupplementaires>
                <!-- multidoc -->
                <ns0:DocAnnexe>
                    <ns0:nom>annexe1.pdf</ns0:nom>
                    <ns0:fichier xmlns:ns3="http://www.w3.org/2005/05/xmlmime" ns3:contentType="application/pdf">#(annexe)</ns0:fichier>
                    <ns0:mimetype>application/pdf</ns0:mimetype>
                    <ns0:encoding>UTF-8</ns0:encoding>
                </ns0:DocAnnexe>
                <ns0:DocAnnexe>
                    <!-- multidoc avec signature -->
                    <ns0:nom>annexe1.pdf</ns0:nom>
                    <ns0:fichier xmlns:ns4="http://www.w3.org/2005/05/xmlmime" ns4:contentType="application/pdf">#(annexe)</ns0:fichier>
                    <ns0:mimetype>application/pdf</ns0:mimetype>
                    <ns0:encoding>UTF-8</ns0:encoding>
                    <ns0:signature xmlns:ns5="http://www.w3.org/2005/05/xmlmime" ns5:contentType="text/xml">#(signature)</ns0:signature>
                </ns0:DocAnnexe>
            </ns0:DocumentsSupplementaires>
            <ns0:DocumentsAnnexes>
                <ns0:DocAnnexe>
                    <ns0:nom>annexe1.pdf</ns0:nom>
                    <ns0:fichier xmlns:ns6="http://www.w3.org/2005/05/xmlmime" ns6:contentType="application/pdf">#(annexe)</ns0:fichier>
                    <ns0:mimetype>application/pdf</ns0:mimetype>
                    <ns0:encoding>UTF-8</ns0:encoding>
                </ns0:DocAnnexe>
                <ns0:DocAnnexe>
                    <ns0:nom>annexe1.pdf</ns0:nom>
                    <ns0:fichier xmlns:ns7="http://www.w3.org/2005/05/xmlmime" ns7:contentType="application/pdf">#(annexe)</ns0:fichier>
                    <ns0:mimetype>application/pdf</ns0:mimetype>
                    <ns0:encoding>UTF-8</ns0:encoding>
                    <!-- @info: c'est sensé l'ignorer (ce serait une signature détachée sur une annexe) -->
                    <ns0:signature xmlns:ns8="http://www.w3.org/2005/05/xmlmime" ns8:contentType="text/xml">#(signature)</ns0:signature>
                </ns0:DocAnnexe>
            </ns0:DocumentsAnnexes>
            <ns0:MetaData>
                <ns0:MetaDonnee>
                    <ns0:nom>mameta_bool</ns0:nom>
                    <ns0:valeur>#(mameta_bool)</ns0:valeur>
                </ns0:MetaDonnee>
            </ns0:MetaData>
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
            And match /Envelope/Body/CreerDossierResponse/DossierID == '#uuid'
            And match response == karate.read('classpath:lib/soap/schemas/CreerDossierResponse/OK.xml')

        Examples:
            | type          | sousType       | nom                                           | documentPrincipal                                       | visibilite   | dateLimite | mameta_bool |
            | Auto multidoc | visa avec meta | SOAP confidentiel multidoc, mameta_bool false | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | false       |
            | Auto multidoc | visa avec meta | SOAP confidentiel multidoc, mameta_bool true  | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | true        |
