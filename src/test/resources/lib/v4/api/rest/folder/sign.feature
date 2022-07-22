@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Sign folder
        # 1. Préparation
        * def publicAnnotation = templates.annotations.getPublic(__arg.username, "visa", __arg.folder)
        * def privateAnnotation = templates.annotations.getPrivate(__arg.username, "visa", __arg.folder)

        * __arg["certificate"] = templates.certificate.default(__arg.certificate)

        # 2. Récupération et lecture du dossier
        * def desktop = v4.api.rest.desktop.getByName(__arg.desktop)
        * def target = v4.api.rest.folder.getByName(desktop.id, "a-traiter", __arg.folder)
        * def folder = v4.api.rest.folder.getById(desktop.id, target.id)

        # 3.1. Signature du dossier - récupération des hashes des documents à signer du dossier
        * url baseUrl
        * def certBase64 = utils.certificate.base64Public("file://" + karate.toAbsolutePath(__arg.certificate.public))
        * path "/iparapheur/proxy/alfresco/parapheur/signature/" + desktop.id + "/" + folder.id
        * header Accept = "application/json"
        * request { certificate: "#(certBase64)", index: 0 }
        * method POST

        # 3.2. Signature du dossier - signature des hashes
        * def signatures = v4.utils.folder.signatures(__arg.certificate.private, response)

        # 3.2. Signature du dossier - envoi des hashes signés
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + folder.id + "/signature"
        * header Accept = "application/json"
        * def payload =
"""
{
  "annotPub": "#(publicAnnotation)",
  "annotPriv": "#(privateAnnotation)",
  "bureauCourant": "#(desktop.id)",
  "certificate": "#(certBase64)",
  "signature": "#(signatures)"
}
"""
        * request payload
        * method POST
        * status 200
        # @todo: check response content
