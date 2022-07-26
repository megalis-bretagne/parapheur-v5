@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Seal folder
        # 1. Préparation
        * def publicAnnotation = templates.annotations.getPublic(__arg.username, "cachet serveur", __arg.folder)
        * def privateAnnotation = templates.annotations.getPrivate(__arg.username, "cachet serveur", __arg.folder)

        # 2. Récupération et lecture du dossier
        * def desktop = v4.business.api.desktop.getByName(__arg.desktop)
        * def target = v4.business.api.folder.getByName(desktop.id, "a-traiter", __arg.folder)
        * def folder = v4.business.api.folder.getById(desktop.id, target.id)

        # 3. Visa sur le dossier
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + folder.id + "/seal"
        * header Accept = "application/json"
        * request { bureauCourant: "#(desktop.id)", annotPub: "#(publicAnnotation)", annotPriv: "#(privateAnnotation)" }
        * method POST
        * status 200
