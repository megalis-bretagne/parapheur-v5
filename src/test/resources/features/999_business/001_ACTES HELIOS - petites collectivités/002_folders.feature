@actes-helios-petites-collectivites @business @folder @proposal
Feature: Création de dossiers brouillon pour le paramétrage métier ACTES HELIOS - petites collectivités

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
        * api_v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders

      Examples:
        | tenant                               | username | password | desktop    | type          | subtype                 | mainFile                                 | nameTemplate                                      | start! | count! | withOrWithout | extra! |
        | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - PAdES - Monodoc - sans annexe - %counter% | 1      | 10     | without       | {}     |
        | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - PAdES - Monodoc - avec annexe - %counter% | 1      | 10     | with          | {}     |
        | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - sans annexe - %counter%        | 1      | 10     | without       | {}     |
        | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - avec annexe - %counter%        | 1      | 10     | with          | {}     |
        | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - CAdES - Monodoc - sans annexe - %counter% | 1      | 10     | without       | {}     |
        | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - CAdES - Monodoc - avec annexe - %counter% | 1      | 10     | with          | {}     |
