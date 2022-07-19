@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Create simple folder
        * def desktop = v4.api.rest.desktop.getByName(__arg.desktop)

        * def fillMetadatas =
"""
function (metadatas) {
    var idx, keys = Object.keys(metadatas), result = {}, rv;
    for (idx=0;idx<keys.length;idx++) {
        metadata = v4.api.rest.metadata.getById(keys[idx]);
        result["cu:"+keys[idx]] = {
            realName: metadata.name,
            //editable: "false",
            isAlphaOrdered: metadata.isAlphaOrdered,
            id: "cu:" + keys[idx],
            type: metadata.type,
            //mandatory:true,
            value: metadatas[keys[idx]]
        };
    }
    return result;
}
"""
        # 1. Récupération de l'id
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers"
        * header Accept = 'application/json'
        * def payload =
"""
{
    bureauCourant: "#(desktop.id)"
}
"""
        * request payload
        * method POST
        * status 200
        * copy dossierId = response.id

        # 2. Ajout du document principal
        * url baseUrl
        * path "/iparapheur/addDocument"
        * header Accept = 'application/json'
        * multipart file file = { read: "#(__arg.file)", contentType: "#(utils.file.mime(__arg.file))", filename: "#(utils.file.basename(__arg.file))" }
        * multipart field browser = "notIe"
        * multipart field dossier = dossierId
        * multipart field isMainDocument = "true"
        * multipart field reloadMainDocument = "false"
        * method POST
        * status 200
        # @info: retour sous forme de chaîne de caractères
        * def document = (typeof response === "string") ? JSON.parse(response) : response

        # 3. Ajout des données du dossier
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + dossierId + "?bureauCourant=" + desktop.id
        * header Accept = 'application/json'
        * def payload =
"""
{
    "title": "#(__arg.title)",
    "nomTdT": null,
    "includeAnnexes": null,
    "locked": null,
    "readingMandatory": null,
    "acteursVariables": [],
    "dateEmission": #(Date.now()),
    "visibility": "#(__arg.visibility)",
    "isRead": false,
    "actionDemandee": "VISA",
    "status": null,
    "documents": [
        {
            "name": "#(utils.file.basename(__arg.file))",
            "isMainDocument": true,
            "state": "",
            "canDelete": true,
            "downloadUrl": "#(document.downloadUrl)",
            "id": "#(document.success)",
            "isLocked": #(document.isLocked),
            "isProtected": #(document.isProtected),
            "visuelPdfUrl": null
        }
    ],
    "id": "#(dossierId)",
    "isSignPapier": false,
    "dateLimite": null,
    "hasRead": false,
    "isXemEnabled": false,
    "actions": [
        "SUPPRESSION",
        "EDITION"
    ],
    "banetteName": "Dossiers à transmettre",
    "type": "#(__arg.type)",
    "canAdd": true,
    "protocole": null,
    "metadatas": {},
    "xPathSignature": null,
    "sousType": "#(__arg.sousType)",
    "bureauName": "#(__arg.desktop)",
    "isSent": false
}
"""
        * payload["metadatas"] = fillMetadatas(__arg.metadatas)
        * request payload
        * method PUT
        * status 200

        # 4. Envoi du dossier dans le circuit
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + dossierId + "/visa"
        * header Accept = 'application/json'
        * def payload =
"""
{
    bureauCourant: "#(desktop.id)",
    annotPub: "#(__arg.annotPub)",
    annotPriv: "#(__arg.annotPriv)"
}
"""
        * request payload
        * method POST
        * status 200
