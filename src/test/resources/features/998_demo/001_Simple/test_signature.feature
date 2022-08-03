@x-wip
# @todo: utiliser l'entité "Formats de signature"
# @todo: 1 fichier de feature par dossier testé
# @todo: mettre à jour (simplifier, nouvelles méthodes) ou supprimer
Feature: Test signatures IP 5

    # @info: il manque un type dans ce tenant...
#    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
#        * api_v1.auth.login('user', 'password')
#        * call read('classpath:lib/api/setup/type.create.feature') __row
#
#        Examples:
#            | tenant      | name               | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
#            | Démo simple | Automatique        | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":0,"y":0,"page":1} |
#
#    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
#        * api_v1.auth.login('user', 'password')
#        * call read('classpath:lib/api/setup/subtype.create.feature') __row
#
#        Examples:
#            | tenant      | type               | name                         | multiDocuments! | validationWorkflowId | sealAutomatic! | sealCertificateId                                  | secureMailServerId |
#            | Démo simple | Automatique        | Signature                    | false           | Signature            | null           |                                                    |                    |

    Scenario Outline: Création du dossier "${nameTemplate}" de type type "${type} / ${subtype}" par ${username}
        * api_v1.auth.login("user", "password")
        * def folders = api_v1.desk.draft.getPayloadMonodoc(__row, 1, {}, 1)
        * api_v1.auth.login("<username>", "<password>")
        * call read("classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature") folders

        Examples:
            | tenant      | username       | password | desktop    | mainFile!                                                                                            | type        | subtype      | nameTemplate | annotation |
            | Démo simple | ws@demo-simple | a123456  | WebService | commonpath.get("PDF_avec_tags.pdf")                                                                       | ACTES       | Délibération | xxx          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags-signature_pades.pdf'                            | ACTES       | Délibération | yyy          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | {'file': commonpath.get("PDF_avec_tags.pdf"), 'detached': commonpath.get("PDF_avec_tags/signature_cades.p7s")} | Automatique | Signature    | aaa          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | {'file': commonpath.get("PDF_avec_tags.pdf"), 'detached': commonpath.get("PDF_avec_tags/signature_xades.xml")} | Automatique | Signature    | bbb          | démarrage  |

    Scenario Outline: Création du dossier "${name}" de type "${type} / ${subtype}" avec 2 annexes par ${username}
        * api_v1.auth.login("<username>", "<password>")

        * def params = karate.call('classpath:lib/v5/business/api/draft/params.feature', __row)

        Given url baseUrl
            And path params.path
            And header Accept = "application/json"
            And multipart file draftFolderParams = { "value": "#(params.draftFolderParams)", "contentType": "application/json" }
            And multipart file mainFiles = { read: "#(mainFiles[0])", contentType: "#(utils.file.mime(mainFiles[0]))" }
            And multipart file annexeFiles = { read: "#(annexes[0])", contentType: "#(utils.file.mime(annexes[0]))" }
            And multipart file annexeFiles = { read: "#(annexes[1])", contentType: "#(utils.file.mime(annexes[1]))" }
        When method POST
        Then status 201

        # @info: si besoin de signatures détachées
        #* v5.business.api.draft.addDetachedSignature(response, params, mainFiles[0], commonpath.get("PDF_avec_tags/signature_cades.p7s"))

        * karate.call('classpath:lib/v5/business/api/draft/send.feature', karate.merge(__row, { path: params.path }))

        Examples:
            | tenant      | username       | password | desktop    | mainFiles!                       | type  | subtype      | name | annotation | annexes!                                                                |
            | Démo simple | ws@demo-simple | a123456  | WebService | [commonpath.get("PDF_avec_tags.pdf")] | ACTES | Délibération | ccc  | démarrage  | [commonpath.get("document_libre_office.odt"), commonpath.get("document_rtf.rtf")] |

    Scenario Outline: Signature du dossier "${folder}" par ${username}
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

        * match files ==
"""
{
    "documents": [
        {
            "PDF_avec_tags.pdf": {
                "path": "#string",
                "detached": {
                    "PDF_avec_tags-0-signature_externe.p7s": "#string",
                    "PDF_avec_tags-1-Frédéric Losserand.p7s": "#string"
                }
            }
        }
    ],
    "annexes": {}
}
"""
        * match karate.read(downloadpath.document(files, "PDF_avec_tags.pdf")) == karate.read(commonpath.get("PDF_avec_tags.pdf"))

        * match karate.read(downloadpath.detached(files, "PDF_avec_tags-0-signature_externe.p7s")) == karate.read(commonpath.get("PDF_avec_tags/signature_cades.p7s"))

        * ip.signature.cades.check(karate.toAbsolutePath(commonpath.get("PDF_avec_tags.pdf")), downloadpath.detached(files, "PDF_avec_tags-1-Frédéric Losserand.p7s", ""))

    Scenario: Vérifications des documents du dossier "xxx"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def files = v5.business.api.folder.downloadFiles("Démo simple", "WebService", "finished", "xxx")
        * match files ==
"""
{
    "documents": [
        {
            "PDF_avec_tags.pdf": {
                "path": "#string",
                "detached": {}
            }
        }
    ],
    "annexes": {}
}
"""
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
        * match ip.signature.pades.certificates.read(downloadpath.document(files, "PDF_avec_tags.pdf")) == expectedSignatures

    Scenario: Vérifications des documents du dossier "yyy"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def files = v5.business.api.folder.downloadFiles("Démo simple", "WebService", "finished", "yyy")
        * match files ==
"""
{
    "documents": [
        {
            "PDF_avec_tags-signature_pades.pdf": {
                "path": "#string",
                "detached": {}
            }
        }
    ],
    "annexes": {}
}
"""
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
        * match ip.signature.pades.certificates.read(downloadpath.document(files, "PDF_avec_tags-signature_pades.pdf")) == expectedSignatures

    Scenario: Vérifications des fichiers du dossier "ccc"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def files = v5.business.api.folder.downloadFiles("Démo simple", "WebService", "finished", "ccc")

        # Vérification des fichiers présents dans le dossier
        * match files ==
"""
{
    "documents": [
        {
            "PDF_avec_tags.pdf": {
                "path": "#string",
                "detached": {}
            }
        }
    ],
    "annexes": {
        "document_libre_office.odt": "#string",
        "document_rtf.rtf": "#string"
    }
}
"""

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
        * match ip.signature.pades.certificates.read(downloadpath.document(files, "PDF_avec_tags.pdf")) == expectedSignatures

        # Vérification des fichiers non signés (annexes)
        * match karate.read(downloadpath.annexe(files, "document_libre_office.odt")) == karate.read(commonpath.get("document_libre_office.odt"))
        * match karate.read(downloadpath.annexe(files, "document_rtf.rtf")) == karate.read(commonpath.get("document_rtf.rtf"))
