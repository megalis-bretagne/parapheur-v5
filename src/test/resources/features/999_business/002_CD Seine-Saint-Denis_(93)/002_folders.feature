@business @cd93 @folder @proposal
Feature: Création de dossiers pour le paramétrage métier CD Seine-Saint-Denis (93)

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
        * api_v1.auth.login('user', 'password')
        * def folders = api_v1.desk.draft.getPayloadMonodoc(params, <count>, <extra>, <start>)
        * karate.log(folders)
        * api_v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders
      # @fixme: HELIOS retourne 500
      Examples:
          | tenant                    | username | password | desktop    | type          | subtype                 | mainFile                                 | nameTemplate                                      | start! | count! | withOrWithout | extra!                            |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - PAdES - Monodoc - sans annexe - %counter% | 1      | 10     | without       | {}                                |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - PAdES - Monodoc - avec annexe - %counter% | 1      | 10     | with          | {}                                |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - sans annexe - %counter%        | 1      | 10     | without       | { "metadata":{"GdaBjType":"1"} }  |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - sans annexe - %counter%        | 11     | 10     | without       | { "metadata":{"GdaBjType":"2"} }  |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - sans annexe - %counter%        | 21     | 10     | without       | { "metadata":{"GdaBjType":"3"} }  |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - avec annexe - %counter%        | 1      | 10     | with          | { "metadata":{"GdaBjType":"1"} }  |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - avec annexe - %counter%        | 11     | 10     | with          | { "metadata":{"GdaBjType":"2"} }  |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - avec annexe - %counter%        | 21     | 10     | with          | { "metadata":{"GdaBjType":"3"} }  |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - CAdES - Monodoc - sans annexe - %counter% | 1      | 10     | without       | {}                                |
          | CD Seine-Saint-Denis (93) | ws-cd93  | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - CAdES - Monodoc - avec annexe - %counter% | 1      | 10     | with          | {}                                |
