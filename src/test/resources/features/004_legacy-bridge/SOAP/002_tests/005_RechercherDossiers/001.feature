@legacy-bridge @soap @tests
Feature: RechercherDossiers

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    @fixme-ip-5 @legacy-bridge-issue-18
    Scenario Outline: Récupération des dossiers par type "${type}", sous-type "${sousType}" et status "${status}"
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
            And match utils.xmlPathSortedUnique(response, '/Envelope/Body/RechercherDossiersResponse/LogDossier/status') == statuses
            And match karate.xmlPath(response, 'count(/Envelope/Body/RechercherDossiersResponse/LogDossier)') == expected

        Examples:
            | type!          | sousType!        | status!                 | expected! | statuses!                                                                                                     |
            | ""             | ""               | ""                      | 10        | ["Archive","EnCoursMailSecPastell","NonLu","RejetCachet","RejetMailSecPastell","RejetSignataire","RejetVisa"] |
            | "Auto monodoc" | ""               | ""                      | 6         | ["Archive","NonLu","RejetSignataire","RejetVisa"]                                                             |
            | "Auto monodoc" | "sign avec meta" | ""                      | 2         | ["NonLu","RejetSignataire"]                                                                                   |
            | "Auto monodoc" | "visa avec meta" | ""                      | 4         | ["Archive", "RejetVisa"]                                                                                      |
            | ""             | ""               | "Archive"               | 3         | ["Archive"]                                                                                                   |
            | ""             | ""               | "EnCoursMailSecPastell" | 1         | ["EnCoursMailSecPastell"]                                                                                     |
            | ""             | ""               | "NonLu"                 | 1         | ["NonLu"]                                                                                                     |
            | ""             | ""               | "RejetCachet"           | 1         | ["RejetCachet"]                                                                                               |
            | ""             | ""               | "RejetMailSecPastell"   | 1         | ["RejetMailSecPastell"]                                                                                       |
            | ""             | ""               | "RejetSignataire"       | 1         | ["RejetSignataire"]                                                                                           |
            | ""             | ""               | "RejetVisa"             | 2         | ["RejetVisa"]                                                                                                 |
            | "Auto monodoc" | "visa avec meta" | "Archive"               | 2         | ["Archive"]                                                                                                   |
            | "Auto monodoc" | "visa avec meta" | "CachetOK"              | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "EnCoursVisa"           | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "Lu"                    | 0         | []                                                                                                            |
            | "Auto monodoc" | "sign avec meta" | "NonLu"                 | 1         | ["NonLu"]                                                                                                     |
            | "Auto monodoc" | "visa avec meta" | "NonLu"                 | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "PretCachet"            | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "RejetCachet"           | 0         | []                                                                                                            |
            | "Auto monodoc" | "sign avec meta" | "RejetSignataire"       | 1         | ["RejetSignataire"]                                                                                           |
            | "Auto monodoc" | "visa avec meta" | "RejetSignataire"       | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "RejetVisa"             | 2         | ["RejetVisa"]                                                                                                 |
            | "Auto monodoc" | "visa avec meta" | "Signe"                 | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "Vise"                  | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "Rejet*"                | 3         | ["RejetSignataire","RejetVisa"]                                                                               |
            | "efiezuezozt"  | ""               | ""                      | 0         | []                                                                                                            |
            | "Auto monodoc" | "efiezuezozt"    | ""                      | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "efiezuezozt"           | 0         | []                                                                                                            |

    @fixme-ip-5
    Scenario: Récupération des dossiers par DossierID
        # 1. Récupération de la liste de DossierID pour le status "Archive"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:RechercherDossiersRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique></ns0:TypeTechnique>
            <ns0:SousType></ns0:SousType>
            <ns0:Status>Archive</ns0:Status>
        </ns0:RechercherDossiersRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'RechercherDossiers'
        Then status 200
            And def dossierIds = karate.xmlPath(response, '/Envelope/Body/RechercherDossiersResponse/LogDossier/nom')

        # 2. Récupération de la liste de dossiers par DossierID
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
        <ns0:RechercherDossiersRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:NombreDossiers>3</ns0:NombreDossiers>
            <ns0:DossierID>#(dossierIds[0])</ns0:DossierID>
            <ns0:DossierID>#(dossierIds[1])</ns0:DossierID>
            <ns0:DossierID>#(dossierIds[2])</ns0:DossierID>
        </ns0:RechercherDossiersRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'RechercherDossiers'
        Then status 200
            And match karate.xmlPath(response, '/Envelope/Body/RechercherDossiersResponse/LogDossier/nom') == dossierIds
