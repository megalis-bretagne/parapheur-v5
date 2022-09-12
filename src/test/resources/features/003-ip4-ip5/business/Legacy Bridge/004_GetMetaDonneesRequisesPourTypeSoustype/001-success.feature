@legacy-bridge @ip4 @ip5 @soap @tests
Feature: GetMetaDonneesRequisesPourTypeSoustype

    Scenario Outline: Récupération des méta-données du sous-type "${type}" / "${sousType}"
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        When def rv = call read('classpath:lib/soap/requests/GetMetaDonneesRequisesPourTypeSoustype/simple.feature') params
        Then xmlstring actual = karate.xmlPath(rv.response, '/Envelope/Body/GetMetaDonneesRequisesPourTypeSoustypeResponse/MetaDonnee')
            And xmlstring expected = metaDonnees
            And match actual == expected
            And match rv.response == karate.read('classpath:lib/soap/schemas/GetMetaDonneesRequisesPourTypeSoustypeResponse/OK.xml')

        Examples:
            | type         | sousType       | metaDonnees                                                                                                                                               |
            | Auto monodoc | sign avec meta | <MetaDonnee><nomCourt>mameta_bool</nomCourt><nomLong>Ma métadonnée booléenne</nomLong><nature>BOOLEAN</nature><obligatoire>true</obligatoire></MetaDonnee> |
            | Auto monodoc | visa avec meta | <MetaDonnee><nomCourt>mameta_bool</nomCourt><nomLong>Ma métadonnée booléenne</nomLong><nature>BOOLEAN</nature><obligatoire>true</obligatoire></MetaDonnee> |

    Scenario Outline: Récupération des méta-données du sous-type "${type}" / "${sousType}"
        Given def params = karate.merge(__row, { username: "ws@legacy-bridge", password: "a123456" })
        When def rv = call read('classpath:lib/soap/requests/GetMetaDonneesRequisesPourTypeSoustype/simple.feature') params
        Then match karate.xmlPath(rv.response, 'count(/Envelope/Body/GetMetaDonneesRequisesPourTypeSoustypeResponse/MetaDonnee)') == 0
            And match rv.response == karate.read('classpath:lib/soap/schemas/GetMetaDonneesRequisesPourTypeSoustypeResponse/OK-empty.xml')

        Examples:
            | type         | sousType       |
            | Auto monodoc | sign sans meta |
            | Auto monodoc | visa sans meta |
