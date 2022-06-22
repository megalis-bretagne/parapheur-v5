@legacy-bridge @soap @tests
Feature: RechercherDossiers

    # @todo: avec les autres états (cf. 6.1. Statuts de dossiers possibles)
    # @todo: avec une liste d'identifiants
    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    @fixme-ip-4 @fixme-ip-5 @todo-karate
    Scenario Outline: Récupération des dossiers "${type} / ${sousType}" ayant le statut "${status}"
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
#            And print 'response: ', response
            # @todo
            # And api.soap.schema.match(response, 'classpath:lib/soap/schemas/RechercherDossiersResponse/OK.xml')
            And match karate.xmlPath(response, 'count(/Envelope/Body/RechercherDossiersResponse/LogDossier)') == expected

        Examples:
            | type           | sousType       | status    | expected! |
            | Auto monodoc | visa avec meta | Archive   | 2         |
            | Auto monodoc | visa avec meta | RejetVisa | 2         |
            # @fixme: en IP 4, "Auto" fonctionnait
            | Auto monodoc | visa avec meta | Rejet*    | 2         |
