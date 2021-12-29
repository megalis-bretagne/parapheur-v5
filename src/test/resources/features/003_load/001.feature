Feature: ...
    @wip
    Scenario:
        # @see https://github.com/karatelabs/karate#dynamic-scenario-outline
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def existingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Translucide')
        * def existingTypeId = api_v1.type.getIdByName(existingTenantId, 'VISA')
        * def existingSubtypeId = api_v1.subtype.getIdByName(existingTenantId, existingTypeId, 'VISA_MONODOC')

        * def getDraftsPayload =
"""
function(tenant, desk, type, subtype, max) {
    var result = [],
        tenantId = api_v1.entity.getIdByName(tenant),
        deskId = api_v1.desk.getIdByName(tenantId, desk),
        typeId = api_v1.type.getIdByName(tenantId, type),
        subtypeId = api_v1.subtype.getIdByName(tenantId, typeId, subtype),
        length = max.toString().length;
    ;
    for (var i=1;i<=max;i++) {
        result.push({
            name: subtype + '_' + i.toString().padStart(length, "0"),
            tenantId: tenantId,
            deskId: deskId,
            subtypeId: subtypeId,
            typeId: typeId
        });
    }
    return result;
}
"""

        * def fooBarBaz =
"""
function(params, max) {
    var result = [],
        tenantId = api_v1.entity.getIdByName(params.tenant),
        deskId = api_v1.desk.getIdByName(tenantId, params.desktop),
        typeId = api_v1.type.getIdByName(tenantId, params.type),
        subtypeId = api_v1.subtype.getIdByName(tenantId, typeId, params.subtype),
        length = max.toString().length
    ;
    for (var i=1;i<=max;i++) {
        result.push({
            draftFolderParams: {
                name: params.subtype + '_' + i.toString().padStart(length, "0"),
                subtypeId: subtypeId,
                typeId: typeId
            },
            //mainFiles: ['classpath:files/dummy.pdf'],
            path: '/api/v1/tenant/' + tenantId + '/desk/' + deskId + '/draft',
        });
    }
    return result;
}
"""
        * def params = {tenant: 'Default tenant', desktop: 'Translucide', type: 'VISA', subtype: 'VISA_MONODOC'}
        * def folders = fooBarBaz(params, 1)
        * karate.log({params: params, folders: folders})
        * api_v1.auth.login('stranslucide', 'a123456')
        * def result = call read('classpath:lib/draft/create.feature') folders

#        # * def folders = getDraftsPayload('Default tenant', 'Translucide', 'VISA', 'VISA_MONODOC', 100)
#        # * def folders = getDraftsPayload('Default tenant', 'Translucide', 'CACHET', 'CACHET_MANUEL_MONODOC', 100)

#        * api_v1.auth.login('stranslucide', 'a123456')
#        * def result = call read('classpath:lib/draft/create.feature') folders

    Scenario Outline: ...
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def existingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Translucide')
        * def existingTypeId = api_v1.type.getIdByName(existingTenantId, 'VISA')
        * def existingSubtypeId = api_v1.subtype.getIdByName(existingTenantId, existingTypeId, 'VISA_MONODOC')

        * api_v1.auth.login('stranslucide', 'a123456')
        * def payload =
