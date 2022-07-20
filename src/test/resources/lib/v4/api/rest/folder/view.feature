@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: View folder
        # @todo: paramétrer "a-traiter"
        # @todo: function javascript qui appelle cette feature
        # 1. Récupération et lecture du dossier
        * def desktop = v4.api.rest.desktop.getByName(__arg.desktop)
        * def target = v4.api.rest.folder.getByName(desktop.id, "a-traiter", __arg.folder)
        * def folder = v4.api.rest.folder.getById(desktop.id, target.id)
