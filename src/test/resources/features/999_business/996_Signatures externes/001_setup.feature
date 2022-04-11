@business @signature-externe @proposal @setup
Feature: Paramétrage métier 'Signature externe'

    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant '${name}'
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name              |
            | Signature externe |

    Scenario Outline: Create user '${userName}' with role '${privilege}' in '${tenant}'
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant            | userName | email             | firstName | lastName | password | privilege | notificationsCronFrequency | complementaryField                                               |
            | Signature externe | anankin  | anankin@dom.local | Amélie    | Nankin   | a123456  | NONE      | disabled                   | TITRE='Responsable des méthodes',VILLE='Agde',CODEPOSTAL='34300' |
            | Signature externe | ws-se    | ws-se@dom.local   | Service   | Web      | a123456  | NONE      | disabled                   |                                                                  |

    Scenario Outline: Create desk '${name}' in '${tenant}'
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant            | name       | owners!               | parent! | associated! | permissions!                                                         |
            | Signature externe | Nankin     | ['anankin@dom.local'] | ''      | []          | {'action': true}                                                     |
            | Signature externe | WebService | ['ws-se@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario: Create external signature config for 'Docage'
        * def tenantId = api_v1.entity.getIdByName('Signature externe')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/externalSignature/config'
            And header Accept = 'application/json'
            And request {'name':'Docage','url':'https://api.docage.com','serviceName':'docage','login':'signature@libriciel.coop','password':'44ba77ae-f081-49c0-8240-868ef5c69b67'}
        When method POST
        Then status 201

    Scenario: Create external signature config for 'Universign'
        * def tenantId = api_v1.entity.getIdByName('Signature externe')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/externalSignature/config'
            And header Accept = 'application/json'
            And request {'name':'Universign','url':'https://sign.test.cryptolog.com/sign/rpc/','serviceName':'universign','login':'stephane.vast@libriciel.coop','password':'29Xdx6xW2H8rd9Cs377NCKJyx'}
        When method POST
        Then status 201

    Scenario: Create external signature config for 'Yousign'
        * def tenantId = api_v1.entity.getIdByName('Signature externe')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/externalSignature/config'
            And header Accept = 'application/json'
            And request {'name':'Yousign','url':'https://staging-api.yousign.com','serviceName':'yousign','token':'d57a9d267085963488746561cf22a02a'}
        When method POST
        Then status 201

    Scenario Outline: Create a seal certificate from file '${path}' in '${tenant}'
        * call read('classpath:lib/setup/seal-certificate.create.feature') __row

        Examples:
            | tenant               | path                                                  | password                        | image!                                                     |
            | Signature externe | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | 'classpath:files/images/cachet - formats de signature.png' |

    # SE | SE - SE | CS - SE | S - SE | SE - CS | SE - S
    Scenario Outline: Create '${name}' one-step-workflow and associate it to the '${deskName}' desk in '${tenant}'
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant            | name              | deskName | type               |
            | Signature externe | Signature externe | Nankin   | EXTERNAL_SIGNATURE |

    Scenario Outline: Create a 2 steps "${name}" workflow - ${type1} on ${desk1}, ${type2} on ${desk2}
        * def tenantId = api_v1.entity.getIdByName('Signature externe')
        * def desk1Id = api_v1.desk.getIdByName(tenantId, desk1)
        * def desk2Id = api_v1.desk.getIdByName(tenantId, desk2)
        * def payload =
"""
{
    "steps":[
        {"validators":["#(desk1Id)"],"validationMode":"SIMPLE","name":"#(type1)","type":"#(type1)","parallelType":"OR"},
        {"validators":["#(desk2Id)"],"validationMode":"SIMPLE","name":"#(type1)","type":"#(type2)","parallelType":"OR"}
    ],
    "name":"#(name)",
    "id":"#(key)",
    "key":"#(key)",
    "deploymentId":"#(key)"
}
"""
      Given url baseUrl
          And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
          And header Accept = 'application/json'
          And request payload
      When method POST
      Then status 201

      Examples:
          | name                                  | key                                   | desk1  | type1              | desk2  | type2              |
          | Cachet serveur - Signature externe    | cachet_serveur-_signature_externe     | Nankin | SEAL               | Nankin | EXTERNAL_SIGNATURE |
          | Signature - Signature externe         | signature-_signature_externe          | Nankin | SIGNATURE          | Nankin | EXTERNAL_SIGNATURE |
          | Signature externe - Cachet serveur    | signature_externe_-_cachet_serveur    | Nankin | EXTERNAL_SIGNATURE | Nankin | SEAL               |
          | Signature externe - Signature         | signature_externe_-_signature         | Nankin | EXTERNAL_SIGNATURE | Nankin | SIGNATURE          |
          | Signature externe - Signature externe | signature_externe_-_signature_externe | Nankin | EXTERNAL_SIGNATURE | Nankin | EXTERNAL_SIGNATURE |

    Scenario Outline: Create type '${name}' with '${signatureFormat}' signature format in '${tenant}'
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant            | name          | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
            | Signature externe | ACTES - PAdES | ACTES    | PADES           | Montpellier       |                  | true              | {'x':0,'y':0,'page':1} |
            | Signature externe | Automatique   | NONE     | AUTO            | Montpellier       | 34000            | true              | {'x':0,'y':0,'page':1} |
            | Signature externe | Circuits      | NONE     | PADES           | Montpellier       |                  | true              | {'x':0,'y':0,'page':1} |
            | Signature externe | PAdES         | NONE     | PADES           | Montpellier       |                  | true              | {'x':0,'y':0,'page':1} |

    Scenario Outline: Create subtype '${name}' for type '${type}' and '${validationWorkflowId}' workflow in '${tenant}'
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant            | type          | name                         | multiDocuments! | validationWorkflowId                  | sealAutomatic! | sealCertificateId                                  | secureMailServerId | externalSignatureConfigId |
            | Signature externe | ACTES - PAdES | Docage - Signature           | false           | Signature externe                     | null           |                                                    |                    | Docage                    |
            | Signature externe | ACTES - PAdES | Universign - Signature       | false           | Signature externe                     | null           |                                                    |                    | Universign                |
            | Signature externe | ACTES - PAdES | Yousign - Signature          | false           | Signature externe                     | null           |                                                    |                    | Yousign                   |
            | Signature externe | Automatique   | Docage - Signature           | false           | Signature externe                     | null           |                                                    |                    | Docage                    |
            | Signature externe | Automatique   | Universign - Signature       | false           | Signature externe                     | null           |                                                    |                    | Universign                |
            | Signature externe | Automatique   | Yousign - Signature          | false           | Signature externe                     | null           |                                                    |                    | Yousign                   |
            | Signature externe | Automatique   | Docage - Signature multi     | true            | Signature externe                     | null           |                                                    |                    | Docage                    |
            | Signature externe | Automatique   | Universign - Signature multi | true            | Signature externe                     | null           |                                                    |                    | Universign                |
            | Signature externe | Circuits      | Yousign - CS - SE            | true            | Cachet serveur - Signature externe    | null           | Christian Buffin - Default tenant - Cachet serveur |                    | Yousign                   |
            | Signature externe | Circuits      | Yousign - S - SE             | true            | Signature - Signature externe         | null           |                                                    |                    | Yousign                   |
            | Signature externe | Circuits      | Yousign - SE - CS            | true            | Signature externe - Cachet serveur    | null           | Christian Buffin - Default tenant - Cachet serveur |                    | Yousign                   |
            | Signature externe | Circuits      | Yousign - SE - S             | true            | Signature externe - Signature         | null           |                                                    |                    | Yousign                   |
            | Signature externe | Circuits      | Yousign - SE - SE            | true            | Signature externe - Signature externe | null           |                                                    |                    | Yousign                   |
            | Signature externe | PAdES         | Docage - Signature           | false           | Signature externe                     | null           |                                                    |                    | Docage                    |
            | Signature externe | PAdES         | Universign - Signature       | false           | Signature externe                     | null           |                                                    |                    | Universign                |
            | Signature externe | PAdES         | Yousign - Signature          | false           | Signature externe                     | null           |                                                    |                    | Yousign                   |
            | Signature externe | PAdES         | Docage - Signature multi     | true            | Signature externe                     | null           |                                                    |                    | Docage                    |
            | Signature externe | PAdES         | Universign - Signature multi | true            | Signature externe                     | null           |                                                    |                    | Universign                |
            | Signature externe | PAdES         | Yousign - Signature multi    | true            | Signature externe                     | null           |                                                    |                    | Yousign                   |

    Scenario Outline: Set the signature image for user '${email}'
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant            | email             | path                                           |
            | Signature externe | anankin@dom.local | classpath:files/images/signature - anankin.png |
