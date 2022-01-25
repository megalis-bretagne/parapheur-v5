@business @unitaire @folder @proposal
Feature: Création de dossiers pour le paramétrage métier "Unitaire"

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
          | tenant   | username    | password | desktop    | type  | subtype                  | mainFile                             | nameTemplate                                      | start! | count! | withOrWithout | extra! |
          | Unitaire | ws-unitaire | a123456  | WebService | CAdES | Signature et metadonnees | classpath:files/office/main-1_1.doc  | CAdES - Signature et métadonnées - DOC %counter%  | 1      | 10     | without       | {}     |
          | Unitaire | ws-unitaire | a123456  | WebService | CAdES | Signature et metadonnees | classpath:files/office/main-1_1.docx | CAdES - Signature et métadonnées - DOCX %counter% | 1      | 10     | without       | {}     |
          | Unitaire | ws-unitaire | a123456  | WebService | CAdES | Signature et metadonnees | classpath:files/office/main-1_1.odt  | CAdES - Signature et métadonnées - ODT %counter%  | 1      | 10     | without       | {}     |
          | Unitaire | ws-unitaire | a123456  | WebService | CAdES | Signature et metadonnees | classpath:files/pdf/main-1_1.pdf     | CAdES - Signature et métadonnées - PDF %counter%  | 1      | 10     | without       | {}     |