"""
{
    "name": "<name>",
    "subtypeId": "#(existingSubtypeId)",
    "typeId": "#(existingTypeId)"
}
"""

        Given url baseUrl
            And path '/api/v1/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/draft'
            And header Accept = 'application/json'
            And multipart file draftFolderParams = { 'value': '#(payload)', 'contentType': 'application/json' }
            And multipart file mainFiles = { read: 'classpath:files/dummy.pdf', 'contentType': 'application/pdf', 'fileName': 'dummy.pdf' }
        When method POST
        Then status 201

        Examples:
            | name             |
            | VISA_MONODOC_001 |
            | VISA_MONODOC_002 |
            | VISA_MONODOC_003 |
            | VISA_MONODOC_004 |
            | VISA_MONODOC_005 |
            | VISA_MONODOC_006 |
            | VISA_MONODOC_007 |
            | VISA_MONODOC_008 |
            | VISA_MONODOC_009 |
            | VISA_MONODOC_010 |
            | VISA_MONODOC_011 |
            | VISA_MONODOC_012 |
            | VISA_MONODOC_013 |
            | VISA_MONODOC_014 |
            | VISA_MONODOC_015 |
            | VISA_MONODOC_016 |
            | VISA_MONODOC_017 |
            | VISA_MONODOC_018 |
            | VISA_MONODOC_019 |
            | VISA_MONODOC_020 |
            | VISA_MONODOC_021 |
            | VISA_MONODOC_022 |
            | VISA_MONODOC_023 |
            | VISA_MONODOC_024 |
            | VISA_MONODOC_025 |
            | VISA_MONODOC_026 |
            | VISA_MONODOC_027 |
            | VISA_MONODOC_028 |
            | VISA_MONODOC_029 |
            | VISA_MONODOC_030 |
            | VISA_MONODOC_031 |
            | VISA_MONODOC_032 |
            | VISA_MONODOC_033 |
            | VISA_MONODOC_034 |
            | VISA_MONODOC_035 |
            | VISA_MONODOC_036 |
            | VISA_MONODOC_037 |
            | VISA_MONODOC_038 |
            | VISA_MONODOC_039 |
            | VISA_MONODOC_040 |
            | VISA_MONODOC_041 |
            | VISA_MONODOC_042 |
            | VISA_MONODOC_043 |
            | VISA_MONODOC_044 |
            | VISA_MONODOC_045 |
            | VISA_MONODOC_046 |
            | VISA_MONODOC_047 |
            | VISA_MONODOC_048 |
            | VISA_MONODOC_049 |
            | VISA_MONODOC_050 |
            | VISA_MONODOC_051 |
            | VISA_MONODOC_052 |
            | VISA_MONODOC_053 |
            | VISA_MONODOC_054 |
            | VISA_MONODOC_055 |
            | VISA_MONODOC_056 |
            | VISA_MONODOC_057 |
            | VISA_MONODOC_058 |
            | VISA_MONODOC_059 |
            | VISA_MONODOC_060 |
            | VISA_MONODOC_061 |
            | VISA_MONODOC_062 |
            | VISA_MONODOC_063 |
            | VISA_MONODOC_064 |
            | VISA_MONODOC_065 |
            | VISA_MONODOC_066 |
            | VISA_MONODOC_067 |
            | VISA_MONODOC_068 |
            | VISA_MONODOC_069 |
            | VISA_MONODOC_070 |
            | VISA_MONODOC_071 |
            | VISA_MONODOC_072 |
            | VISA_MONODOC_073 |
            | VISA_MONODOC_074 |
            | VISA_MONODOC_075 |
            | VISA_MONODOC_076 |
            | VISA_MONODOC_077 |
            | VISA_MONODOC_078 |
            | VISA_MONODOC_079 |
            | VISA_MONODOC_080 |
            | VISA_MONODOC_081 |
            | VISA_MONODOC_082 |
            | VISA_MONODOC_083 |
            | VISA_MONODOC_084 |
            | VISA_MONODOC_085 |
            | VISA_MONODOC_086 |
            | VISA_MONODOC_087 |
            | VISA_MONODOC_088 |
            | VISA_MONODOC_089 |
            | VISA_MONODOC_090 |
            | VISA_MONODOC_091 |
            | VISA_MONODOC_092 |
            | VISA_MONODOC_093 |
            | VISA_MONODOC_094 |
            | VISA_MONODOC_095 |
            | VISA_MONODOC_096 |
            | VISA_MONODOC_097 |
            | VISA_MONODOC_098 |
            | VISA_MONODOC_099 |
            | VISA_MONODOC_100 |
            | VISA_MONODOC_101 |
            | VISA_MONODOC_102 |
            | VISA_MONODOC_103 |
            | VISA_MONODOC_104 |
            | VISA_MONODOC_105 |
            | VISA_MONODOC_106 |
            | VISA_MONODOC_107 |
            | VISA_MONODOC_108 |
            | VISA_MONODOC_109 |
            | VISA_MONODOC_110 |
            | VISA_MONODOC_111 |
            | VISA_MONODOC_112 |
            | VISA_MONODOC_113 |
            | VISA_MONODOC_114 |
            | VISA_MONODOC_115 |
            | VISA_MONODOC_116 |
            | VISA_MONODOC_117 |
            | VISA_MONODOC_118 |
            | VISA_MONODOC_119 |
            | VISA_MONODOC_120 |
            | VISA_MONODOC_121 |
            | VISA_MONODOC_122 |
            | VISA_MONODOC_123 |
            | VISA_MONODOC_124 |
            | VISA_MONODOC_125 |
            | VISA_MONODOC_126 |
            | VISA_MONODOC_127 |
            | VISA_MONODOC_128 |
            | VISA_MONODOC_129 |
            | VISA_MONODOC_130 |
            | VISA_MONODOC_131 |
            | VISA_MONODOC_132 |
            | VISA_MONODOC_133 |
            | VISA_MONODOC_134 |
            | VISA_MONODOC_135 |
            | VISA_MONODOC_136 |
            | VISA_MONODOC_137 |
            | VISA_MONODOC_138 |
            | VISA_MONODOC_139 |
            | VISA_MONODOC_140 |
            | VISA_MONODOC_141 |
            | VISA_MONODOC_142 |
            | VISA_MONODOC_143 |
            | VISA_MONODOC_144 |
            | VISA_MONODOC_145 |
            | VISA_MONODOC_146 |
            | VISA_MONODOC_147 |
            | VISA_MONODOC_148 |
            | VISA_MONODOC_149 |
            | VISA_MONODOC_150 |
