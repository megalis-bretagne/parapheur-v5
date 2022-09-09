@business @metadonnees @folder @ignore
Feature: ...

    Scenario: ...
        * def defaults =
"""
{
    tenant: 'Métadonnées',
    desktop: 'WebService',
    type: 'PAdES',
    mainFile: 'classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf',
    annotation: 'démarrage',
    username: "ws-meta",
    password: "a123456"
}
"""
        * def params = karate.merge(defaults, __arg)
        * params["nameTemplate"] = params.mode + " - " + params.action + " - " + params.subtype

        * api_v1.auth.login('user', 'password')
        * def folders = api_v1.desk.draft.getPayloadMonodoc(params, 1, {}, 1)
        * api_v1.auth.login(params.username, params.password)
        * def result = call read('classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature') folders
