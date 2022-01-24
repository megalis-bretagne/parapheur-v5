@business @factures @folder @proposal
Feature: Création de dossiers pour le paramétrage métier Factures

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
        | tenant   | username    | password | desktop    | type | subtype      | mainFile                         | nameTemplate      | start! | count! | withOrWithout | extra! |
        | Factures | ws-factures | a123456  | WebService | VISA | VISA_MONODOC | classpath:files/pdf/main-1_1.pdf | Facture_%counter% | 1      | 10     | without       | {}     |
