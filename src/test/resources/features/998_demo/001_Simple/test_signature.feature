@wip
Feature: Test signature IP 5

    Scenario: Signature
        * api_v1.auth.login("flosserand@demo-simple", "a123456")
        * def arg = { username: "flosserand@demo-simple", password: "a123456", tenant: "Démo simple", desktop: "Président", folder: "xxx", certificate: "signature", annotation: "signature" }

        # ------------------------------------------------------------------------------------------------------------------------------------------------------

        # 1. Préparation
        * def publicAnnotation = templates.annotations.getPublic(arg.username, "signature", arg.folder)
        * def privateAnnotation = templates.annotations.getPrivate(arg.username, "signature", arg.folder)

        * arg["certificate"] = templates.certificate.default(arg.certificate)

        # 2. Récupération et lecture du dossier
        * def tenant = v5.api.rest.tenant.getByName(arg.tenant)
        * def desktop = v5.api.rest.desktop.getByName(tenant.id, arg.desktop)
        * def folder = v5.api.rest.folder.getByName(tenant.id, desktop.id, "pending", arg.folder)

        # 3.1. Signature du dossier - récupération des hashes des documents à signer du dossier
        * url baseUrl
        * def certBase64 = utils.certificate.base64Public("file://" + karate.toAbsolutePath(arg.certificate.public))
        * path "/api/v1/tenant/" + tenant.id + "/folder/" + folder.id + "/dataToSign"
        * param deskId = desktop.id
        * param certBase64 = certBase64
        * header Accept = "application/json"
        * method GET
        * status 200

        # 3.2. Signature du dossier - signature des hashes
#        * karate.log(response)
        * def signatures = v5.utils.folder.signatures(arg.certificate.private, response)
        * karate.log(signatures)

        # 3.2. Signature du dossier - envoi des hashes signés
        * def taskId = karate.jsonPath(folder, "$.stepList[?(@.state=='PENDING')].id")
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
        * karate.log(payload)
        * request payload
        * method PUT
        * status 200
