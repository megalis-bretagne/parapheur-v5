@setup
Feature: Basic setup

	Scenario Outline: Create tenants "Libriciel SCOP" and "Montpellier Méditerranée Métropole"
		* api_v1.auth.login('user', 'password')

		Given url baseUrl
			And path '/api/admin/tenant'
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

	Scenario Outline: Create users with each role value in the "Default tenant"
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')

		Given url baseUrl
			And path '/api/admin/tenant/', tenantId, '/user'
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
	notificationsCronFrequency: 'NONE',
	notificationsRedirectionMail: '<email>'
}
"""
		When method POST
		Then status 201

		Examples:
			| tenant         | userName     | email                  | firstName | lastName    | password | privilege        |
			| Default tenant | cnoir        | cnoir@dom.local        | Christian | Noir        | a123456  | ADMIN            |
			| Default tenant | ablanc       | ablanc@dom.local       | Aurélie   | Blanc       | a123456  | FUNCTIONAL_ADMIN |
			| Default tenant | ltransparent | ltransparent@dom.local | Laetitia  | Transparent | a123456  | NONE             |
			| Default tenant | stranslucide | stranslucide@dom.local | Sandrine  | Translucide | a123456  | NONE             |

	# 404 when-parentDeskId is not null
	@todo-karate
	Scenario Outline: Create desks and associate them to users
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')

		Given url baseUrl
			And path '/api/admin/tenant/', tenantId, '/desk'
			And header Accept = 'application/json'
			And request
"""
{
	"name": "<name>",
	"description": "Bureau <name>",
	"parentDeskId": null
}
"""
		When method POST
		Then status 201

		* def deskId = $.id
		* def userId = api_v1.user.getIdByEmail(tenantId, '<email>')

		Given url baseUrl
			And path '/api/admin/tenant/', tenantId, '/desk/', deskId, '/users'
			And header Accept = 'application/json'
			And request { "userIdList": ["#(userId)"] }
		When method PUT
		Then status 200

		Examples:
			| tenant         | name        | email                  |
			| Default tenant | Translucide | stranslucide@dom.local |
			| Default tenant | Transparent | ltransparent@dom.local |

	@todo-karate
	# MAIL returns a 400 (Web or API), check if the same happens when it is configured
	Scenario Outline: Create one step workflows and associate them to desks
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')
		* def deskId = api_v1.desk.getIdByName(tenantId, '<deskName>')
		* def key = '<name>'.toLowerCase().replace(/[^a-z0-9]/g, '_')

		Given url baseUrl
			And path '/api/admin/tenant/', tenantId, '/workflowDefinition'
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
	Scenario Outline: Create types
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')

		Given url baseUrl
		And path '/api/admin/tenant/', tenantId, '/typology/type'
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
	Scenario Outline: Create subtypes
		* api_v1.auth.login('user', 'password')
		* def tenantId = api_v1.entity.getIdByName('<tenant>')
		* def workflowKey = api_v1.workflow.getKeyByName(tenantId, '<workflow>')
		* def typeId = api_v1.type.getIdByName(tenantId, '<type>')

		Given url baseUrl
		And path 'api/admin/tenant/', tenantId, 'typology/type/', typeId, '/subtype'
		And header Accept = 'application/json'
		And request
"""
{
	"name" : "<name>",
	"tenantId" : "#(tenantId)",
	"creationWorkflowId" : null,
	"validationWorkflowId" : "#(workflowKey)",
	"description" : "<description>",
	"isDigitalSignatureMandatory" : true
}
"""
		When method POST
		Then status 201

		Examples:
			| tenant         | type        | name                  | description                   | workflow                        |
			| Default tenant | CACHET      | CACHET_MANUEL_MONODOC | Cachet serveur manuel monodoc | Transparent - Cachet Serveur    |
			| Default tenant | SIGN_EXT    | SIGN_EXT_MONODOC      | Signature externe monodoc     | Transparent - Signature externe |
			| Default tenant | SIGN_PADES  | SIGN_PADES_MONODOC    | Signature PADES monodoc       | Transparent - Signature         |
			| Default tenant | SIGN_PES_V2 | SIGN_PES_V2_MONODOC   | Signature PES_V2 monodoc      | Transparent - Signature         |
			| Default tenant | SIGN_PKCS7  | SIGN_PKCS7_MONODOC    | Signature PKCS7 monodoc       | Transparent - Signature         |
			| Default tenant | VISA        | VISA_MONODOC          | Visa monodoc                  | Transparent - Visa              |
