@business @circuits-unitaires @proposal @setup
Feature: Paramétrage métier "Circuits unitaires"

    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name               |
            | Circuits unitaires |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant             | userName | email             | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Circuits unitaires | nmarron  | nmarron@dom.local | Nadine    | Marron   | a123456  | NONE      | disabled                   |
            | Circuits unitaires | ws-cu    | ws-cu@dom.local   | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant             | name       | owners!               | parent! | associated!   | permissions!                                                         |
            | Circuits unitaires | Châtaigne  | ['nmarron@dom.local'] | ''      | []            | {'action': true}                                                     |
            | Circuits unitaires | Marron     | ['nmarron@dom.local'] | ''      | ['Châtaigne'] | {'action': true}                                                     |
            | Circuits unitaires | WebService | ['ws-cu@dom.local']   | ''      | []            | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/setup/metadata.create.feature') __row

        Examples:
            | tenant             | key    | name                    | type | restrictedValues! |
            | Circuits unitaires | refus  | Raison du refus         | TEXT | []                |
            | Circuits unitaires | succes | Raison de la validation | TEXT | []                |

    Scenario Outline: Create a seal certificate from file "${path}" in "${tenant}"
        * call read('classpath:lib/setup/seal-certificate.create.feature') __row

        Examples:
            | tenant             | path                                                  | password                        | image!                                                   |
            | Circuits unitaires | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | 'classpath:files/images/cachet - circuits unitaires.png' |

    Scenario Outline:
        * call read('classpath:lib/setup/secure-mail.create.feature') __row

        Examples:
            | tenant             | name                           | url                                      | login                                 | password | entity |
            | Circuits unitaires | Mail securise Pastell cbuffin | https://pastell.partenaire.libriciel.fr/ | ws-pa-cbuffin-recette-ip500ea-mailsec | a123456  | 116    |

    # @todo: métadonnée (+obligatoire en cas de refus)
    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant             | name                          | deskName | type        | mandatoryMetadata! |
            | Circuits unitaires | Cachet serveur                | Marron   | SEAL        | []                 |
#            | Circuits unitaires | Cachet serveur et metadonnees | Marron   | SEAL        | ['succes']         |
            | Circuits unitaires | Mail securise                 | Marron   | SECURE_MAIL | []                 |
#            | Circuits unitaires | Mail securise et metadonnees  | Marron   | SECURE_MAIL | ['succes']         |
            | Circuits unitaires | Signature                     | Marron   | SIGNATURE   | []                 |
#            | Circuits unitaires | Signature et metadonnees      | Marron   | SIGNATURE   | ['succes']         |
            | Circuits unitaires | Visa                          | Marron   | VISA        | []                 |
#            | Circuits unitaires | Visa et metadonnees           | Marron   | VISA        | ['succes']         |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant             | name               | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!       |
            | Circuits unitaires | ACTES - CAdES      | ACTES    | PKCS7           |                   |                  | false             | {}                       |
            | Circuits unitaires | ACTES - PAdES      | ACTES    | PADES           | Montpellier       |                  | true              | {"x":50,"y":50,"page":1} |
            | Circuits unitaires | Automatique        | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":50,"y":50,"page":1} |
            | Circuits unitaires | CAdES              | NONE     | PKCS7           |                   |                  | false             | {}                       |
            | Circuits unitaires | HELIOS - XAdES env | HELIOS   | PES_V2          | Montpellier       | 34000            | false             | {}                       |
            | Circuits unitaires | PAdES              | NONE     | PADES           | Montpellier       |                  | true              | {"x":50,"y":50,"page":1} |
            | Circuits unitaires | XAdES det          | NONE     | PES_V2_DETACHED | Montpellier       | 34000            | false             | {}                       |
            # @fixme (ailleurs ?): protocol NONE -> PES_V2_DETACHED (XAdES det, tous format sauf XML), sinon avec HELIOS, on reste bien sur PES_V2 (XAdES env, uniquement format XML/PES_V2)

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant             | type               | name           | validationWorkflowId | sealCertificateId                                  | secureMailServerId            |
            | Circuits unitaires | ACTES - CAdES      | Mail securise  | Mail securise        |                                                    | Mail securise Pastell cbuffin |
            | Circuits unitaires | ACTES - CAdES      | Signature      | Signature            |                                                    |                               |
            | Circuits unitaires | ACTES - CAdES      | Visa           | Visa                 |                                                    |                               |
            | Circuits unitaires | ACTES - PAdES      | Cachet serveur | Cachet serveur       | Christian Buffin - Default tenant - Cachet serveur |                               |
            | Circuits unitaires | ACTES - PAdES      | Mail securise  | Mail securise        |                                                    | Mail securise Pastell cbuffin |
            | Circuits unitaires | ACTES - PAdES      | Signature      | Signature            |                                                    |                               |
            | Circuits unitaires | ACTES - PAdES      | Visa           | Visa                 |                                                    |                               |
            | Circuits unitaires | Automatique        | Mail securise  | Mail securise        |                                                    | Mail securise Pastell cbuffin |
            | Circuits unitaires | Automatique        | Signature      | Signature            |                                                    |                               |
            | Circuits unitaires | Automatique        | Visa           | Visa                 |                                                    |                               |
            | Circuits unitaires | CAdES              | Mail securise  | Mail securise        |                                                    | Mail securise Pastell cbuffin |
            | Circuits unitaires | CAdES              | Signature      | Signature            |                                                    |                               |
            | Circuits unitaires | CAdES              | Visa           | Visa                 |                                                    |                               |
            | Circuits unitaires | HELIOS - XAdES env | Mail securise  | Mail securise        |                                                    | Mail securise Pastell cbuffin |
            | Circuits unitaires | HELIOS - XAdES env | Signature      | Signature            |                                                    |                               |
            | Circuits unitaires | HELIOS - XAdES env | Visa           | Visa                 |                                                    |                               |
            | Circuits unitaires | PAdES              | Cachet serveur | Cachet serveur       | Christian Buffin - Default tenant - Cachet serveur |                               |
            | Circuits unitaires | PAdES              | Mail securise  | Mail securise        |                                                    | Mail securise Pastell cbuffin |
            | Circuits unitaires | PAdES              | Signature      | Signature            |                                                    |                               |
            | Circuits unitaires | PAdES              | Visa           | Visa                 |                                                    |                               |
            | Circuits unitaires | XAdES det          | Mail securise  | Mail securise        |                                                    | Mail securise Pastell cbuffin |
            | Circuits unitaires | XAdES det          | Signature      | Signature            |                                                    |                               |
            | Circuits unitaires | XAdES det          | Visa           | Visa                 |                                                    |                               |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant             | email             | path                                           |
            | Circuits unitaires | nmarron@dom.local | classpath:files/images/signature - nmarron.png |
