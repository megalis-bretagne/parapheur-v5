@legacy-bridge @folder
Feature: Création de dossiers pour le paramétrage métier "Legacy Bridge"

  Scenario Outline: Create ${count} "${subtype}" draft folders ${withOrWithout} annex
    * def params =
"""
{
    tenant: '<tenant>',
    desktop: '<desktop>',
    type: '<type>',
    subtype: '<subtype>',
    mainFile: <mainFile>,
    nameTemplate: '<nameTemplate>'
}
"""
    * api_v1.auth.login('user', 'password')
    * def folders = api_v1.desk.draft.getPayloadMonodoc(params, <count>, <extra>, <start>)
    * api_v1.auth.login('<username>', '<password>')
    * def result = call read('classpath:lib/api/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders

    Examples:
        | tenant        | username         | password | desktop    | type | subtype        | mainFile!                          | nameTemplate                  | start! | count! | withOrWithout | extra!                               |
        | Legacy Bridge | ws@legacy-bridge | a123456  | WebService | Auto | visa avec meta | 'classpath:files/pdf/main-1_1.pdf' | Auto_visa_avec_meta_%counter% | 1      | 4      | without       | { "metadata":{"mameta_bool":false} } |
