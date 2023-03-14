@actes-helios-petites-collectivites @prepare-business @ip5 @folder
Feature: Création de dossiers brouillon pour le paramétrage métier "ACTES HELIOS - petites collectivités"

    # @fixme: IP 5, HELIOS - Monodoc, La signature XAdES enveloppée ne peut être effectuée que sur un unique document XML (annexe)
    @fixme-ip5 @issue-todo
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
          | tenant                               | username | password | desktop    | type          | subtype                 | mainFile!                                  | nameTemplate                                      | start! | count! | withOrWithout | extra! | annotation |
          | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - PAdES - Monodoc - sans annexe - %counter% | 1      | 10     | without       | {}     | démarrage  |
          | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - PAdES - Monodoc - avec annexe - %counter% | 1      | 10     | with          | {}     | démarrage  |
          | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456a123456  | WebService | HELIOS        | HELIOS - Monodoc        | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Monodoc - sans annexe - %counter%        | 1      | 10     | without       | {}     | démarrage  |
          | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456a123456  | WebService | HELIOS        | HELIOS - Monodoc        | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Monodoc - avec annexe - %counter%        | 1      | 10     | with          | {}     | démarrage  |
          | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - CAdES - Monodoc - sans annexe - %counter% | 1      | 10     | without       | {}     | démarrage  |
          | ACTES HELIOS - petites collectivités | ws-ahpc  | a123456a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - CAdES - Monodoc - avec annexe - %counter% | 1      | 10     | with          | {}     | démarrage  |
