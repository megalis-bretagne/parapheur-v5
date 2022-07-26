@x-wip
# @todo: utiliser l'entité "Formats de signature"
# @todo: ajouter les paquets nécessaire pour l'intégration continue + dans le README-karatte
Feature: Test signatures IP 5

    Scenario Outline: Création du dossier "${nameTemplate}" de type type "${type} / ${subtype}"
        * api_v1.auth.login("user", "password")
        * def folders = api_v1.desk.draft.getPayloadMonodoc(__row, 1, {}, 1)
        * api_v1.auth.login("<username>", "<password>")
        * call read("classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature") folders

        Examples:
            | tenant      | username       | password | desktop    | mainFile!                                                                                                                                    | type  | subtype      | nameTemplate | annotation |
            | Démo simple | ws@demo-simple | a123456  | WebService | 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf'                                                                                    | ACTES | Délibération | xxx          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags-signature_pades.pdf'                                                                    | ACTES | Délibération | yyy          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | {'file': 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf', 'detached': 'classpath:files/formats/PDF_avec_tags/signature_cades.p7s'} | Auto  | Signature    | aaa          | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | {'file': 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf', 'detached': 'classpath:files/formats/PDF_avec_tags/signature_xades.xml'} | Auto  | Signature    | bbb          | démarrage  |

    Scenario Outline: Signature du dossier "${folder}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant      | username               | password | desktop   | folder | certificate | annotation |
            | Démo simple | flosserand@demo-simple | a123456  | Président | xxx    | signature   | signature  |
            | Démo simple | flosserand@demo-simple | a123456  | Président | yyy    | signature   | signature  |
            | Démo simple | flosserand@demo-simple | a123456  | Président | aaa    | signature   | signature  |
            | Démo simple | flosserand@demo-simple | a123456  | Président | bbb    | signature   | signature  |


    @x-wip
    Scenario: Vérifications des signatures du dossier "aaa"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def tenant = v5.business.api.tenant.getByName("Démo simple")
        * def desktop = v5.business.api.desktop.getByName(tenant.id, "WebService")

        # aaa (vérifications)
        * def folder = v5.business.api.folder.getByName(tenant.id, desktop.id, "finished", "aaa")
        * def details = v5.business.api.folder.getDetails(tenant.id, desktop.id, folder.id)
        * def files = v5.utils.folder.downloadFiles(tenant, details)

        * match files == [ { "PDF_avec_tags.pdf": { "path": "#string", "detached": { "PDF_avec_tags-0-signature_externe.p7s": "#string", "PDF_avec_tags-1-Frédéric Losserand.p7s": "#string" } } } ]
        # @todo: vérifier que le fichier soit le même que le fichier original
        * match utils.signature.getPdfSignatures(buildDir + files[0]["PDF_avec_tags.pdf"]["path"]) == []
        # @todo: vérifier que le fichier soit le même que le fichier original
        * utils.signature.checkPkcs7(karate.toAbsolutePath("classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf"), buildDir + "/" + files[0]["PDF_avec_tags.pdf"]["detached"]["PDF_avec_tags-1-Frédéric Losserand.p7s"], karate.toAbsolutePath(templates.certificate.default("signature")["public"]))

    @x-wip
    Scenario: Vérifications des signatures du dossier "xxx"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def tenant = v5.business.api.tenant.getByName("Démo simple")
        * def desktop = v5.business.api.desktop.getByName(tenant.id, "WebService")

        # xxx (vérifications)
        * def folder = v5.business.api.folder.getByName(tenant.id, desktop.id, "finished", "xxx")
        * def details = v5.business.api.folder.getDetails(tenant.id, desktop.id, folder.id)
        * def files = v5.utils.folder.downloadFiles(tenant, details)
        * match files == [ { "PDF_avec_tags.pdf": { "path": "#string", "detached": {} } } ]
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
        * match utils.signature.getPdfSignatures(buildDir + files[0]["PDF_avec_tags.pdf"]["path"]) == expectedSignatures

    @x-wip
    Scenario: Vérifications des signatures du dossier "yyy"
        * api_v1.auth.login("ws@demo-simple", "a123456")
        * def tenant = v5.business.api.tenant.getByName("Démo simple")
        * def desktop = v5.business.api.desktop.getByName(tenant.id, "WebService")

        # yyy (vérifications)
        * def folder = v5.business.api.folder.getByName(tenant.id, desktop.id, "finished", "yyy")
        * def details = v5.business.api.folder.getDetails(tenant.id, desktop.id, folder.id)
        * def files = v5.utils.folder.downloadFiles(tenant, details)
        * match files == [ { "PDF_avec_tags-signature_pades.pdf": { "path": "#string", "detached": {} } } ]
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
        * match utils.signature.getPdfSignatures(buildDir + files[0]["PDF_avec_tags-signature_pades.pdf"]["path"]) == expectedSignatures

#    @todo-wip
#    Scenario: Vérifications des signatures du dossier "ddd" (avec annexes, à faire à la main pour les tests)
#        * api_v1.auth.login("ws@demo-simple", "a123456")
#        * def tenant = v5.business.api.tenant.getByName("Démo simple")
#        * def desktop = v5.business.api.desktop.getByName(tenant.id, "WebService")
#
#        # xxx (vérifications)
#        * def folder = v5.business.api.folder.getByName(tenant.id, desktop.id, "finished", "ddd")
#        * def details = v5.business.api.folder.getDetails(tenant.id, desktop.id, folder.id)
#        * def files = v5.utils.folder.downloadFiles(tenant, details)
#        * match files == [ { "PDF_avec_tags.pdf": { "path": "#string", "detached": {} } } ]
