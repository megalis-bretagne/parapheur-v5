@business @ip5 @legacy-bridge @folder
Feature: Création de dossiers pour le paramétrage métier "Legacy Bridge"

  # @todo: Auto_visa_avec_meta_ -> Auto_monodoc_visa_avec_meta_
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
          | tenant        | username         | password | desktop    | type         | subtype        | mainFile!                                                 | nameTemplate                  | start! | count! | withOrWithout | extra!                               | annotation |
          | Legacy Bridge | ws@legacy-bridge | Ilenfautpeupouretreheureux  | WebService | Auto monodoc | sign avec meta | 'classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf' | Auto_sign_avec_meta_%counter% | 1      | 2      | without       | { "metadata":{"mameta_bool":false} } | démarrage  |
          | Legacy Bridge | ws@legacy-bridge | Ilenfautpeupouretreheureux  | WebService | Auto monodoc | visa avec meta | 'classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf' | Auto_visa_avec_meta_%counter% | 1      | 4      | without       | { "metadata":{"mameta_bool":false} } | démarrage  |
          | Legacy Bridge | ws@legacy-bridge | Ilenfautpeupouretreheureux  | WebService | PAdES        | cachet         | 'classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf' | PAdES_cachet_%counter%        | 1      | 2      | without       | {}                                   | démarrage  |
          | Legacy Bridge | ws@legacy-bridge | Ilenfautpeupouretreheureux  | WebService | PAdES        | mailsec        | 'classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf' | PAdES_mailsec_%counter%       | 1      | 2      | without       | {}                                   | démarrage  |
