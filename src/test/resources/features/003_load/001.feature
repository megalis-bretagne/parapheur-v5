Feature: ...
    Background:
        # @see https://github.com/karatelabs/karate#dynamic-scenario-outline
        * api_v1.auth.login('user', 'password')
        * def getDraftsPayload =
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
#        # @todo: CACHET      | CACHET_MANUEL_MONODOC
#        * def params = {tenant: 'Default tenant', desktop: 'Translucide', type: 'SIGN_PADES', subtype: 'SIGN_PADES_MONODOC'}
#        * def params = {tenant: 'Default tenant', desktop: 'Translucide', type: 'SIGN_PES_V2', subtype: 'SIGN_PES_V2_MONODOC', mainFile: 'classpath:files/xml/PESALR1_unsigned.xml' }
#        * def params = {tenant: 'Default tenant', desktop: 'Translucide', type: 'SIGN_PKCS7', subtype: 'SIGN_PKCS7_MONODOC'}

    Scenario: Create 100 "VISA_MONODOC" draft folders without annex
        * def params = {tenant: 'Default tenant', desktop: 'Translucide', type: 'VISA', subtype: 'VISA_MONODOC', nameTemplate: 'VISA_MONODOC_WITHOUT_ANNEX_%counter%'}

        * def folders = getDraftsPayload(params, 100)
        * api_v1.auth.login('stranslucide', 'a123456')
        * def result = call read('classpath:lib/draft/create-monodoc-without-annex.feature') folders

    Scenario: Create 100 "VISA_MONODOC" draft folders with annex
        * def params = {tenant: 'Default tenant', desktop: 'Translucide', type: 'VISA', subtype: 'VISA_MONODOC', nameTemplate: 'VISA_MONODOC_WITH_ANNEX_%counter%'}

        * def folders = getDraftsPayload(params, 100)
        * api_v1.auth.login('stranslucide', 'a123456')
        * def result = call read('classpath:lib/draft/create-monodoc-with-annex.feature') folders
