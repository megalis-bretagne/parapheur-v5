@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Create folder - add main document
        * url baseUrl
        * path "/iparapheur/addDocument"
        * header Accept = 'application/json'
        * multipart file file = { read: "#(__arg.file)", contentType: "#(utils.file.mime(__arg.file))", filename: "#(utils.file.basename(__arg.file))" }
        * multipart field browser = "notIe"
        * multipart field dossier = __arg.dossierId
        * multipart field isMainDocument = "true"
        * multipart field reloadMainDocument = "false"
        * method POST
        * status 200
        # @info: retour sous forme de chaîne de caractères
        * def document = (typeof response === "string") ? JSON.parse(response) : response
