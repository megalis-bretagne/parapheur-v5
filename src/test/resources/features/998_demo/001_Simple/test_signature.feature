@x-wip
# @todo: utiliser l'entité "Formats de signature"
# @todo: ajouter les paquets nécessaire pour l'intégration continue + dans le README-karatte
Feature: Test signatures IP 5

    # @info: il manque un type...
    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * api_v1.auth.login('user', 'password')
        * call read('classpath:lib/api/setup/type.create.feature') __row

        Examples:
            | tenant      | name               | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
            | Démo simple | Automatique        | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":0,"y":0,"page":1} |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * api_v1.auth.login('user', 'password')
        * call read('classpath:lib/api/setup/subtype.create.feature') __row

        Examples:
            | tenant      | type               | name                         | multiDocuments! | validationWorkflowId | sealAutomatic! | sealCertificateId                                  | secureMailServerId |
            | Démo simple | Automatique        | Signature                    | false           | Signature            | null           |                                                    |                    |

    Scenario Outline: Création du dossier "${nameTemplate}" de type type "${type} / ${subtype}"
        * api_v1.auth.login("user", "password")
        * def folders = api_v1.desk.draft.getPayloadMonodoc(__row, 1, {}, 1)
        * api_v1.auth.login("<username>", "<password>")
        * call read("classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature") folders

        Examples:
            | tenant      | username       | password | desktop    | mainFile!                                                                                                                                    | type  | subtype      | nameTemplate | annotation |
            | Démo simple | ws@demo-simple | a123456  | WebService | 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf'                                                                                    | ACTES       | Délibération | xxx          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags-signature_pades.pdf'                                                                    | ACTES       | Délibération | yyy          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | {'file': 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf', 'detached': 'classpath:files/formats/PDF_avec_tags/signature_cades.p7s'} | Automatique | Signature    | aaa          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | {'file': 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf', 'detached': 'classpath:files/formats/PDF_avec_tags/signature_xades.xml'} | Automatique | Signature    | bbb          | démarrage  |
