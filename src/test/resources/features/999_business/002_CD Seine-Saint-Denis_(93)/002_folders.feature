@business-cd93 @draft-business @proposal @wip
Feature: Création de dossiers brouillon pour le paramétrage métier CD Seine-Saint-Denis (93)

    # @todo: envoyer les métadonnées pour le type HELIOS
    Scenario Outline: Create ${count} "${subtype}" draft folders ${withOrWithout} annex
        * def params =
"""
{
    tenant: '<tenant>',
    desktop: '<desktop>',
    type: '<type>',
    subtype: '<subtype>',
    mainFile: '<mainFile>',
    nameTemplate: '<nameTemplate>'
}
"""
        # @todo: ajout metadata GdaBjType pour HELIOS (normalement obligatoire)
        * api_v1.auth.login('user', 'password')
        * def folders = api_v1.desk.draft.getPayloadMonodoc(params, <count>)
        * api_v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders
# {"variableDesksIds":{},"metadata":{"GdaBjType":"1"},"typeId":"606c876d-62d9-4cbf-b7da-9ebabd640745","subtypeId":"da60927b-c265-4ac1-8b95-6e38aaafed7f","name":"xxx","visibility":"Confidentiel","limitDate":null,"paperSignable":true}
      Examples:
          | tenant                    | username | password | desktop    | type          | subtype                 | mainFile                                 | nameTemplate                                      | count | withOrWithout |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - PAdES - Monodoc - sans annexe - %counter% | 10   | without       |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - PAdES - Monodoc - avec annexe - %counter% | 10   | with          |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - sans annexe - %counter%        | 10   | without       |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - avec annexe - %counter%        | 10   | with          |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - CAdES - Monodoc - sans annexe - %counter% | 10   | without       |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - CAdES - Monodoc - avec annexe - %counter% | 10   | with          |
