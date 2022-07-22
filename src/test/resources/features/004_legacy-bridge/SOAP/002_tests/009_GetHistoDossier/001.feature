@legacy-bridge @soap @tests @fixme-ip

Feature: GetHistoDossier - Interrogation d'histogramme de dossier

    # @todo: faire une fonction (feature, l'appeler plusieurs fois) et comparer du XML
    # @todo: karate.soapBaseUrl= (pour IP 4)
    Scenario Outline: Récupération du journal des événements du dossier "${name}" (type "${type}", sous-type "${sousType}", status "${status}")
        # 1. Récupération d'un dossier en particulier
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        When def rv = call read('classpath:lib/soap/requests/RechercherDossiers/simple.feature') params
        Then def dossiersIds = karate.xmlPath(rv.response, '/Envelope/Body/RechercherDossiersResponse/LogDossier/nom');
            # "Filtrage" des résultats
            And def dossierId = api.soap.dossier.filterDossiersIdsByName(dossiersIds, '<name>', { username: "ws@legacy-bridge", password: "a123456" })

        # 2. Récupération du journal des événements de ce dossier
        Given def params = { dossierId: "#(dossierId)", username: "ws@legacy-bridge", password: "a123456" }
        When def rv = call read('classpath:lib/soap/requests/GetHistoDossier/simple.feature') params
        Then match rv.response /Envelope/Body/GetHistoDossierResponse/LogDossier/nom == noms
            And match rv.response /Envelope/Body/GetHistoDossierResponse/LogDossier/status == statuses
            And match rv.response /Envelope/Body/GetHistoDossierResponse/LogDossier/annotation == annotations
            And match rv.response == karate.read('classpath:lib/soap/schemas/GetHistoDossierResponse/OK.xml')

    Examples:
        | type         | sousType       | status          | name                  | count! | noms!                                                                               | statuses!                                            | annotations!                                                                                                                                                                                                                                                                                       |
        | Auto monodoc | sign avec meta | RejetSignataire | Auto_sign_avec_meta_1 | 5      | ["Service Web","Service Web","Service Web","Lukas Vermillon","Lukas Vermillon"]     | ["NonLu","NonLu","NonLu","Lu","RejetSignataire"]     | ["Création de dossier","Annotation publique ws@legacy-bridge (démarrage du dossier Auto_sign_avec_meta_1)","Dossier déposé sur le bureau Vermillon pour signature","Dossier lu et prêt pour la signature","Annotation publique lvermillon@legacy-bridge (rejet du dossier Auto_sign_avec_meta_1)"] |
        | Auto monodoc | visa avec meta | Archive         | Auto_visa_avec_meta_1 | 5      | ['Service Web', 'Service Web', 'Service Web', 'Lukas Vermillon', 'Lukas Vermillon'] | ['NonLu', 'NonLu', 'EnCoursVisa', 'Vise', 'Archive'] | ["Création de dossier","Annotation publique ws@legacy-bridge (démarrage du dossier Auto_visa_avec_meta_1)","Dossier déposé sur le bureau Vermillon pour Visa","Annotation publique lvermillon@legacy-bridge (visa du dossier Auto_visa_avec_meta_1)","Circuit terminé, dossier archivable"]        |
        | Auto monodoc | visa avec meta | RejetVisa       | Auto_visa_avec_meta_2 | 4      | ["Service Web","Service Web","Service Web","Lukas Vermillon"]                       | ["NonLu","NonLu","EnCoursVisa","RejetVisa"]          | ["Création de dossier","Annotation publique ws@legacy-bridge (démarrage du dossier Auto_visa_avec_meta_2)","Dossier déposé sur le bureau Vermillon pour Visa","Annotation publique lvermillon@legacy-bridge (rejet du dossier Auto_visa_avec_meta_2)"]                                             |
        | PAdES        | cachet         | Archive         | PAdES_cachet_1        | 5      | ["Service Web","Service Web","Service Web","Lukas Vermillon","Lukas Vermillon"]     | ["NonLu","NonLu","PretCachet","CachetOK","Archive"]  | ["Création de dossier","Annotation publique ws@legacy-bridge (démarrage du dossier PAdES_cachet_1)","Dossier déposé sur le bureau Vermillon pour cachet serveur.","Annotation publique lvermillon@legacy-bridge (cachet serveur du dossier PAdES_cachet_1)","Circuit terminé, dossier archivable"] |
        | PAdES        | cachet         | RejetCachet     | PAdES_cachet_2        | 4      | ["Service Web","Service Web","Service Web","Lukas Vermillon"]                       | ["NonLu","NonLu","PretCachet","RejetCachet"]         | ["Création de dossier","Annotation publique ws@legacy-bridge (démarrage du dossier PAdES_cachet_2)","Dossier déposé sur le bureau Vermillon pour cachet serveur.","Annotation publique lvermillon@legacy-bridge (rejet du dossier PAdES_cachet_2)"]                                                |