@wip
    Scenario Outline: Création du dossier "${nameTemplate}" de type type "${type} / ${subtype}" avec annexes
        * api_v1.auth.login("user", "password")
        * def folders = api_v1.desk.draft.getPayloadMonodoc(__row, 1, {}, 1)
        * api_v1.auth.login("<username>", "<password>")
        * karate.log(folders[0])

        # @todo: factoriser
        * def mainFileContentType = utils.file.mime(mainFile)

        * def annexFileContentType0 = utils.file.mime(annexes[0])
        * def annexFileContentType1 = utils.file.mime(annexes[1])

        Given url baseUrl
            And path folders[0].path
            And header Accept = 'application/json'
            And multipart file draftFolderParams = { 'value': '#(folders[0].draftFolderParams)', 'contentType': 'application/json' }
            And multipart file mainFiles = {  read: '#(mainFile)', contentType: #(mainFileContentType) }
            And multipart file annexeFiles = {  read: '#(annexes[0])', contentType: #(annexFileContentType0) }
            And multipart file annexeFiles = {  read: '#(annexes[1])', contentType: #(annexFileContentType1) }
        When method POST
        Then status 201
        # Ajout de la signature détachée le cas échéant
        # * eval if (mainFileDetachedPath !== null) karate.call('classpath:lib/api/setup/folder.document.detachedSignature.create.feature', { tenantId: tenantId, folderId: response.id, deskId: deskId, documentId: utils.getDraftDocumentId(response, mainFile), detachedSignature: mainFileDetachedPath })

        * def publicAnnotation = templates.annotations.getPublic(username, "démarrage", folders[0].draftFolderParams.name)
        * def privateAnnotation = templates.annotations.getPrivate(username, "démarrage", folders[0].draftFolderParams.name)

        Given url baseUrl
            And path folders[0].path + "/" + response.id
            And header Accept = "application/json"
            And request { "publicAnnotation": "#(publicAnnotation)", "privateAnnotation": "#(privateAnnotation)" }
        When method PUT
        Then status 200

#        * def new =
#"""
#{
#    files: [
#        "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf"
#    ],
#    detached: {
#        "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf": "classpath:files/formats/PDF_avec_tags/signature_cades.p7s"
#    },
#    annexes: [
#        "classpath:files/formats/document_libre_office/document_libre_office.odt",
#        "classpath:files/formats/document_rtf/document_rtf.rtf"
#    ]
#}
#"""
        Examples:
            | tenant      | username       | password | desktop    | mainFile!                                                 | type  | subtype      | nameTemplate | annotation | annexes!                                                                                                                             |
            | Démo simple | ws@demo-simple | a123456  | WebService | 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf' | ACTES | Délibération | ccc          | démarrage  | ["classpath:files/formats/document_libre_office/document_libre_office.odt", "classpath:files/formats/document_rtf/document_rtf.rtf"] |

    Scenario Outline: Signature du dossier "${folder}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant      | username               | password | desktop   | folder | certificate | annotation |
            | Démo simple | flosserand@demo-simple | a123456  | Président | xxx    | signature   | signature  |
            | Démo simple | flosserand@demo-simple | a123456  | Président | yyy    | signature   | signature  |
            | Démo simple | flosserand@demo-simple | a123456  | Président | aaa    | signature   | signature  |
            | Démo simple | flosserand@demo-simple | a123456  | Président | bbb    | signature   | signature  |
            | Démo simple | flosserand@demo-simple | a123456  | Président | ccc    | signature   | signature  |

    Scenario: Vérifications des documents du dossier "aaa"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def files = v5.business.api.folder.downloadFiles("Démo simple", "WebService", "finished", "aaa")

        * match files == { "documents": [ { "PDF_avec_tags.pdf": { "path": "#string", "detached": { "PDF_avec_tags-0-signature_externe.p7s": "#string", "PDF_avec_tags-1-Frédéric Losserand.p7s": "#string" } } } ], "annexes": {} }

        #* match utils.signature.getPdfSignatures(buildDir + files["documents"][0]["PDF_avec_tags.pdf"]["path"]) == []
        * match karate.read("file:" + buildDir + files["documents"][0]["PDF_avec_tags.pdf"]["path"]) == karate.read("classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf")
        * match karate.read("file:" + buildDir + "/" + files["documents"][0]["PDF_avec_tags.pdf"]["detached"]["PDF_avec_tags-0-signature_externe.p7s"]) == karate.read("classpath:files/formats/PDF_avec_tags/signature_cades.p7s")

        * utils.signature.checkPkcs7(karate.toAbsolutePath("classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf"), buildDir + "/" + files["documents"][0]["PDF_avec_tags.pdf"]["detached"]["PDF_avec_tags-1-Frédéric Losserand.p7s"], karate.toAbsolutePath(templates.certificate.default("signature")["public"]))

    Scenario: Vérifications des documents du dossier "xxx"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def files = v5.business.api.folder.downloadFiles("Démo simple", "WebService", "finished", "xxx")
        * match files == { "documents": [ { "PDF_avec_tags.pdf": { "path": "#string", "detached": {} } } ], "annexes": {} }
        * def expectedSignatures =
"""
[
    {
        commonName: "Prenom Nom - Usages",
        distinguishedName: "E=christian.buffin@libriciel.coop,CN=Prenom Nom - Usages,OU=Usages,O=Collectivite ou organisation,L=Ville,ST=34 - Herault,C=FR",
        algorithm: "SHA-256",
        type: "ETSI.CAdES.detached",
        valid: true,
        wholeDocumentSigned: true
    }
]
"""
        * match utils.signature.getPdfSignatures(buildDir + files["documents"][0]["PDF_avec_tags.pdf"]["path"]) == expectedSignatures

    Scenario: Vérifications des documents du dossier "yyy"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def files = v5.business.api.folder.downloadFiles("Démo simple", "WebService", "finished", "yyy")
        * match files == { "documents": [ { "PDF_avec_tags-signature_pades.pdf": { "path": "#string", "detached": {} } } ], "annexes": {} }
        * def expectedSignatures =
"""
[
  {
    "commonName": "Christian Noir - Recette i-parapheur",
    "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Christian Noir - Recette i-parapheur,OU=Recette i-parapheur,O=Libriciel SCOP,L=Montpellier,ST=34 - Herault,C=FR",
    "algorithm": "SHA-256",
    "type": "ETSI.CAdES.detached",
    "wholeDocumentSigned": false,
    "valid": true
  },
  {
    "commonName": "Prenom Nom - Usages",
    "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Prenom Nom - Usages,OU=Usages,O=Collectivite ou organisation,L=Ville,ST=34 - Herault,C=FR",
    "algorithm": "SHA-256",
    "type": "ETSI.CAdES.detached",
    "wholeDocumentSigned": true,
    "valid": true
  }
]
"""
        * match utils.signature.getPdfSignatures(buildDir + files["documents"][0]["PDF_avec_tags-signature_pades.pdf"]["path"]) == expectedSignatures

    Scenario: Vérifications des fichiers du dossier "ccc"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def files = v5.business.api.folder.downloadFiles("Démo simple", "WebService", "finished", "ccc")

        # Vérification des fichiers du dossier
        * match files == { "documents": [ { "PDF_avec_tags.pdf": { "path": "#string", "detached": {} } } ], "annexes": { "document_libre_office.odt": "#string", "document_rtf.rtf": "#string" } }

        # Vérification des fichiers signés
        * def expectedSignatures =
"""
[
  {
    "commonName": "Prenom Nom - Usages",
    "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Prenom Nom - Usages,OU=Usages,O=Collectivite ou organisation,L=Ville,ST=34 - Herault,C=FR",
    "algorithm": "SHA-256",
    "type": "ETSI.CAdES.detached",
    "wholeDocumentSigned": true,
    "valid": true
  }
]
"""
        * match utils.signature.getPdfSignatures(buildDir + "/" + files["documents"][0]["PDF_avec_tags.pdf"]["path"]) == expectedSignatures

        # Vérification des fichiers non signés (annexes)
        * match karate.read("file:" + buildDir + "/" + files["annexes"]["document_libre_office.odt"]) == karate.read("classpath:files/formats/document_libre_office/document_libre_office.odt")
        * match karate.read("file:" + buildDir + "/" + files["annexes"]["document_rtf.rtf"]) == karate.read("classpath:files/formats/document_rtf/document_rtf.rtf")
