@ip5 @load @draft
Feature: Draft folders creation

    # @see https://github.com/karatelabs/karate#dynamic-scenario-outline
    # @todo: CACHET, CACHET_MANUEL_MONODOC
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
        * def result = call read('classpath:lib/ip5/api/draft/create-monodoc-<withOrWithout>-annex.feature') folders

    Examples:
        | tenant         | username     | password | desktop     | type        | subtype             | mainFile!                                  | nameTemplate                                | start! | count! | withOrWithout | extra! | annotation |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PADES  | SIGN_PADES_MONODOC  | 'classpath:files/pdf/main-1_1.pdf'         | SIGN_PADES_MONODOC_WITHOUT_ANNEX_%counter%  | 1      | 10     | without       | {}     | démarrage  |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PADES  | SIGN_PADES_MONODOC  | 'classpath:files/pdf/main-1_1.pdf'         | SIGN_PADES_MONODOC_WITH_ANNEX_%counter%     | 1      | 10     | with          | {}     | démarrage  |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PES_V2 | SIGN_PES_V2_MONODOC | 'classpath:files/xml/PESALR1_unsigned.xml' | SIGN_PES_V2_MONODOC_WITHOUT_ANNEX_%counter% | 1      | 10     | without       | {}     | démarrage  |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PES_V2 | SIGN_PES_V2_MONODOC | 'classpath:files/xml/PESALR1_unsigned.xml' | SIGN_PES_V2_MONODOC_WITH_ANNEX_%counter%    | 1      | 10     | with          | {}     | démarrage  |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PKCS7  | SIGN_PKCS7_MONODOC  | 'classpath:files/pdf/main-1_1.pdf'         | SIGN_PKCS7_MONODOC_WITHOUT_ANNEX_%counter%  | 1      | 10     | without       | {}     | démarrage  |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PKCS7  | SIGN_PKCS7_MONODOC  | 'classpath:files/pdf/main-1_1.pdf'         | SIGN_PKCS7_MONODOC_WITH_ANNEX_%counter%     | 1      | 10     | with          | {}     | démarrage  |
        | Default tenant | stranslucide | a123456  | Translucide | VISA        | VISA_MONODOC        | 'classpath:files/pdf/main-1_1.pdf'         | VISA_MONODOC_WITHOUT_ANNEX_%counter%        | 1      | 10     | without       | {}     | démarrage  |
        | Default tenant | stranslucide | a123456  | Translucide | VISA        | VISA_MONODOC        | 'classpath:files/pdf/main-1_1.pdf'         | VISA_MONODOC_WITH_ANNEX_%counter%           | 1      | 10     | with          | {}     | démarrage  |
