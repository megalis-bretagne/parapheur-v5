Feature: Draft folders creation

    Background:
        # @see https://github.com/karatelabs/karate#dynamic-scenario-outline
        * api_v1.auth.login('user', 'password')
        * def getDraftsPayloadMonodoc =
"""
function(params, max) {
    var result = [],
        tenantId = api_v1.entity.getIdByName(params.tenant),
        deskId = api_v1.desk.getIdByName(tenantId, params.desktop),
        typeId = api_v1.type.getIdByName(tenantId, params.type),
        subtypeId = api_v1.subtype.getIdByName(tenantId, typeId, params.subtype),
        length = max.toString().length,
        nameTemplate = params.nameTemplate === undefined ? params.subtype + '_%counter%' : params.nameTemplate,
        annexFilePath = params.annexFilePath === undefined ? 'classpath:files/pdf/annex-1_1.pdf' : params.annexFilePath,
        mainFilePath = params.mainFile === undefined ? 'classpath:files/pdf/main-1_1.pdf' : params.mainFile
    ;
    for (var i=1;i<=max;i++) {
        result.push({
            draftFolderParams: {
                name: nameTemplate.replace('%counter%', i.toString().padStart(length, "0")),
                subtypeId: subtypeId,
                typeId: typeId
            },
            annexFilePath: annexFilePath,
            mainFilePath: mainFilePath,
            path: '/api/v1/tenant/' + tenantId + '/desk/' + deskId + '/draft',
        });
    }
    return result;
}
"""

    Scenario Outline: Create ${count} "${subtype}" draft folders ${withOrWithout} annex
        # @todo: CACHET, CACHET_MANUEL_MONODOC
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
        * def folders = getDraftsPayloadMonodoc(params, <count>)
        * api_v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/draft/create-monodoc-<withOrWithout>-annex.feature') folders

    Examples:
        | tenant         | username     | password | desktop     | type        | subtype             | mainFile                                 | nameTemplate                                | count | withOrWithout |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PADES  | SIGN_PADES_MONODOC  | classpath:files/pdf/main-1_1.pdf         | SIGN_PADES_MONODOC_WITHOUT_ANNEX_%counter%  | 100   | without       |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PADES  | SIGN_PADES_MONODOC  | classpath:files/pdf/main-1_1.pdf         | SIGN_PADES_MONODOC_WITH_ANNEX_%counter%     | 100   | with          |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PES_V2 | SIGN_PES_V2_MONODOC | classpath:files/xml/PESALR1_unsigned.xml | SIGN_PES_V2_MONODOC_WITHOUT_ANNEX_%counter% | 100   | without       |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PES_V2 | SIGN_PES_V2_MONODOC | classpath:files/xml/PESALR1_unsigned.xml | SIGN_PES_V2_MONODOC_WITH_ANNEX_%counter%    | 100   | with          |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PKCS7  | SIGN_PKCS7_MONODOC  | classpath:files/pdf/main-1_1.pdf         | SIGN_PKCS7_MONODOC_WITHOUT_ANNEX_%counter%  | 100   | without       |
        | Default tenant | stranslucide | a123456  | Translucide | SIGN_PKCS7  | SIGN_PKCS7_MONODOC  | classpath:files/pdf/main-1_1.pdf         | SIGN_PKCS7_MONODOC_WITH_ANNEX_%counter%     | 100   | with          |
        | Default tenant | stranslucide | a123456  | Translucide | VISA        | VISA_MONODOC        | classpath:files/pdf/main-1_1.pdf         | VISA_MONODOC_WITHOUT_ANNEX_%counter%        | 100   | without       |
        | Default tenant | stranslucide | a123456  | Translucide | VISA        | VISA_MONODOC        | classpath:files/pdf/main-1_1.pdf         | VISA_MONODOC_WITH_ANNEX_%counter%           | 100   | with          |
