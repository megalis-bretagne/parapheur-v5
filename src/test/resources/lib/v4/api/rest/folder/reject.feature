@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Reject folder
        # 1. Préparation
        * __arg["annotations"] = templates.annotations.default(__arg.username, __arg.annotation)

        # 2. Récupération et lecture du dossier
        * def desktop = v4.api.rest.desktop.getByName(__arg.desktop)
        * def target = v4.api.rest.folder.getByName(desktop.id, "a-traiter", __arg.folder)
        * def folder = v4.api.rest.folder.getById(desktop.id, target.id)

        # 3. Rejet du dossier
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + folder.id + "/rejet"
        * header Accept = "application/json"
        * request { bureauCourant: "#(desktop.id)", annotPub: "#(__arg.annotations.public)", annotPriv: "#(__arg.annotations.private)" }
        * method POST
        * status 200
