@legacy-bridge @soap @tests

Feature: GetHistoDossier

  Background:
    * url api.soap.url()
    * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

  Scenario Outline: ...
    Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:RechercherDossiersRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>#(type)</ns0:TypeTechnique>
            <ns0:SousType>#(sousType)</ns0:SousType>
            <ns0:Status>#(status)</ns0:Status>
        </ns0:RechercherDossiersRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
    When soap action 'RechercherDossiers'
    Then status 200
        And def dossierId = karate.xmlPath(response, '(/Envelope/Body/RechercherDossiersResponse/LogDossier/nom)[1]')

    Given header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")
    And request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:GetHistoDossierRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">#(dossierId)</ns0:GetHistoDossierRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
    When soap action 'GetHistoDossier'
    Then status 200
        And match /Envelope/Body/GetHistoDossierResponse/LogDossier/nom == noms
        And match /Envelope/Body/GetHistoDossierResponse/LogDossier/status == statuses
        And match /Envelope/Body/GetHistoDossierResponse/LogDossier/annotation == annotations
        And match karate.xmlPath(response, 'count(/Envelope/Body/GetHistoDossierResponse/LogDossier)') == count

    Examples:
        | type         | sousType       | status          | count! | noms!                                                                               | statuses!                                            | annotations!                                                                                                                                                                                                        |
        | Auto monodoc | sign avec meta | RejetSignataire | 5      | ["Service Web","Service Web","Service Web","Lukas Vermillon","Lukas Vermillon"]     | ["NonLu","NonLu","NonLu","Lu","RejetSignataire"]     | ["Création de dossier","Emission du dossier","Dossier déposé sur le bureau Vermillon pour signature","Dossier lu et prêt pour la signature","Annotation publique lvermillon@legacy-bridge (Auto_sign_avec_meta_1)"] |
        | Auto monodoc | visa avec meta | Archive         | 5      | ['Service Web', 'Service Web', 'Service Web', 'Lukas Vermillon', 'Lukas Vermillon'] | ['NonLu', 'NonLu', 'EnCoursVisa', 'Vise', 'Archive'] | ['Création de dossier', 'Emission du dossier', 'Dossier déposé sur le bureau Vermillon pour Visa', 'Annotation publique lvermillon@legacy-bridge (Auto_visa_avec_meta_1)', 'Circuit terminé, dossier archivable']   |
        | Auto monodoc | visa avec meta | RejetVisa       | 4      | ["Service Web","Service Web","Service Web","Lukas Vermillon"]                       | ["NonLu","NonLu","EnCoursVisa","RejetVisa"]          | ["Création de dossier","Emission du dossier","Dossier déposé sur le bureau Vermillon pour Visa","Annotation publique lvermillon@legacy-bridge (Auto_visa_avec_meta_2)"]                                             |
        | Auto monodoc | visa avec meta | Archive         | 5      | ['Service Web', 'Service Web', 'Service Web', 'Lukas Vermillon', 'Lukas Vermillon'] | ['NonLu', 'NonLu', 'EnCoursVisa', 'Vise', 'Archive'] | ['Création de dossier', 'Emission du dossier', 'Dossier déposé sur le bureau Vermillon pour Visa', 'Annotation publique lvermillon@legacy-bridge (Auto_visa_avec_meta_1)', 'Circuit terminé, dossier archivable']   |
        | PAdES        | cachet         | Archive         | 5      | ["Service Web","Service Web","Service Web","Lukas Vermillon","Lukas Vermillon"]     | ["NonLu","NonLu","PretCachet","CachetOK","Archive"]  | ["Création de dossier","Emission du dossier","Dossier déposé sur le bureau Vermillon pour cachet serveur.","Annotation publique lvermillon@legacy-bridge (PAdES_cachet_1)","Circuit terminé, dossier archivable"]   |
        | PAdES        | cachet         | RejetCachet     | 4      | ["Service Web","Service Web","Service Web","Lukas Vermillon"]                       | ["NonLu","NonLu","PretCachet","RejetCachet"]         | ["Création de dossier","Emission du dossier","Dossier déposé sur le bureau Vermillon pour cachet serveur.","Annotation publique lvermillon@legacy-bridge (PAdES_cachet_2)"]                                         |
