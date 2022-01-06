@setup
Feature: Basic setup
	Scenario Outline: Create tenant "${name}"
		* api_v1.auth.login('user', 'password')

		Given url baseUrl
			And path '/api/v1/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '<name>'}
		When method POST
		Then status 201
			And match $ == schemas.tenant.element
			And match $.name == '<name>'

		Examples:
			| name                               |
			| Libriciel SCOP                     |
			| Montpellier Méditerranée Métropole |

	Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')
		* def defaultTenantId = api_v1.entity.getIdByName('Default tenant')
		Given url baseUrl
			And path '/api/v1/admin/tenant/', tenantId, '/user'
			And header Accept = 'application/json'
			And request
"""
{
	userName : '<userName>',
	email: '<email>',
	firstName: '<firstName>',
	lastName: '<lastName>',
	password: '<password>',
	privilege: '<privilege>',
	notificationsCronFrequency: 'disabled'
}
"""
		When method POST
		Then status 201

		* def userId = api_v1.user.getIdByEmail(defaultTenantId, '<email>')

		Given url baseUrl
			# @info: concatenating with , -> / while concatenating with + adds no extra character
			And path '/api/v1/admin/user/', userId
			And header Accept = 'application/json'
			And request
"""
{
	userName : '<userName>',
	email: '<email>',
	firstName: '<firstName>',
	lastName: '<lastName>',
	password: '<password>',
	privilege: '<privilege>',
	notificationsCronFrequency: 'disabled'
}
"""
		When method PUT
		Then status 200

		Examples:
			| tenant         | userName     | email                  | firstName | lastName    | password | privilege        |
			| Default tenant | cnoir        | cnoir@dom.local        | Christian | Noir        | a123456  | ADMIN            |
			| Default tenant | vgris        | vgris@dom.local        | Virginie  | Gris        | a123456  | TENANT_ADMIN     |
			| Default tenant | ablanc       | ablanc@dom.local       | Aurélie   | Blanc       | a123456  | FUNCTIONAL_ADMIN |
			| Default tenant | ltransparent | ltransparent@dom.local | Laetitia  | Transparent | a123456  | NONE             |
			| Default tenant | stranslucide | stranslucide@dom.local | Sandrine  | Translucide | a123456  | NONE             |

	Scenario Outline: Associate user "${email}" with tenant "${tenant}"
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')
		* def defaultTenantId = api_v1.entity.getIdByName('Default tenant')
		* def userId = api_v1.user.getIdByEmail(defaultTenantId, '<email>')

		Given url baseUrl
			And path '/api/v1/admin/user/', userId, '/tenant/', tenantId
			And header Accept = 'application/json'
			And request
