@legacy-bridge @soap @tests
Feature: GetMetaDonneesRequisesPourTypeSoustype

    Background:
        * url api.soap.url()
        * header Authorization = api.soap.user.authorization("ws@legacy-bridge", "a123456")

    Scenario Outline: Récupération des méta-données du sous-type "${type}" / "${sousType}"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
      <ns0:GetMetaDonneesRequisesPourTypeSoustypeRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>#(type)</ns0:TypeTechnique>
            <ns0:SousType>#(sousType)</ns0:SousType>
      </ns0:GetMetaDonneesRequisesPourTypeSoustypeRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetMetaDonneesRequisesPourTypeSoustype'
        Then status 200
            And xmlstring actual = karate.xmlPath(response, '/Envelope/Body/GetMetaDonneesRequisesPourTypeSoustypeResponse/MetaDonnee')
            And xmlstring expected = metaDonnees
            And match actual == expected
            And match response == karate.read('classpath:lib/soap/schemas/GetMetaDonneesRequisesPourTypeSoustypeResponse/OK.xml')

        Examples:
            | type         | sousType       | metaDonnees                                                                                                                                               |
            | Auto monodoc | sign avec meta | <MetaDonnee><nomCourt>mameta_bool</nomCourt><nomLong>Ma métadonnée booléenne</nomLong><nature>BOOLEAN</nature><obligatoire>true</obligatoire></MetaDonnee> |
            | Auto monodoc | visa avec meta | <MetaDonnee><nomCourt>mameta_bool</nomCourt><nomLong>Ma métadonnée booléenne</nomLong><nature>BOOLEAN</nature><obligatoire>true</obligatoire></MetaDonnee> |

    Scenario Outline: Récupération des méta-données du sous-type "${type}" / "${sousType}"
        Given request
"""
<?xml version='1.0' encoding='utf-8'?>
<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">
    <soap-env:Body>
      <ns0:GetMetaDonneesRequisesPourTypeSoustypeRequest xmlns:ns0="http://www.adullact.org/spring-ws/iparapheur/1.0">
            <ns0:TypeTechnique>#(type)</ns0:TypeTechnique>
            <ns0:SousType>#(sousType)</ns0:SousType>
      </ns0:GetMetaDonneesRequisesPourTypeSoustypeRequest>
    </soap-env:Body>
</soap-env:Envelope>
"""
        When soap action 'GetMetaDonneesRequisesPourTypeSoustype'
        Then status 200
            And match karate.xmlPath(response, 'count(/Envelope/Body/GetMetaDonneesRequisesPourTypeSoustypeResponse/MetaDonnee)') == 0
            And match response == karate.read('classpath:lib/soap/schemas/GetMetaDonneesRequisesPourTypeSoustypeResponse/OK-empty.xml')

        Examples:
            | type         | sousType       |
            | Auto monodoc | sign sans meta |
            | Auto monodoc | visa sans meta |
