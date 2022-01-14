@business-soludoc @draft-business @proposal
Feature: Création de dossiers brouillon pour le paramétrage métier SOLUDOC

    # @todo: envoyer les dossiers dans le circuit (car WebService)
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
        * def folders = api_v1.desk.draft.getPayloadMonodoc(params, <count>)
        * api_v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/draft/create-monodoc-<withOrWithout>-annex.feature') folders

      Examples:
          | tenant  | username   | password | desktop    | type          | subtype                 | mainFile                                 | nameTemplate                                      | count | withOrWithout |
          | SOLUDOC | webservice | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - PAdES - Monodoc - sans annexe - %counter% | 100   | without       |
          | SOLUDOC | webservice | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - PAdES - Monodoc - avec annexe - %counter% | 100   | with          |
          | SOLUDOC | webservice | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - sans annexe - %counter%        | 100   | without       |
          | SOLUDOC | webservice | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | classpath:files/xml/PESALR1_unsigned.xml | HELIOS - Monodoc - avec annexe - %counter%        | 100   | with          |
          | SOLUDOC | webservice | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - CAdES - Monodoc - sans annexe - %counter% | 100   | without       |
          | SOLUDOC | webservice | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | classpath:files/pdf/main-1_1.pdf         | ACTES - CAdES - Monodoc - avec annexe - %counter% | 100   | with          |
