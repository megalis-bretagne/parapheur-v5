@prepare-business @ip5 @bons-de-commande @folder
Feature: Création de dossiers pour le paramétrage métier "Bons de commande"

  # @fixme: IP 5, Bon de commande / Script de sélection, Accès à la ressource refusé (API au PUT, UI "Démarrage")
  @fixme-ip5 @issue-todo
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
    * api_v1.auth.login('user', 'password')
    * def folders = api_v1.desk.draft.getPayloadMonodoc(params, <count>, <extra>, <start>)
    * api_v1.auth.login('<username>', '<password>')
    * def result = call read('classpath:lib/api/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders

    Examples:
        | tenant           | username | password | desktop    | type            | subtype             | mainFile!                                        | nameTemplate                              | start! | count! | withOrWithout | extra!                                   | annotation                          |
        | Bons de commande | ws-bdc   | a123456  | WebService | Bon de commande | Bureau variable     | 'classpath:files/pdf/main-1_1-tag_signature.pdf' | Bon de commande bureau Fuchsia %counter%  | 1      | 2      | without       | { "variableDesksIds": {"0": "Fuchsia"} } | démarrage |
        | Bons de commande | ws-bdc   | a123456  | WebService | Bon de commande | Bureau variable     | 'classpath:files/pdf/main-1_1-tag_signature.pdf' | Bon de commande bureau Rose %counter%     | 1      | 2      | without       | { "variableDesksIds": {"0": "Rose"} }    | démarrage |
        | Bons de commande | ws-bdc   | a123456  | WebService | Bon de commande | Script de sélection | 'classpath:files/pdf/main-1_1-tag_signature.pdf' | Bon de commande service Indigo %counter%  | 1      | 2      | without       | { "metadata":{"service":"Indigo"} }      | démarrage |
        | Bons de commande | ws-bdc   | a123456  | WebService | Bon de commande | Script de sélection | 'classpath:files/pdf/main-1_1-tag_signature.pdf' | Bon de commande service Pourpre %counter% | 1      | 2      | without       | { "metadata":{"service":"Pourpre"} }     | démarrage |
