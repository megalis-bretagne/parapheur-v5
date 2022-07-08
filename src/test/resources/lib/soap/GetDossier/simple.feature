@karate-function @ignore
Feature: SOAP GetDossier lib
    # @todo: utiliser cette feature dans les tests
    Scenario: Récupération d'un dossier
        Given url api.soap.url()
            And header Authorization = api.soap.user.authorization(username, password)
            And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(dossierId)</ns0:GetDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetDossier'
        Then status 200
