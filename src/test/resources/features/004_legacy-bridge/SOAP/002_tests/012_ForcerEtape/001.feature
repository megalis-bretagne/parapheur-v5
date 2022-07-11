@legacy-bridge @soap @tests

Feature: ForcerEtape

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario Outline: Création du dossier "${nom}" et forçage de l'étape de visa (${codeTransition})
        # 1. Création d'un dossier
        * def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        * def rv = call read('classpath:lib/soap/requests/CreerDossier/simple_success.feature') params
        * def dossierId = rv.dossierId

        * pause(5)

        # 2. Forçage de l'étape
        * def params =
"""
{
    username: "lvermillon@legacy-bridge",
    password: "a123456",
    dossierId: "#(dossierId)",
    codeTransition: "<codeTransition>"
}
"""
        * call read('classpath:lib/soap/ForcerEtape/success.feature') params

        Examples:
            | type         | sousType       | nom                          | documentPrincipal                                       | visibilite   | dateLimite | codeTransition |
            | Auto monodoc | visa sans meta | SOAP forçage de l'étape (OK) | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | OK             |
            | Auto monodoc | visa sans meta | SOAP forçage de l'étape (KO) | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | CONFIDENTIEL |            | KO             |
