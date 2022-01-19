@setup
Feature: Basic setup
	Background:
		* api_v1.auth.login('user', 'password')

	Scenario Outline: Create tenant "${name}"
		* call read('classpath:lib/setup/tenant.create.feature') __row

		Examples:
			| name                               |
			| Libriciel SCOP                     |
			| Montpellier Méditerranée Métropole |

	Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
		* call read('classpath:lib/setup/user.create.feature') __row

		Examples:
			| tenant         | userName     | email                  | firstName | lastName    | password | privilege        | notificationsCronFrequency |
			| Default tenant | cnoir        | cnoir@dom.local        | Christian | Noir        | a123456  | ADMIN            | disabled                   |
			| Default tenant | vgris        | vgris@dom.local        | Virginie  | Gris        | a123456  | TENANT_ADMIN     | disabled                   |
			| Default tenant | ablanc       | ablanc@dom.local       | Aurélie   | Blanc       | a123456  | FUNCTIONAL_ADMIN | disabled                   |
			| Default tenant | ltransparent | ltransparent@dom.local | Laetitia  | Transparent | a123456  | NONE             | disabled                   |
			| Default tenant | stranslucide | stranslucide@dom.local | Sandrine  | Translucide | a123456  | NONE             | disabled                   |

	Scenario Outline: Associate user "${email}" with tenant "${tenant}"
		* call read('classpath:lib/setup/tenant.user.associate.feature') __row

		Examples:
			| email           | tenant                             |
			| cnoir@dom.local | Default tenant                     |
			| cnoir@dom.local | Libriciel SCOP                     |
			| cnoir@dom.local | Montpellier Méditerranée Métropole |

	Scenario Outline: Create desk "${name}" in "${tenant}"
		* call read('classpath:lib/setup/desk.create.feature') __row

		Examples:
			| tenant         | name        | owners!                    | parent! | associated! | permissions!                                       |
			| Default tenant | Transparent | ['ltransparent@dom.local'] | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
			| Default tenant | Translucide | ['stranslucide@dom.local'] | ''      | []          | {'action': true, 'creation': true}                 |

	Scenario: Create a seal certificate in "Default tenant"
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
		* call read('classpath:lib/setup/one-step-workflow.create.feature') __row

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
		* call read('classpath:lib/setup/type.create.feature') __row

		# @fixme: remplir les colonnes signatureLocation | signatureZipCode | signaturePosition
		Examples:
			| tenant         | name        | description       | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition!       |
			| Default tenant | CACHET      | Cachet serveur    |          | PADES           |                   |                  |                          |
			| Default tenant | SIGN_EXT    | Signature externe |          | PADES           |                   |                  |                          |
			| Default tenant | SIGN_PADES  | Signature PADES   |          | PADES           |                   |                  |                          |
			| Default tenant | SIGN_PES_V2 | Signature PES_V2  |          | PES_V2          |                   |                  |                          |
			| Default tenant | SIGN_PKCS7  | Signature PKCS7   |          | PKCS7           |                   |                  |                          |
			| Default tenant | VISA        | Visa              |          | PADES           |                   |                  |                          |

	@todo-karate @signature-format
	Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
		* call read('classpath:lib/setup/subtype.create.feature') __row

		Examples:
			| tenant         | type        | name                  | description                   | workflow!                         | sealCertificate!                                     | workflowSelectionScript! | subtypeMetadataRequestList! |
			| Default tenant | CACHET      | CACHET_MANUEL_MONODOC | Cachet serveur manuel monodoc | 'Transparent - Cachet Serveur'    | 'Christian Buffin - Default tenant - Cachet serveur' | ''                       | []                          |
			| Default tenant | SIGN_EXT    | SIGN_EXT_MONODOC      | Signature externe monodoc     | 'Transparent - Signature externe' | ''                                                   | ''                       | []                          |
			| Default tenant | SIGN_PADES  | SIGN_PADES_MONODOC    | Signature PADES monodoc       | 'Transparent - Signature'         | ''                                                   | ''                       | []                          |
			| Default tenant | SIGN_PES_V2 | SIGN_PES_V2_MONODOC   | Signature PES_V2 monodoc      | 'Transparent - Signature'         | ''                                                   | ''                       | []                          |
			| Default tenant | SIGN_PKCS7  | SIGN_PKCS7_MONODOC    | Signature PKCS7 monodoc       | 'Transparent - Signature'         | ''                                                   | ''                       | []                          |
			| Default tenant | VISA        | VISA_MONODOC          | Visa monodoc                  | 'Transparent - Visa'              | ''                                                   | ''                       | []                          |

	Scenario Outline: Set the signature image for user "${email}"
		* call read('classpath:lib/setup/user.signatureImage.create.feature') __row

		Examples:
			| tenant         | email                  | path                                                |
			| Default tenant | ltransparent@dom.local | classpath:files/images/signature - ltransparent.png |
			| Default tenant | stranslucide@dom.local | classpath:files/images/signature - stranslucide.png |
