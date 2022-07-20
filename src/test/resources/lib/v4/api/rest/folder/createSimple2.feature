@karate-function @ignore
Feature: IP v.4 REST folder lib

    # @todo: annexes, visuel PDF
    Scenario: Create folder
        * def defaults = { metadatas: {}, visibility: "confidentiel" }
        * __arg["annotations"] = templates.annotations.default(__arg.username, __arg.annotation)
        * def row = karate.merge(defaults, __arg)

        * def desktop = v4.api.rest.desktop.getByName(row.desktop)

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

        # 2. Ajout des documents principaux
        * def addDocuments =
"""
function(dossierId, files) {
    var idx, result = [], rv;
    for (idx=0;idx<files.length;idx++) {
        rv = karate.call('classpath:lib/v4/api/rest/folder/createSimple2-addDocument.feature', { dossierId: dossierId, file: files[idx] });
        result.push({
            "name": utils.file.basename(files[idx]),
            "isMainDocument": true,
            "state": "",
            "canDelete": true,
            "downloadUrl": rv.document.downloadUrl,
            "id": rv.document.success,
            "isLocked": rv.document.isLocked,
            "isProtected": rv.document.isProtected,
            "visuelPdfUrl": null
        });
    }
    return result;
}
"""
        * def documents = addDocuments(dossierId, files)

        # 3. Ajout des données du dossier
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + dossierId + "?bureauCourant=" + desktop.id
        * header Accept = 'application/json'
        * def payload =
"""
{
    "title": "#(row.title)",
    "nomTdT": null,
    "includeAnnexes": null,
    "locked": null,
    "readingMandatory": null,
    "acteursVariables": [],
    "dateEmission": "#(Date.now())",
    "visibility": "#(row.visibility)",
    "isRead": false,
    "actionDemandee": "VISA",
    "status": null,
    "documents": #(documents),
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
    "type": "#(row.type)",
    "canAdd": true,
    "protocole": null,
    "metadatas": {},
    "xPathSignature": null,
    "sousType": "#(row.subtype)",
    "bureauName": "#(row.desktop)",
    "isSent": false
}
"""
        * payload["metadatas"] = fillMetadatas(row.metadatas)
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
    annotPub: "#(row.annotations.public)",
    annotPriv: "#(row.annotations.private)"
}
"""
        * request payload
        * method POST
        * status 200
