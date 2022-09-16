@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Seal folder
        # 1. Préparation
        * def publicAnnotation = ip.templates.annotations.getPublic(__arg.username, "cachet serveur", __arg.folder)
        * def privateAnnotation = ip.templates.annotations.getPrivate(__arg.username, "cachet serveur", __arg.folder)

        # @todo: __arg["metadata"]

        # 2. Récupération et lecture du dossier
        * def tenant = ip5.business.api.tenant.getByName(__arg.tenant)
        * def desktop = ip5.business.api.desktop.getByName(tenant.id, __arg.desktop)
        * def folder = ip5.business.api.folder.getByName(tenant.id, desktop.id, "pending", __arg.folder)

        # 3. Repositionnement de l'image du cachet (le cas échéant)
        * if (typeof __arg.positions !== "undefined") karate.call('classpath:lib/ip5/business/api/folder/signaturePlacements.feature', { tenant: tenant, desktop: desktop, folder: folder, positions: __arg.positions })

        # 4.2. Signature du dossier - envoi des hashes signés
        * def taskId = karate.jsonPath(folder, "$.stepList[?(@.state=='PENDING')].id")
        * url baseUrl
        * path "/api/v1/tenant/" + tenant.id + "/desk/" + desktop.id + "/folder/" + folder.id + "/task/" + taskId + "/seal"
        * header Accept = "application/json"
        * def payload =
"""
{
"publicAnnotation": "#(publicAnnotation)",
"privateAnnotation": "#(privateAnnotation)",
"metadata": {}
}
"""
        * request payload
        * method PUT
        * status 200
