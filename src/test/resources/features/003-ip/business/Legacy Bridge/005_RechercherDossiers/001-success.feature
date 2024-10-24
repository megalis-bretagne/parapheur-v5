@legacy-bridge @ip4 @ip5 @soap @tests
Feature: RechercherDossiers

    Scenario Outline: Récupération des dossiers par type "${type}", sous-type "${sousType}" et status "${status}"
        * if (expected == 0) karate.set("schema", "OK-empty.xml")
        * if (expected == 1) karate.set("schema", "OK-1-result.xml")
        * if (expected > 1) karate.set("schema", "OK.xml")

        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "Ilenfautpeupouretreheureux" })
        When def rv = call read('classpath:lib/ip/api/soap/requests/RechercherDossiers/simple.feature') params
            And match ip.utils.xmlPathSortedUnique(rv.response, '/Envelope/Body/RechercherDossiersResponse/LogDossier/status') == statuses
            And match karate.xmlPath(rv.response, 'count(/Envelope/Body/RechercherDossiersResponse/LogDossier)') == expected
            And match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/RechercherDossiersResponse/' + schema)

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
            | "efiezuezozt"  | ""               | ""                      | 0         | []                                                                                                            |
            | "Auto monodoc" | "efiezuezozt"    | ""                      | 0         | []                                                                                                            |
            | "Auto monodoc" | "visa avec meta" | "efiezuezozt"           | 0         | []                                                                                                            |

        @fixme-ip4 @fixme-ip5
        # @info: bug karate, on doit pour l'instant dédoubler le test, si on met un tag dans des examples, aucun des autres exemples ne sera joué
        Scenario Outline: Récupération des dossiers par type "${type}", sous-type "${sousType}" et status "${status}"
            * if (expected == 0) karate.set("schema", "OK-empty.xml")
            * if (expected == 1) karate.set("schema", "OK-1-result.xml")
            * if (expected > 1) karate.set("schema", "OK.xml")

            Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "Ilenfautpeupouretreheureux" })
            When def rv = call read('classpath:lib/ip/api/soap/requests/RechercherDossiers/simple.feature') params
            And match ip.utils.xmlPathSortedUnique(rv.response, '/Envelope/Body/RechercherDossiersResponse/LogDossier/status') == statuses
            And match karate.xmlPath(rv.response, 'count(/Envelope/Body/RechercherDossiersResponse/LogDossier)') == expected
            And match rv.response == karate.read('classpath:lib/ip/api/soap/schemas/RechercherDossiersResponse/' + schema)

            Examples:
                | type!          | sousType!        | status!  | expected! | statuses!     |
                | "Auto monodoc" | "visa avec meta" | "Rejet*" | 2         | ["RejetVisa"] |

    Scenario: Récupération des dossiers par DossierID
        # 1. Récupération de la liste de DossierID pour le status "Archive"
        Given def params = { status: "Archive", username: "ws@legacy-bridge", password: "Ilenfautpeupouretreheureux" }
        When def rv = call read('classpath:lib/ip/api/soap/requests/RechercherDossiers/simple.feature') params
        Then def dossierIds = karate.xmlPath(rv.response, '/Envelope/Body/RechercherDossiersResponse/LogDossier/nom')

        # 2. Récupération de la liste de dossiers par DossierID
        Given configure cookies = null
            And url ip.api.soap.url()
            And header Authorization = ip.api.soap.user.authorization("ws@legacy-bridge", "Ilenfautpeupouretreheureux")
            And request
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
            And match response == karate.read('classpath:lib/ip/api/soap/schemas/RechercherDossiersResponse/OK.xml')
