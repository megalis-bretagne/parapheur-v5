@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Visa on folder
        # 1. Préparation
        * def publicAnnotation = ip.templates.annotations.getPublic(__arg.username, "visa", __arg.folder)
        * def privateAnnotation = ip.templates.annotations.getPrivate(__arg.username, "visa", __arg.folder)

        # @todo: __arg["metadata"]

        # 2. Récupération et lecture du dossier
        * def tenant = ip5.business.api.tenant.getByName(__arg.tenant)
        * def desktop = ip5.business.api.desktop.getByName(tenant.id, __arg.desktop)
        * def folder = ip5.business.api.folder.getByName(tenant.id, desktop.id, "pending", __arg.folder)

        # 3. Visa sur le dossier
        * def taskId = karate.jsonPath(folder, "$.stepList[?(@.state=='PENDING')].id")
        * url baseUrl
        * path "/api/v1/tenant/" + tenant.id + "/desk/" + desktop.id + "/folder/" + folder.id + "/task/" + taskId + "/visa"
        * header Accept = "application/json"
        # @todo: metadata -> defaults + à reporter dans les autres actons business
        * def payload =
"""
{
"publicAnnotation": "#(publicAnnotation)",
"privateAnnotation": "#(privateAnnotation)",
"metadata": "#(metadata)"
}
"""
        * request payload
        * method PUT
        * status 200
