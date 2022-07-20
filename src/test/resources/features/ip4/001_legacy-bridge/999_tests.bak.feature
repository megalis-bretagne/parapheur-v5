@proposal @ignore @ip4
Feature: Tests IP 4
  Background:
    * def getDefaultAnnotations =
"""
function (user, step) {
    return {
        public: "Annotation publique " + user +" (" + step + ")",
        private:  "Annotation privée " + user +" (" + step + ")"
    };
}
"""
        # common.certificate.signature.public
    * def getDefaultCertificate =
"""
function (subPath) {
    return {
        public: "classpath:files/certificates/" + subPath + "/public.pem",
        private: "classpath:files/certificates/" + subPath + "/private.pem"
    };
}
"""

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
#        * call read('classpath:lib/v4/api/rest/folder/createSimple.feature') params

        # 2. Signature du dossier créé précédemment par lvermillon@legacy-bridge
        * def row =
"""
{
    username: "lvermillon@legacy-bridge",
    password: "a123456",
    desktop: "Vermillon",
    tray: "a-traiter",
    folder: "aaa",
    certificate: "signature",
    annotation: "signature depuis karate"
}
"""
        # ------------------------------------------------------------------------------------------------------------------------------------------------------
        * row["certificate"] = getDefaultCertificate(row["certificate"])
        * row["annotations"] = getDefaultAnnotations("lvermillon@legacy-bridge", row["annotation"])
        * del row["annotation"
        * karate.log(row)
        # ------------------------------------------------------------------------------------------------------------------------------------------------------
        * v4.api.rest.user.login(row.username, row.password)
        # * v4.api.rest.folder.sign(row)
        # ------------------------------------------------------------------------------------------------------------------------------------------------------
        * def desktop = v4.api.rest.desktop.getByName(row.desktop)
        * def target = v4.api.rest.folder.getByName(desktop.id, row.tray, row.folder)
        * def folder = v4.api.rest.folder.getById(desktop.id, target.id)
        * def params =
"""
{
    annotPub: #(row.annotations.public),
    annotPriv: #(row.annotations.private),
    publicCert: #(row.certificate.public),
    privateCert: #(row.certificate.private)
}
"""

        * karate.log(params)
##        * v4.api.rest.folder.sign(desktop, folder, params)
