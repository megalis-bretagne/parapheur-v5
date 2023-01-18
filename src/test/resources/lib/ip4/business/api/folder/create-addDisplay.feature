@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Create folder - add PDF display
        * url baseUrl
        * path "/iparapheur/addVisuel"
        * header Accept = 'application/json'
        * multipart file file = { read: "#(__arg.file)", contentType: "#(ip.utils.file.mime(__arg.file))", filename: "#(ip.utils.file.basename(__arg.file))" }
        * multipart field browser = "notIe"
        * multipart field dossier = __arg.dossierId
        * multipart field document = __arg.documentId
        * method POST
        * status 200
        # @info: retour sous forme de chaîne de caractères
        * def document = (typeof response === "string") ? JSON.parse(response) : response
