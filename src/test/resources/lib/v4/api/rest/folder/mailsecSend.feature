@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Secure mail on folder
        # 1. Préparation
        # @fixme: IIF empty
        * __arg["cc"] = [ "" ]
        * __arg["cci"] = [ "" ]

        # 2. Récupération et lecture du dossier
        * def desktop = v4.api.rest.desktop.getByName(__arg.desktop)
        * def target = v4.api.rest.folder.getByName(desktop.id, "a-traiter", __arg.folder)
        * def folder = v4.api.rest.folder.getById(desktop.id, target.id)

        # 3. Envoi du mail sécurisé sur le dossier
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + folder.id + "/mailsec"
        * header Accept = "application/json"
        # @todo: pouvoir paramétrer annexesIncluded, includeFirstPage (Joindre le bordereau de signature), attachments
        # @todo: récupératin du nom de l'utilisateur
        * def message = "Bonjour,\nVeuillez trouver ci-joint le dossier " + folder.title + ".\n\nCordialement,\nLukas Vermillon\n"
        * def payload =
"""
{
    objet: "#(folder.title)",
    bureauCourant: "#(desktop.id)",
    destinataires: "#(__arg.to)",
    destinatairesCC: "#(__arg.cc)",
    destinatairesCCI: "#(__arg.cci)",
    showpass: false,
    password: "",
    annexesIncluded: false,
    includeFirstPage: true,
    attachments: [],
    message: "#(message)"
}
"""
        * request payload
        * method POST
        * status 200
