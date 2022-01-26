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

    # @todo: améliorer les associations dans les autres fichiers
#    Scenario Outline: Associate user "${email}" with tenant "${tenant}"
#        * call read('classpath:lib/setup/tenant.user.associate.feature') __row
#
#        Examples:
#            | email                 | tenant   |
#            | nmarron@dom.local     | Circuits unitaires |
#            | ws-cu@dom.local | Circuits unitaires |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant             | name       | owners!               | parent! | associated! | permissions!                                                         |
            | Circuits unitaires | Marron     | ['nmarron@dom.local'] | ''      | []          | {'action': true}                                                     |
            | Circuits unitaires | WebService | ['ws-cu@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

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
            | Circuits unitaires | Maill securise Pastell cbuffin | https://pastell.partenaire.libriciel.fr/ | ws-pa-cbuffin-recette-ip500ea-mailsec | a123456  | 116    |

    # @todo: métadonnée obligatoire en cas de refus
    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant             | name                          | deskName | type        | mandatoryMetadata! |
            | Circuits unitaires | Cachet serveur                | Marron   | SEAL        | []                 |
            | Circuits unitaires | Cachet serveur et metadonnees | Marron   | SEAL        | ['succes']         |
            | Circuits unitaires | Mail securise                 | Marron   | SECURE_MAIL | []                 |
            | Circuits unitaires | Mail securise et metadonnees  | Marron   | SECURE_MAIL | ['succes']         |
            | Circuits unitaires | Signature                     | Marron   | SIGNATURE   | []                 |
            | Circuits unitaires | Signature et metadonnees      | Marron   | SIGNATURE   | ['succes']         |
            | Circuits unitaires | Visa                          | Marron   | VISA        | []                 |
            | Circuits unitaires | Visa et metadonnees           | Marron   | VISA        | ['succes']         |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant             | name  | description | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition! | workflowSelectionScript! |
            | Circuits unitaires | CAdES | CAdES       |          | PKCS7           |                   |                  |                    | ''                       |
            | Circuits unitaires | PAdES | PAdES       |          | PADES           |                   |                  |                    | ''                       |

    # @fixme: secureMailServerId 1
    Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant             | type  | name                          | description                   | workflow!                       | secureMailServerId | sealCertificate!                                     | workflowSelectionScript! | subtypeMetadataRequestList! |
            | Circuits unitaires | CAdES | Cachet serveur                | Cachet serveur                | 'Cachet serveur'                |                    | 'Christian Buffin - Default tenant - Cachet serveur' | ''                       | []                          |
            | Circuits unitaires | CAdES | Cachet serveur et metadonnees | Cachet serveur et metadonnees | 'Cachet serveur et metadonnees' |                    | 'Christian Buffin - Default tenant - Cachet serveur' | ''                       | []                          |
            | Circuits unitaires | CAdES | Mail securise                 | Mail securise                 | 'Mail securise'                 | 1                  | ''                                                   | ''                       | []                          |
            | Circuits unitaires | CAdES | Mail securise et metadonnees  | Mail securise et metadonnees  | 'Mail securise et metadonnees'  | 1                  | ''                                                   | ''                       | []                          |
            | Circuits unitaires | CAdES | Signature                     | Signature                     | 'Signature'                     |                    | ''                                                   | ''                       | []                          |
            | Circuits unitaires | CAdES | Signature et metadonnees      | Signature et metadonnees      | 'Signature et metadonnees'      |                    | ''                                                   | ''                       | []                          |
            | Circuits unitaires | CAdES | Visa                          | Visa                          | 'Visa'                          |                    | ''                                                   | ''                       | []                          |
            | Circuits unitaires | CAdES | Visa et metadonnees           | Visa et metadonnees           | 'Visa et metadonnees'           |                    | ''                                                   | ''                       | []                          |
            | Circuits unitaires | PAdES | Cachet serveur                | Cachet serveur                | 'Cachet serveur'                |                    | 'Christian Buffin - Default tenant - Cachet serveur' | ''                       | []                          |
            | Circuits unitaires | PAdES | Cachet serveur et metadonnees | Cachet serveur et metadonnees | 'Cachet serveur et metadonnees' |                    | 'Christian Buffin - Default tenant - Cachet serveur' | ''                       | []                          |
            | Circuits unitaires | PAdES | Mail securise                 | Mail securise                 | 'Mail securise'                 | 1                  | ''                                                   | ''                       | []                          |
            | Circuits unitaires | PAdES | Mail securise et metadonnees  | Mail securise et metadonnees  | 'Mail securise et metadonnees'  | 1                  | ''                                                   | ''                       | []                          |
            | Circuits unitaires | PAdES | Signature                     | Signature                     | 'Signature'                     |                    | ''                                                   | ''                       | []                          |
            | Circuits unitaires | PAdES | Signature et metadonnees      | Signature et metadonnees      | 'Signature et metadonnees'      |                    | ''                                                   | ''                       | []                          |
            | Circuits unitaires | PAdES | Visa                          | Visa                          | 'Visa'                          |                    | ''                                                   | ''                       | []                          |
            | Circuits unitaires | PAdES | Visa et metadonnees           | Visa et metadonnees           | 'Visa et metadonnees'           |                    | ''                                                   | ''                       | []                          |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant             | email             | path                                           |
            | Circuits unitaires | nmarron@dom.local | classpath:files/images/signature - nmarron.png |
