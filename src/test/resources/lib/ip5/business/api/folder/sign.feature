@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Sign folder
        # 1. Préparation
        * def publicAnnotation = ip.templates.annotations.getPublic(__arg.username, "signature", __arg.folder)
        * def privateAnnotation = ip.templates.annotations.getPrivate(__arg.username, "signature", __arg.folder)

        * __arg["certificate"] = ip.templates.certificate.default(__arg.certificate)
        # @todo: __arg["metadata"]

        # 2. Récupération et lecture du dossier
        * def tenant = ip5.business.api.tenant.getByName(__arg.tenant)
        * def desktop = ip5.business.api.desktop.getByName(tenant.id, __arg.desktop)
        * def folder = ip5.business.api.folder.getByName(tenant.id, desktop.id, "pending", __arg.folder)

        # 3. Repositionnement signature (le cas échéant)
        * if (typeof __arg.positions !== "undefined") karate.call('classpath:lib/ip5/business/api/folder/signaturePlacements.feature', { tenant: tenant, desktop: desktop, folder: folder, positions: __arg.positions })

        # 4.1. Signature du dossier - récupération des hashes des documents à signer du dossier
        * def certBase64 = ip.utils.certificate.base64Public("file://" + karate.toAbsolutePath(__arg.certificate.public))
        * url baseUrl
        * path "/api/v1/tenant/" + tenant.id + "/folder/" + folder.id + "/dataToSign"
        * param deskId = desktop.id
        * param certBase64 = certBase64
        * param customSignatureField = ''
        * header Accept = "application/json"
        * method GET
        * status 200

        # 4.2. Signature du dossier - signature des hashes
        * def signatures = ip5.utils.folder.signatures(__arg.certificate.private, response)

        # 4.2. Signature du dossier - envoi des hashes signés
        * def taskId = karate.jsonPath(folder, "$.stepList[?(@.state=='PENDING')].id")
        * url baseUrl
        * path "/api/v1/tenant/" + tenant.id + "/desk/" + desktop.id + "/folder/" + folder.id + "/task/" + taskId + "/sign"
        * header Accept = "application/json"
        * def payload =
"""
{
    "publicAnnotation": "#(publicAnnotation)",
    "privateAnnotation": "#(privateAnnotation)",
    "metadata": {},
    "certificateBase64": "#(certBase64)",
    "dataToSignHolderList": "#(signatures)"
}
"""
        * request payload
        * method PUT
        * status 200
