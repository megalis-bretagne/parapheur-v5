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

        Given configure cookies = null
            And url api.soap.url()
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
