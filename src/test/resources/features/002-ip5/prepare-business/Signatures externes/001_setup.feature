@prepare-business @ip5 @signatures-externes @setup
Feature: Paramétrage métier 'Signatures externes'

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)

    Scenario Outline: Create tenant '${name}'
        * call read('classpath:lib/ip5/api/setup/tenant.create.feature') __row

        Examples:
            | name                |
            | Signatures externes |

    Scenario Outline: Create user '${userName}' with role '${privilege}' in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/user.create.feature') __row

        Examples:
            | tenant              | userName | email             | firstName | lastName | password | privilege | notificationsCronFrequency | complementaryField                                               |
            | Signatures externes | anankin  | anankin@dom.local | Amélie    | Nankin   | a123456  | NONE      | disabled                   | TITRE='Responsable des méthodes',VILLE='Agde',CODEPOSTAL='34300' |
            | Signatures externes | ws-se    | ws-se@dom.local   | Service   | Web      | a123456  | NONE      | disabled                   |                                                                  |

    Scenario Outline: Create desk '${name}' in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

        Examples:
            | tenant              | name       | owners!               | parent! | associated! | permissions!                                                         |
            | Signatures externes | Nankin     | ['anankin@dom.local'] | ''      | []          | {'action': true}                                                     |
            | Signatures externes | WebService | ['ws-se@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create external signature "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/external-signature.create.feature') __row

        Examples:
            | tenant              | name       | url                                       | serviceName | login                        | password                             | token                            |
            | Signatures externes | Docage     | https://api.docage.com                    | docage      | signature@libriciel.coop     | 44ba77ae-f081-49c0-8240-868ef5c69b67 |                                  |
            | Signatures externes | Universign | https://sign.test.cryptolog.com/sign/rpc/ | universign  | stephane.vast@libriciel.coop | 29Xdx6xW2H8rd9Cs377NCKJyx            |                                  |
            | Signatures externes | Yousign    | https://staging-api.yousign.com           | yousign     |                              |                                      | d57a9d267085963488746561cf22a02a |

    Scenario Outline: Create a seal certificate from file '${path}' in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/seal-certificate.create.feature') __row

        Examples:
            | tenant              | path                                                  | password                        | image!                                                     |
            | Signatures externes | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | 'classpath:files/images/cachet - formats de signature.png' |

    Scenario Outline: Create '${name}' one-step-workflow and associate it to the '${deskName}' desk in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant              | name                | deskName | type               |
            | Signatures externes | Signatures externes | Nankin   | EXTERNAL_SIGNATURE |

    Scenario Outline: Create a 2 steps "${name}" workflow - ${type1} on ${desk1}, ${type2} on ${desk2}
        * def tenantId = ip5.api.v1.entity.getIdByName('Signatures externes')
        * def desk1Id = ip5.api.v1.desk.getIdByName(tenantId, desk1)
        * def desk2Id = ip5.api.v1.desk.getIdByName(tenantId, desk2)
        * def payload =
"""
{
    "steps":[
        {"validatingDeskIds":["#(desk1Id)"],"type":"#(type1)","parallelType":"OR"},
        {"validatingDeskIds":["#(desk2Id)"],"type":"#(type2)","parallelType":"OR"}
    ],
    "name":"#(name)",
    "id":"#(key)",
    "key":"#(key)",
    "deploymentId":"#(key)",
    "finalDeskId": "##EMITTER##"
}
"""
      Given url baseUrl
          And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
          And header Accept = 'application/json'
          And request payload
      When method POST
      Then status 201

      Examples:
          | name                                      | key                                   | desk1  | type1              | desk2  | type2              |
          | Cachet serveur - Signatures externes      | cachet_serveur-_signature_externe     | Nankin | SEAL               | Nankin | EXTERNAL_SIGNATURE |
          | Signature - Signatures externes           | signature-_signature_externe          | Nankin | SIGNATURE          | Nankin | EXTERNAL_SIGNATURE |
          | Signatures externes - Cachet serveur      | signature_externe_-_cachet_serveur    | Nankin | EXTERNAL_SIGNATURE | Nankin | SEAL               |
          | Signatures externes - Signature           | signature_externe_-_signature         | Nankin | EXTERNAL_SIGNATURE | Nankin | SIGNATURE          |
          | Signatures externes - Signatures externes | signature_externe_-_signature_externe | Nankin | EXTERNAL_SIGNATURE | Nankin | EXTERNAL_SIGNATURE |

    Scenario: Create a 4 steps "Signature - Signatures externes - Signatures externes - Cachet serveur" workflow
        * def tenantId = ip5.api.v1.entity.getIdByName('Signatures externes')
        * def deskId = ip5.api.v1.desk.getIdByName(tenantId, 'Nankin')
        * def payload =
