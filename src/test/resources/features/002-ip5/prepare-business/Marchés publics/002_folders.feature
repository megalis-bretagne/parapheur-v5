@prepare-business @ip5 @marchés-publics @folder
Feature: Création de dossiers pour le paramétrage métier "Marchés publics"

  @fixme-tests @fixme-ip5 @multidoc
  Scenario Outline: Create ${count} "${subtype}" folders ${withOrWithout} annex
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
    * def folders = ip5.api.v1.desk.draft.getPayloadMultidoc(params, <count>, <extra>, <start>)
    * ip5.api.v1.auth.login('<username>', '<password>')
    * def result = call read('classpath:lib/ip5/api/draft/create-and-send-multidoc-<withOrWithout>-annex.feature') folders

    # @todo: mainFiles n'est pas utilisé dans la préparation du payload
    Examples:
        | tenant          | username | password | desktop    | type          | subtype      | mainFiles!                           | nameTemplate            | start! | count! | withOrWithout | extra! | annotation |
        | Marchés publics | ws-mp    | Ilenfautpeupouretreheureux  | WebService | Marché public | Service fait | ['classpath:files/pdf/main-1_1.pdf'] | Marché public %counter% | 1      | 10     | without       | {}     | démarrage  |
