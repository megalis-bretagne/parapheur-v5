@prepare-business @ip5 @factures @folder
Feature: Création de dossiers pour le paramétrage métier "Factures"

    Scenario Outline: Create ${count} "${subtype}" draft folders ${withOrWithout} annex
        * def params =
"""
{
    tenant: '<tenant>',
    desktop: '<desktop>',
    type: '<type>',
    subtype: '<subtype>',
    mainFile: <mainFile>,
    nameTemplate: '<nameTemplate>',
    annotation: '<annotation>',
    username: '<username>',
}
"""
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def folders = ip5.api.v1.desk.draft.getPayloadMonodoc(params, <count>, <extra>, <start>)
        * ip5.api.v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/ip5/api/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders

      Examples:
          | tenant   | username    | password | desktop    | type | subtype      | mainFile!                          | nameTemplate      | start! | count! | withOrWithout | extra! | annotation |
          | Factures | ws-factures | Ilenfautpeupouretreheureux  | WebService | VISA | VISA_MONODOC | 'classpath:files/pdf/main-1_1.pdf' | Facture_%counter% | 1      | 10     | without       | {}     | démarrage  |