"""
{
    "steps":[
        {"validatingDeskIds":["#(deskId)"],"type":"SIGNATURE","parallelType":"OR"},
        {"validatingDeskIds":["#(deskId)"],"type":"EXTERNAL_SIGNATURE","parallelType":"OR"},
        {"validatingDeskIds":["#(deskId)"],"type":"EXTERNAL_SIGNATURE","parallelType":"OR"},
        {"validatingDeskIds":["#(deskId)"],"type":"SEAL","parallelType":"OR"}
    ],
    "name":"Signature - Signatures externes - Signatures externes - Cachet serveur",
    "id":"signature_-_signature_externe_-_signature_externe_-_cachet_serveur",
    "key":"signature_-_signature_externe_-_signature_externe_-_cachet_serveur",
    "deploymentId":"signature_-_signature_externe_-_signature_externe_-_cachet_serveur",
    "finalDeskId": "##EMITTER##"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario Outline: Create type '${name}' with '${signatureFormat}' signature format in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/type.create.feature') __row

        Examples:
            | tenant              | name          | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
            | Signatures externes | ACTES - PAdES | ACTES    | PADES           | Montpellier       |                  | true              | {'x':0,'y':0,'page':1} |
            | Signatures externes | Automatique   | NONE     | AUTO            | Montpellier       | 34000            | true              | {'x':0,'y':0,'page':1} |
            | Signatures externes | Circuits      | NONE     | PADES           | Montpellier       |                  | true              | {'x':0,'y':0,'page':1} |
            | Signatures externes | PAdES         | NONE     | PADES           | Montpellier       |                  | true              | {'x':0,'y':0,'page':1} |

    Scenario Outline: Create subtype '${name}' for type '${type}' and '${validationWorkflowId}' workflow in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/subtype.create.feature') __row

        Examples:
            | tenant              | type          | name                         | multiDocuments! | validationWorkflowId                                                   | sealAutomatic! | sealCertificateId                                  | secureMailServerId | externalSignatureConfigId |
            | Signatures externes | ACTES - PAdES | Docage - Signature           | false           | Signatures externes                                                    | null           |                                                    |                    | Docage                    |
            | Signatures externes | ACTES - PAdES | Universign - Signature       | false           | Signatures externes                                                    | null           |                                                    |                    | Universign                |
            | Signatures externes | ACTES - PAdES | Yousign - Signature          | false           | Signatures externes                                                    | null           |                                                    |                    | Yousign                   |
            | Signatures externes | Automatique   | Docage - Signature           | false           | Signatures externes                                                    | null           |                                                    |                    | Docage                    |
            | Signatures externes | Automatique   | Universign - Signature       | false           | Signatures externes                                                    | null           |                                                    |                    | Universign                |
            | Signatures externes | Automatique   | Yousign - Signature          | false           | Signatures externes                                                    | null           |                                                    |                    | Yousign                   |
            | Signatures externes | Automatique   | Docage - Signature multi     | true            | Signatures externes                                                    | null           |                                                    |                    | Docage                    |
            | Signatures externes | Automatique   | Universign - Signature multi | true            | Signatures externes                                                    | null           |                                                    |                    | Universign                |
            | Signatures externes | Circuits      | Yousign - CS - SE            | true            | Cachet serveur - Signatures externes                                   | null           | Christian Buffin - Default tenant - Cachet serveur |                    | Yousign                   |
            | Signatures externes | Circuits      | Yousign - S - SE             | true            | Signature - Signatures externes                                        | null           |                                                    |                    | Yousign                   |
            | Signatures externes | Circuits      | Yousign - S - SE - SE - CS   | true            | Signature - Signatures externes - Signatures externes - Cachet serveur | null           | Christian Buffin - Default tenant - Cachet serveur |                    | Yousign                   |
            | Signatures externes | Circuits      | Yousign - SE - CS            | true            | Signatures externes - Cachet serveur                                   | null           | Christian Buffin - Default tenant - Cachet serveur |                    | Yousign                   |
            | Signatures externes | Circuits      | Yousign - SE - S             | true            | Signatures externes - Signature                                        | null           |                                                    |                    | Yousign                   |
            | Signatures externes | Circuits      | Yousign - SE - SE            | true            | Signatures externes - Signatures externes                              | null           |                                                    |                    | Yousign                   |
            | Signatures externes | PAdES         | Docage - Signature           | false           | Signatures externes                                                    | null           |                                                    |                    | Docage                    |
            | Signatures externes | PAdES         | Universign - Signature       | false           | Signatures externes                                                    | null           |                                                    |                    | Universign                |
            | Signatures externes | PAdES         | Yousign - Signature          | false           | Signatures externes                                                    | null           |                                                    |                    | Yousign                   |
            | Signatures externes | PAdES         | Docage - Signature multi     | true            | Signatures externes                                                    | null           |                                                    |                    | Docage                    |
            | Signatures externes | PAdES         | Universign - Signature multi | true            | Signatures externes                                                    | null           |                                                    |                    | Universign                |
            | Signatures externes | PAdES         | Yousign - Signature multi    | true            | Signatures externes                                                    | null           |                                                    |                    | Yousign                   |

    Scenario Outline: Set the signature image for user '${email}'
        * call read('classpath:lib/ip5/api/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant              | email             | path                                           |
            | Signatures externes | anankin@dom.local | classpath:files/images/signature - anankin.png |
