@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: View folder
        # 1. Récupération et lecture du dossier
        * __arg["tray"] = (typeof __arg["tray"] === "undefined") ? "a-traiter" : __arg["tray"]
        * def desktop = v4.api.rest.desktop.getByName(__arg.desktop)
        * def target = v4.api.rest.folder.getByName(desktop.id, __arg.tray., __arg.folder)
        * def folder = v4.api.rest.folder.getById(desktop.id, target.id)
