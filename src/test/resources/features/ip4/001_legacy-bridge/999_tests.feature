@proposal @ignore @ip4
Feature: Tests IP 4

@x-wip
    Scenario: ... IP 4
        # 1. Création et envoi du dossier par ws@legacy-bridge
        * v4.api.rest.user.login("ws@legacy-bridge", "a123456")
        * def params =
"""
{
    desktop: "WebService",
    file: "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf",
    title: "aaa",
    visibility: "confidentiel",
    type: "Auto monodoc",
    sousType: "sign sans meta",
    annotPub: "Annotation publique ws@legacy-bridge (création et démarrage depuis karate)",
    annotPriv: "Annotation privée ws@legacy-bridge (création et démarrage depuis karate)",
    metadatas: {}
}
"""
        * call read('classpath:lib/v4/api/rest/folder/createSimple.feature') params

        # 2. Signature du dossier créé précédemment par lvermillon@legacy-bridge
        * v4.api.rest.user.login("lvermillon@legacy-bridge", "a123456")
        * def desktop = v4.api.rest.desktop.getByName("Vermillon")
        * def target = v4.api.rest.folder.getByName(desktop.id, "a-traiter", "aaa")
        * def folder = v4.api.rest.folder.getById(desktop.id, target.id)
        * def params =
"""
{
    annotPub: "Annotation publique lvermillon@legacy-bridge (signature depuis karate)",
    annotPriv: "Annotation privée lvermillon@legacy-bridge (signature depuis karate)",
    publicCert: "classpath:files/certificates/signature/public.pem",
    privateCert: "classpath:files/certificates/signature/private.pem",
}
"""
        * v4.api.rest.folder.sign(desktop, folder, params)
