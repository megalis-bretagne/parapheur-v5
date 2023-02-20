@api @ip5 @setup
Feature: Basic setup
	Background:
		* ip5.api.v1.auth.login('user', adminUserPwd)

	Scenario Outline: Create tenant "${name}"
		* call read('classpath:lib/ip5/api/setup/tenant.create.feature') __row

		Examples:
			| name                               |
			| Libriciel SCOP                     |
			| Montpellier Méditerranée Métropole |

	Scenario Outline: Create desk "${name}" in "${tenant}"
		* call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

		Examples:
			| tenant          | name      | owners! | parent! | associated! | permissions!                                       |
			| Entité initiale | null_desk | []      | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |

	Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
		* call read('classpath:lib/ip5/api/setup/user.create.feature') __row

		Examples:
			| tenant          | userName     | email                  | firstName | lastName    | password | privilege        | notificationsCronFrequency | administeredDesk |
			| Entité initiale | cnoir        | cnoir@dom.local        | Christian | Noir        | a123456  | SUPER_ADMIN      | disabled                   | 				  |
			| Entité initiale | vgris        | vgris@dom.local        | Virginie  | Gris        | a123456  | TENANT_ADMIN     | disabled                   |                  |
			| Entité initiale | ablanc       | ablanc@dom.local       | Aurélie   | Blanc       | a123456  | FUNCTIONAL_ADMIN | disabled                   | null_desk        |
			| Entité initiale | ltransparent | ltransparent@dom.local | Laetitia  | Transparent | a123456  | NONE             | disabled                   |                  |
			| Entité initiale | stranslucide | stranslucide@dom.local | Sandrine  | Translucide | a123456  | NONE             | disabled                   |                  |

	Scenario Outline: Associate user "${email}" with tenant "${tenant}"
		* call read('classpath:lib/ip5/api/setup/tenant.user.associate.feature') __row

		Examples:
			| email           | tenant                             |
			| cnoir@dom.local | Entité initiale                    |
			| cnoir@dom.local | Libriciel SCOP                     |
			| cnoir@dom.local | Montpellier Méditerranée Métropole |

	Scenario Outline: Create desk "${name}" in "${tenant}"
		* call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

		Examples:
			| tenant         | name        | owners!                    | parent! | associated! | permissions!                                       |
			| Entité initiale | Transparent | ['ltransparent@dom.local'] | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
			| Entité initiale | Translucide | ['stranslucide@dom.local'] | ''      | []          | {'action': true, 'creation': true}                 |

	Scenario Outline: Create a seal certificate from file "${path}" in "${tenant}"
		* call read('classpath:lib/ip5/api/setup/seal-certificate.create.feature') __row

		Examples:
			| tenant         | path                                                  | password                        | image! |
			| Entité initiale | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | ''     |

	@todo-karate
	# MAIL returns a 400 (Web or API), check if the same happens when it is configured
	Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
		* call read('classpath:lib/ip5/api/setup/one-step-workflow.create.feature') __row

		Examples:
			| tenant         | name                            | deskName    | type               | mandatoryValidationMetadata! |
			# @fixme: API (+UI)
#			| Entité initiale | Transparent - Mail              | Transparent | MAIL               | []                 |
			# @todo: setup first -> check via API, via Web = 400
			| Entité initiale | Transparent - Cachet Serveur    | Transparent | SEAL               | []                           |
			| Entité initiale | Transparent - Signature         | Transparent | SIGNATURE          | []                           |
			| Entité initiale | Transparent - Signature externe | Transparent | EXTERNAL_SIGNATURE | []                           |
			| Entité initiale | Transparent - Visa              | Transparent | VISA               | []                           |

	@todo-karate @signature-format
	# @see ip-core/src/main/java/coop/libriciel/ipcore/model/crypto/SignatureFormat.java
	Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
		* call read('classpath:lib/ip5/api/setup/type.create.feature') __row

		# @fixme: remplir les colonnes signatureLocation | signatureZipCode | signaturePosition
		Examples:
			| tenant         | name        | description       | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!       |
			| Entité initiale | CACHET      | Cachet serveur    |          | PADES           |                   |                  | false             |                          |
			| Entité initiale | SIGN_EXT    | Signature externe |          | PADES           |                   |                  | false             |                          |
			| Entité initiale | SIGN_PADES  | Signature PADES   |          | PADES           |                   |                  | false             |                          |
			| Entité initiale | SIGN_PES_V2 | Signature PES_V2  |          | PES_V2          |                   |                  | false             |                          |
			| Entité initiale | SIGN_PKCS7  | Signature PKCS7   |          | PKCS7           |                   |                  | false             |                          |
			| Entité initiale | VISA        | Visa              |          | PADES           |                   |                  | false             |                          |

	@todo-karate @signature-format
	Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
		* call read('classpath:lib/ip5/api/setup/subtype.create.feature') __row

		Examples:
			| tenant         | type        | name                  | description                   | validationWorkflowId            | secureMailServerId | sealCertificateId                                  | workflowSelectionScript! | subtypeMetadataList! |
			| Entité initiale | CACHET      | CACHET_MANUEL_MONODOC | Cachet serveur manuel monodoc | Transparent - Cachet Serveur    |                    | Christian Buffin - Entité initiale - Cachet serveur | ''                       | []                   |
			| Entité initiale | SIGN_EXT    | SIGN_EXT_MONODOC      | Signature externe monodoc     | Transparent - Signature externe |                    |                                                    | ''                       | []                   |
			| Entité initiale | SIGN_PADES  | SIGN_PADES_MONODOC    | Signature PADES monodoc       | Transparent - Signature         |                    |                                                    | ''                       | []                   |
			| Entité initiale | SIGN_PES_V2 | SIGN_PES_V2_MONODOC   | Signature PES_V2 monodoc      | Transparent - Signature         |                    |                                                    | ''                       | []                   |
			| Entité initiale | SIGN_PKCS7  | SIGN_PKCS7_MONODOC    | Signature PKCS7 monodoc       | Transparent - Signature         |                    |                                                    | ''                       | []                   |
			| Entité initiale | VISA        | VISA_MONODOC          | Visa monodoc                  | Transparent - Visa              |                    |                                                    | ''                       | []                   |

	Scenario Outline: Set the signature image for user "${email}"
		* call read('classpath:lib/ip5/api/setup/user.signatureImage.create.feature') __row

		Examples:
			| tenant         | email                  | path                                                |
			| Entité initiale | ltransparent@dom.local | classpath:files/images/signature - ltransparent.png |
			| Entité initiale | stranslucide@dom.local | classpath:files/images/signature - stranslucide.png |
