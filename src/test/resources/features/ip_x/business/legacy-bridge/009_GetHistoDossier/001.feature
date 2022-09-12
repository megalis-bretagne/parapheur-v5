@legacy-bridge @ip4 @ip5 @soap @tests @fixme-ip

Feature: GetHistoDossier - Interrogation d'histogramme de dossier

    Background:
        * def defaults = { username: "ws@legacy-bridge", password: "a123456" }

    Scenario: Récupération du journal des événements du dossier "Auto_sign_avec_meta_1"
        Given def params = { type: "Auto monodoc", sousType: "sign avec meta", status: "RejetSignataire", name: "Auto_sign_avec_meta_1" }
            And def expected =
"""
[
    { "nom":"Service Web", "status":"NonLu", "annotation":"Création de dossier" },
    { "nom":"Service Web", "status":"NonLu", "annotation":"Annotation publique ws@legacy-bridge (démarrage du dossier Auto_sign_avec_meta_1)" },
    { "nom":"Service Web", "status":"NonLu", "annotation":"Dossier déposé sur le bureau Vermillon pour signature" },
    { "nom":"Lukas Vermillon", "status":"Lu", "annotation":"Dossier lu et prêt pour la signature" },
    { "nom":"Lukas Vermillon", "status":"RejetSignataire", "annotation":"Annotation publique lvermillon@legacy-bridge (rejet du dossier Auto_sign_avec_meta_1)" }
]
"""
        When def rv = call read('classpath:lib/soap/requests/GetHistoDossier/getJsonHistoDossier.feature') karate.merge(params, defaults)
        Then match rv.jsonHistoDossier == expected

    Scenario: Récupération du journal des événements du dossier "Auto_visa_avec_meta_1"
        Given def params = { type: "Auto monodoc", sousType: "visa avec meta", status: "Archive", name: "Auto_visa_avec_meta_1" }
            And def expected =
"""
[
    { "nom":"Service Web", "status":"NonLu", "annotation":"Création de dossier" },
    { "nom":"Service Web", "status":"NonLu", "annotation":"Annotation publique ws@legacy-bridge (démarrage du dossier Auto_visa_avec_meta_1)" },
    { "nom":"Service Web", "status":"EnCoursVisa", "annotation":"Dossier déposé sur le bureau Vermillon pour Visa" },
    { "nom":"Lukas Vermillon", "status":"Vise", "annotation":"Annotation publique lvermillon@legacy-bridge (visa du dossier Auto_visa_avec_meta_1)" },
    { "nom":"Lukas Vermillon", "status":"Archive", "annotation":"Circuit terminé, dossier archivable" }
]
"""
        When def rv = call read('classpath:lib/soap/requests/GetHistoDossier/getJsonHistoDossier.feature') karate.merge(params, defaults)
        Then match rv.jsonHistoDossier == expected

    Scenario: Récupération du journal des événements du dossier "Auto_visa_avec_meta_2"
        Given def params = { type: "Auto monodoc", sousType: "visa avec meta", status: "RejetVisa", name: "Auto_visa_avec_meta_2" }
            And def expected =
"""
[
    {"nom":"Service Web","status":"NonLu","annotation":"Création de dossier"},
    {"nom":"Service Web","status":"NonLu","annotation":"Annotation publique ws@legacy-bridge (démarrage du dossier Auto_visa_avec_meta_2)"},
    {"nom":"Service Web","status":"EnCoursVisa","annotation":"Dossier déposé sur le bureau Vermillon pour Visa"},
    {"nom":"Lukas Vermillon","status":"RejetVisa","annotation":"Annotation publique lvermillon@legacy-bridge (rejet du dossier Auto_visa_avec_meta_2)"}]
"""
        When def rv = call read('classpath:lib/soap/requests/GetHistoDossier/getJsonHistoDossier.feature') karate.merge(params, defaults)
        Then match rv.jsonHistoDossier == expected

    Scenario: Récupération du journal des événements du dossier "PAdES_cachet_1"
        Given def params = { type: "PAdES", sousType: "cachet", status: "Archive", name: "PAdES_cachet_1" }
            And def expected =
"""
[
    {"nom":"Service Web","status":"NonLu","annotation":"Création de dossier"},
    {"nom":"Service Web","status":"NonLu","annotation":"Annotation publique ws@legacy-bridge (démarrage du dossier PAdES_cachet_1)"},
    {"nom":"Service Web","status":"PretCachet","annotation":"Dossier déposé sur le bureau Vermillon pour cachet serveur."},
    {"nom":"Lukas Vermillon","status":"CachetOK","annotation":"Annotation publique lvermillon@legacy-bridge (cachet serveur du dossier PAdES_cachet_1)"},
    {"nom":"Lukas Vermillon","status":"Archive","annotation":"Circuit terminé, dossier archivable"}
]
"""
        When def rv = call read('classpath:lib/soap/requests/GetHistoDossier/getJsonHistoDossier.feature') karate.merge(params, defaults)
        Then match rv.jsonHistoDossier == expected

    Scenario: Récupération du journal des événements du dossier "PAdES_cachet_2"
        Given def params = { type: "PAdES", sousType: "cachet", status: "RejetCachet", name: "PAdES_cachet_2" }
            And def expected =
"""
[
    {"nom":"Service Web","status":"NonLu","annotation":"Création de dossier"},
    {"nom":"Service Web","status":"NonLu","annotation":"Annotation publique ws@legacy-bridge (démarrage du dossier PAdES_cachet_2)"},
    {"nom":"Service Web","status":"PretCachet","annotation":"Dossier déposé sur le bureau Vermillon pour cachet serveur."},
    {"nom":"Lukas Vermillon","status":"RejetCachet","annotation":"Annotation publique lvermillon@legacy-bridge (rejet du dossier PAdES_cachet_2)"}
]
"""
        When def rv = call read('classpath:lib/soap/requests/GetHistoDossier/getJsonHistoDossier.feature') karate.merge(params, defaults)
        Then match rv.jsonHistoDossier == expected
