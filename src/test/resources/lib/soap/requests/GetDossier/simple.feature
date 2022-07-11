@karate-function @ignore
Feature: SOAP GetDossier lib

    Scenario: Récupération d'un dossier
        * def defaults =
"""
{
    dossierId: null,
    username: null,
    password: null
}
"""
        * def args = karate.merge(defaults, __arg)

        Given url api.soap.url()
            And header Authorization = api.soap.user.authorization(args.username, args.password)
            And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(args.dossierId)</ns0:GetDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetDossier'
        Then status 200
        * def cleanedResponse = response
        * remove cleanedResponse /Envelope/Body/GetDossierResponse/DateLimite/@nil
        * remove cleanedResponse /Envelope/Body/GetDossierResponse/DateLimite/@xsi
        * remove cleanedResponse /Envelope/Body/GetDossierResponse/DocumentsAnnexes/DocAnnexe/fichier/@contentType
        * remove cleanedResponse //@contentType
        And match cleanedResponse == karate.read('classpath:lib/soap/schemas/GetDossierResponse/OK.xml')