"""
{
	"headers":{
		"normalizedNames":{},
		"lazyUpdate":null,
		"lazyInit":null,
		"headers":{}
	},
	"params":{
		"updates":null,
		"cloneFrom":null,
		"encoder":{},
		"map":null
	}
}
"""
		When method PUT
		Then status 200

		Examples:
			| email           | tenant                             |
			| cnoir@dom.local | Default tenant                     |
			| cnoir@dom.local | Libriciel SCOP                     |
			| cnoir@dom.local | Montpellier Méditerranée Métropole |

	@todo-karate
	Scenario Outline: Create desk "${name}" and associate it to "${email}" in "${tenant}"
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')
		* def userId = api_v1.user.getIdByEmail(tenantId, '<email>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', tenantId, '/desk'
			And header Accept = 'application/json'
			And request
"""
{
	"actionAllowed": true,
	"archivingAllowed": true,
	"associatedDeskIdsList":[],
	"availableSubtypeIdsList":[],
	"chainAllowed":true,
	"delegatingDesks":[],
	"description": "Bureau <name>",
	"filterableMetadataIdsList":[],
	"filterableSubtypeIdsList":[],
	"folderCreationAllowed": true,
	"linkedDeskboxIds":[],
	"name": "<name>",
	"ownerUserIdsList": [
		"#(userId)"
	],
	"parentDeskId": null,
	"shortName": "<name>",
}
"""
		When method POST
		Then status 201

		Examples:
			| tenant         | name        | email                  |
			| Default tenant | Translucide | stranslucide@dom.local |
			| Default tenant | Transparent | ltransparent@dom.local |

	Scenario: Create a seal certificate in "Default tenant"
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('Default tenant')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', tenantId, '/sealCertificate'
			And header Accept = 'application/json'
			And multipart file file = { read: 'classpath:files/Default tenant - Seal Certificate.p12', 'contentType': 'application/x-pkcs12' }
			And multipart field password = 'christian.buffin@libriciel.coop'
		When method POST
		Then status 201

	@todo-karate
	# MAIL returns a 400 (Web or API), check if the same happens when it is configured
	Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')
		* def deskId = api_v1.desk.getIdByName(tenantId, '<deskName>')
		* def key = api_v1.desk.getKeyStringFromNameString('<name>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
			And header Accept = 'application/json'
			And request
"""
{
  "steps": [
    {
      "validators": [
        "#(deskId)"
      ],
      "validationMode": "SIMPLE",
      "name": "<type>",
      "type": "<type>",
      "parallelType": "OR"
    }
  ],
  "name": "<name>",
  "id": "#(key)",
  "key": "#(key)",
  "deploymentId": "#(key)"
}
"""
		When method POST
		Then status 201

		Examples:
			| tenant         | name                            | deskName    | type               |
			# @fixme: API (+UI)
			# | Default tenant | Transparent - Mail              | Transparent | MAIL               |
			# @todo: setup first -> check via API, via Web = 400
			| Default tenant | Transparent - Cachet Serveur    | Transparent | SEAL               |
			| Default tenant | Transparent - Signature         | Transparent | SIGNATURE          |
			| Default tenant | Transparent - Signature externe | Transparent | EXTERNAL_SIGNATURE |
			| Default tenant | Transparent - Visa              | Transparent | VISA               |

	@todo-karate @signature-format
	# @see ip-core/src/main/java/coop/libriciel/ipcore/model/crypto/SignatureFormat.java
	Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', tenantId, '/typology/type'
			And header Accept = 'application/json'
			And request
"""
{
	"name": "<name>",
	"description": "<description>",
	"signatureFormat": "<signatureFormat>",
	"signatureVisible": true
}
"""
		When method POST
		Then status 201

		Examples:
			| tenant         | name        | description       | signatureFormat |
			| Default tenant | CACHET      | Cachet serveur    | PADES           |
			| Default tenant | SIGN_EXT    | Signature externe | PADES           |
			| Default tenant | SIGN_PADES  | Signature PADES   | PADES           |
			| Default tenant | SIGN_PES_V2 | Signature PES_V2  | PES_V2          |
			| Default tenant | SIGN_PKCS7  | Signature PKCS7   | PKCS7           |
			| Default tenant | VISA        | Visa              | PADES           |

	@todo-karate @signature-format
	Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')
		* def workflowKey = api_v1.workflow.getKeyByName(tenantId, '<workflow>')
		* def typeId = api_v1.type.getIdByName(tenantId, '<type>')
		* def sealCertificateId = '<sealCertificate>' == '' ? null : api_v1.sealCertificate.getIdByName(tenantId, '<sealCertificate>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', tenantId, '/typology/type/', typeId, '/subtype'
			And header Accept = 'application/json'
			And request
"""
{
	"annotationsAllowed": true,
	"creationPermittedDeskIds": null,
	"description": "<description>",
	"externalSignatureConfig": {},
	"externalSignatureConfigId": null,
	"filterableByDeskIds": null,
	"ipngTypeKeys": [],
	"name": "<name>",
	"sealCertificateId": "#(sealCertificateId)",
	"subtypeLayerRequestList": [],
	"subtypeMetadataList": [],
	"subtypeMetadataRequestList": [],
	"validationWorkflowId": "#(workflowKey)"
}
"""
		When method POST
		Then status 201
		# @fixme: cannot get seal certificates list (https://gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/ip-core/-/issues/164)
		Examples:
			| tenant         | type        | name                  | description                   | workflow                        | sealCertificate                                    |
#			| Default tenant | CACHET      | CACHET_MANUEL_MONODOC | Cachet serveur manuel monodoc | Transparent - Cachet Serveur    | Christian Buffin - Default tenant - Cachet serveur |
			| Default tenant | SIGN_EXT    | SIGN_EXT_MONODOC      | Signature externe monodoc     | Transparent - Signature externe |                                                    |
			| Default tenant | SIGN_PADES  | SIGN_PADES_MONODOC    | Signature PADES monodoc       | Transparent - Signature         |                                                    |
			| Default tenant | SIGN_PES_V2 | SIGN_PES_V2_MONODOC   | Signature PES_V2 monodoc      | Transparent - Signature         |                                                    |
			| Default tenant | SIGN_PKCS7  | SIGN_PKCS7_MONODOC    | Signature PKCS7 monodoc       | Transparent - Signature         |                                                    |
			| Default tenant | VISA        | VISA_MONODOC          | Visa monodoc                  | Transparent - Visa              |                                                    |

	@todo-karate @todo-karate-title
	Scenario Outline: ...
		* api_v1.auth.login('user', 'password')
		* def existingTenantId = api_v1.entity.getIdByName('<tenant>')
		* def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
			And header Accept = 'application/json'
			And multipart file file = { read: '<path>', 'contentType': 'image/png' }
		When method POST
		Then status 201

		Examples:
			| tenant         | email                  | path                                         |
			| Default tenant | ltransparent@dom.local | classpath:files/signature - ltransparent.png |
			| Default tenant | stranslucide@dom.local | classpath:files/signature - stranslucide.png |
