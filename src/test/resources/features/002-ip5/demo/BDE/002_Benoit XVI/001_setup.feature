@ip5 @business @benoit-xvi @setup
# @info: circuits pas employés dans les sous-types (et donc commentés) CS_Dir_MP, Se_Dir_MP, S_Var_OU_Pres, V_DGS_S_PresOU1VP_SE_SG
# @todo: vérifier sur la plate-forme de recette
# @todo: pour le circuit, essayer du type selectionCircuit { circuit "signature_helios"; } -> issue
# @todo: paramétrage Pastell, id 59 (pastell formations) (conv à cosigner externe), export BDE azerty11 (SIGN_MP_CONVENTIONS_V5_azerty11.json)

Feature: Paramétrage métier "Benoit XVI"

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/ip5/api/setup/tenant.create.feature') __row

        Examples:
            | name       |
            | Benoit XVI |

    Scenario Outline: Associate user "${email}" with tenant "${tenant}"
        * call read('classpath:lib/ip5/api/setup/tenant.user.associate.feature') __row

        Examples:
            | email                 | tenant     |
            | ne-pas-repondre@dom.local | Benoit XVI |

    # @info: montant et service_gestionnaire -> dans le script de sélection du sous-type BONS DE COMMANDE/Bon de commande (benoit-xvi-bdc-bdc.groovy)
    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/ip5/api/setup/metadata.create.feature') __row

        Examples:
            | tenant     | key                  | name                 | type  | restrictedValues!                                                      |
            | Benoit XVI | date_service_fait    | Date du service fait | DATE  | []                                                                     |
            | Benoit XVI | montant              | Montant HT           | FLOAT | []                                                                     |
            | Benoit XVI | service_gestionnaire | Service gestionnaire | TEXT  | ['finances', 'informatique', 'marchés publics', 'ressources humaines'] |

    Scenario Outline: Create a seal certificate from file "${path}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/seal-certificate.create.feature') __row

        Examples:
            | tenant     | path                                                  | password                        | image!                                           |
            | Benoit XVI | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | 'classpath:files/images/cachet - benoit xvi.png' |

    Scenario Outline: Create a secure mail configuration "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/secure-mail.create.feature') __row

        Examples:
            | tenant     | name            | url                                      | login                                 | password | entity |
            | Benoit XVI | Recette mailSec | https://pastell.partenaire.libriciel.fr/ | ws-pa-cbuffin-recette-ip500ea-mailsec | a123456a123456  | 116    |

    Scenario Outline: Create external signature "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/external-signature.create.feature') __row

        Examples:
            | tenant     | name          | url                                       | serviceName | login                        | password                             | token                            |
            | Benoit XVI | SE Docage     | https://api.docage.com                    | docage      | signature@libriciel.coop     | 44ba77ae-f081-49c0-8240-868ef5c69b67 |                                  |
            | Benoit XVI | SE Universign | https://sign.test.cryptolog.com/sign/rpc/ | universign  | stephane.vast@libriciel.coop | 29Xdx6xW2H8rd9Cs377NCKJyx            |                                  |
            | Benoit XVI | SE Yousign    | https://staging-api.yousign.com           | yousign     |                              |                                      | d57a9d267085963488746561cf22a02a |

    Scenario Outline: Create layer "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/layer.create.feature') __row

        Examples:
            | tenant     | name           |
#            | Benoit XVI | Test calque    |
            | Benoit XVI | Test calque SF |

    Scenario Outline: Create stamp for layer "${layer}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/stamp.create.feature') __row

        Examples:
            | tenant     | layer          | file!                                                     | payload!                                                                                                                                                                                                                        |
#            | Benoit XVI | Test calque    | null                                                      | { "afterSignature": true, "fontSize": 10, "page": -1, "signatureRank": 0, "textColor": "BLACK", "type": "TEXT", "value": "Ce document est signé électroniquement", "x": 50, "y": 50 }                                           |
            | Benoit XVI | Test calque SF | 'classpath:files/images/calque - tampon_service_fait.png' | { "afterSignature": false, "fontSize": 10, "height": 0, "page": -1, "pageRotation": 0, "rectangleOrigin": "TOP_RIGHT", "signatureRank": 0, "textColor": "BLACK", "type": "IMAGE", "value": null, "width": 0, "x": 50, "y": 50 } |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/user.create.feature') __row

        Examples:
            | tenant     | userName                         | email                                                  | firstName   | lastName           | password | privilege    | notificationsCronFrequency | complementaryField | administeredDesk |
            | Benoit XVI | admin@demortain-benoit-xvi       | benoit.demortain+admin50+benoit-xvi@libriciel.coop     | Demortain   | Benoît             | a123456a123456  | TENANT_ADMIN | single_notifications       |                    |                  |
            | Benoit XVI | nboulier@demortain-benoit-xvi    | benoit.demortain+boulier+benoit-xvi@libriciel.coop     | Natacha     | Boulier            | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | mcaprano@demortain-benoit-xvi    | benoit.demortain+caprano+benoit-xvi@libriciel.coop     | Marissa     | Caprano            | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | fcarignon@demortain-benoit-xvi   | benoit.demortain+carignon+benoit-xvi@libriciel.coop    | Francine    | Carignon           | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | dcrouton@demortain-benoit-xvi    | benoit.demortain+crouton+benoit-xvi@libriciel.coop     | David       | Crouton            | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | aelaissa@demortain-benoit-xvi    | benoit.demortain+elaissa+benoit-xvi@libriciel.coop     | Aline       | El Aissa           | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | wsgenerique@demortain-benoit-xvi | benoit.demortain+generique+benoit-xvi@libriciel.coop   | User        | Générique          | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | wsgestionfi@demortain-benoit-xvi | benoit.demortain+gf+benoit-xvi@libriciel.coop          | User        | Gestion Financière | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | egiscard@demortain-benoit-xvi    | benoit.demortain+giscard+benoit-xvi@libriciel.coop     | Emilie      | Giscard            | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | fmarlin@demortain-benoit-xvi     | benoit.demortain+marlin+benoit-xvi@libriciel.coop      | François    | Marlin             | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | rmorbier@demortain-benoit-xvi    | benoit.demortain+morbier+benoit-xvi@libriciel.coop     | Richard     | Morbier            | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | aparisi@demortain-benoit-xvi     | benoit.demortain+parisi+benoit-xvi@libriciel.coop      | Alicia      | Parisi             | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | wspastell@demortain-benoit-xvi   | benoit.demortain+pastell+benoit-xvi@libriciel.coop     | User        | Pastell            | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | pperez@demortain-benoit-xvi      | benoit.demortain+perez+benoit-xvi@libriciel.coop       | Philippe    | Perez              | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | dprimo@demortain-benoit-xvi      | benoit.demortain+primo+benoit-xvi@libriciel.coop       | David       | Primo              | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | superadmin@demortain-benoit-xvi  | benoit.demortain+test190+benoit-xvi@libriciel.coop     | Toto        | Superadmin         | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | superviseur@demortain-benoit-xvi | benoit.demortain+superviseur+benoit-xvi@libriciel.coop | Utilisateur | Superviseur        | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | rtarpex@demortain-benoit-xvi     | benoit.demortain+tarpex+benoit-xvi@libriciel.coop      | Richard     | Tarpex             | a123456a123456  | NONE         | single_notifications       |                    |                  |
            | Benoit XVI | wswebdelib@demortain-benoit-xvi  | benoit.demortain+webdelib+benoit-xvi@libriciel.coop    | User        | Webdelib           | a123456a123456  | NONE         | disabled                   |                    |                  |
            | Benoit XVI | wswebgfc@demortain-benoit-xvi    | benoit.demortain+webgfc+benoit-xvi@libriciel.coop      | User        | Webgfc             | a123456a123456  | NONE         | disabled                   |                    |                  |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/ip5/api/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant     | email                                               | path                                                                  |
            | Benoit XVI | benoit.demortain+admin50+benoit-xvi@libriciel.coop  | classpath:files/images/signature - admin@demortain-benoit-xvi.png     |
            | Benoit XVI | benoit.demortain+carignon+benoit-xvi@libriciel.coop | classpath:files/images/signature - fcarignon@demortain-benoit-xvi.png |
            | Benoit XVI | benoit.demortain+tarpex+benoit-xvi@libriciel.coop   | classpath:files/images/signature - rtarpex@demortain-benoit-xvi.png   |
            | Benoit XVI | benoit.demortain+primo+benoit-xvi@libriciel.coop    | classpath:files/images/signature - dprimo@demortain-benoit-xvi.png    |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

        Examples:
            | tenant     | name                                  | shortName               | owners!                                                                                                                                 | parent!                              | associated!                                                                                       | permissions!                                                            |
            | Benoit XVI | APPLICATIONS                          | APPLICATIONS            | ['ne-pas-repondre@dom.local']                                                                                                               | ''                                   | []                                                                                                | {}                                                                      |
            | Benoit XVI | Application Générique                 | Application Générique   | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+generique+benoit-xvi@libriciel.coop', 'ne-pas-repondre@dom.local'] | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Application Gestion Financière        | GF                      | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+gf+benoit-xvi@libriciel.coop']                                 | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Application Pastell                   | Application Pastell     | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+pastell+benoit-xvi@libriciel.coop']                            | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Application Webdelib                  | Application Webdelib    | ['benoit.demortain+webdelib+benoit-xvi@libriciel.coop']                                                                                 | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Application Webgfc                    | Application Webgfc      | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+webgfc+benoit-xvi@libriciel.coop']                             | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Consultant Fonctionnel Libriciel SCOP | Consultant              | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop']                                                                                  | ''                                   | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Président du département              | President Departement   | ['benoit.demortain+tarpex+benoit-xvi@libriciel.coop', 'ne-pas-repondre@dom.local']                                                          | ''                                   | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': false}   |
            | Benoit XVI | 1er Vice Président du Département     | 1er VP                  | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+primo+benoit-xvi@libriciel.coop']                              | 'Président du département'           | []                                                                                                | {'action': true, 'archiving': false, 'chain': false, 'creation': false} |
            | Benoit XVI | Directrice Générale des Services      | DGS                     | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+carignon+benoit-xvi@libriciel.coop']                           | 'Président du département'           | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Directeur de l'Informatique           | Directeur Informatique  | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+perez+benoit-xvi@libriciel.coop']                              | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': false, 'chain': false, 'creation': false} |
            | Benoit XVI | Directeur des Finances                | Directeur Finances      | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+morbier+benoit-xvi@libriciel.coop', 'ne-pas-repondre@dom.local']   | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': false, 'chain': false, 'creation': false} |
            | Benoit XVI | Directeur des Marchés Publics         | Directeur MP            | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+crouton+benoit-xvi@libriciel.coop']                            | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Directrice des Ressources Humaines    | Directrice RH           | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+caprano+benoit-xvi@libriciel.coop']                            | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': false, 'chain': false, 'creation': false} |
            | Benoit XVI | Secrétariat Général                   | SG                      | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+parisi+benoit-xvi@libriciel.coop']                             | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': true, 'chain': false, 'creation': true}   |
            | Benoit XVI | Service Informatique                  | Service Informatique    | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+boulier+benoit-xvi@libriciel.coop']                            | 'Directeur de l\'Informatique'       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Service Finances                      | Service Finances        | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+marlin+benoit-xvi@libriciel.coop']                             | 'Directeur des Finances'             | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Service des Marchés Publics           | Service Marches Publics | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+giscard+benoit-xvi@libriciel.coop']                            | 'Directeur des Marchés Publics'      | ['Directrice Générale des Services', 'Directeur des Marchés Publics', 'Président du département'] | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Service des Ressources Humaines       | Service RH              | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+parisi+benoit-xvi@libriciel.coop']                            | 'Directrice des Ressources Humaines' | []                                                                                                 | {'action': true, 'archiving': true, 'chain': false, 'creation': true}   |
    # @fixme: ne fait rien en dom.local (même via l'UI)
    Scenario Outline: Update desk "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/desk.update.feature') __row

        Examples:
            | tenant     | name                     | shortName             | owners!                                                                        | parent! | associated!                                                     | permissions!                                                          |
            | Benoit XVI | Président du département | President Departement | ['benoit.demortain+tarpex+benoit-xvi@libriciel.coop', 'ne-pas-repondre@dom.local'] | ''      | ['Directeur des Finances', '1er Vice Président du Département'] | {'action': true, 'archiving': true, 'chain': true, 'creation': false} |

    Scenario Outline: Create "${name}" workflow in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant     | name            | deskName                              | type               | mandatoryValidationMetadata! | mandatoryRejectionMetadata! |
#            | Benoit XVI | CS_Dir_MP       | Directeur des Marchés Publics         | SEAL               | []                           | []                          |
            | Benoit XVI | CS_Pres         | Président du département              | SEAL               | []                           | []                          |
            | Benoit XVI | S_BurVar_script | ##VARIABLE_DESK##                     | SIGNATURE          | []                           | []                          |
            | Benoit XVI | S_Consultant    | Consultant Fonctionnel Libriciel SCOP | SIGNATURE          | []                           | []                          |
#            | Benoit XVI | Se_Dir_MP       | Directeur des Marchés Publics         | EXTERNAL_SIGNATURE | []                           | []                          |
            | Benoit XVI | S_Pres          | Président du département              | SIGNATURE          | []                           | []                          |
            | Benoit XVI | V_Chefde        | ##BOSS_OF##                           | VISA               | []                           | []                          |
            | Benoit XVI | V_DGS           | Directrice Générale des Services      | VISA               | []                           | []                          |
            | Benoit XVI | V_Pres          | Président du département              | VISA               | []                           | []                          |
            | Benoit XVI | V_Var_SF        | ##VARIABLE_DESK##                     | VISA               | ['date_service_fait']        | []                          |

    Scenario: Create "S_CS_Pres" workflow in "Benoit XVI"
        * def tenantId = ip5.api.v1.entity.getIdByName('Benoit XVI')
        * def presDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Président du département')
        * def id = 's_cs_pres'
        * def payload =
"""
{
    "steps":[
        {"validatingDeskIds":["#(presDeskId)"],"type":"SIGNATURE","parallelType":"OR"},
        {"validatingDeskIds":["#(presDeskId)"],"type":"SEAL","parallelType":"OR"}
    ],
    "name":"S_CS_Pres",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)",
    "finalDeskId": "##EMITTER##"
}
"""
        Given url baseUrl
        And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
        And header Accept = 'application/json'
        And request payload
        When method POST
        Then status 201

    Scenario: Create "S_Pres_MS_ServFin" workflow in "Benoit XVI"
        * def tenantId = ip5.api.v1.entity.getIdByName('Benoit XVI')
        * def presDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Président du département')
        * def finServDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Service Finances')
        * def metadataId = ip5.api.v1.metadata.getIdByKey(tenantId, 'montant')
        * def id = 's_pres_ms_servfin'
        * def payload =
"""
{
    "steps":[
        {"validatingDeskIds":["#(presDeskId)"],"type":"SIGNATURE","parallelType":"OR","mandatoryValidationMetadataIds":['#(metadataId)']},
        {"validatingDeskIds":["#(finServDeskId)"],"type":"SECURE_MAIL","parallelType":"OR"}
    ],
    "name":"S_Pres_MS_ServFin",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)",
    "finalDeskId": "##EMITTER##"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    # @info: bureaux spéciaux dans les étapes ET/OU plus possible depuis la 5.0.0-beta29 - https://gitlab.libriciel.fr/libriciel/pole-signature/iparapheur-v5/compose/-/issues/305
    # @info: ce circuit n'est pas autorisé
#    Scenario: Create "S_Var_OU_Pres" workflow in "Benoit XVI"
#        * def tenantId = ip5.api.v1.entity.getIdByName('Benoit XVI')
#        * def presDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Président du département')
#        * def appDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'APPLICATIONS')
#        * def id = 's_var_ou_pres'
#        * def payload =
#"""
#{
#    "steps":[
#        {"validators":["##VARIABLE_DESK##","#(presDeskId)"],"validationMode":"AND","name":"Visa","type":"VISA","parallelType":"AND"},
#        {"validators":["#(presDeskId)","#(appDeskId)","##EMITTER##"],"validationMode":"OR","name":"Visa","type":"VISA","parallelType":"OR"}
#    ],
#    "name":"S_Var_OU_Pres",
#    "id":"#(id)",
#    "key":"#(id)",
#    "deploymentId":"#(id)"
#}
#"""
#        Given url baseUrl
#            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
#            And header Accept = 'application/json'
#            And request payload
#        When method POST
#        Then status 201

    Scenario: Create "V_DGSETDirFin_SE_SG_S_PresOU1VP" workflow in "Benoit XVI"
        * def tenantId = ip5.api.v1.entity.getIdByName('Benoit XVI')
        * def dgsDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Directrice Générale des Services')
        * def dfinDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Directeur des Finances')
        * def secgenDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Secrétariat Général')
        * def presDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Président du département')
        * def premvicepresDeskId = ip5.api.v1.desk.getIdByName(tenantId, '1er Vice Président du Département')
        * def id = 'v_dgsetdirfin_se_sg_s_presou1vp'
        * def payload =
"""
{
    "steps":[
        {"validatingDeskIds":["#(dgsDeskId)","#(dfinDeskId)"],"type":"VISA","parallelType":"AND"},
        {"validatingDeskIds":["#(secgenDeskId)"],"type":"EXTERNAL_SIGNATURE","parallelType":"OR"},
        {"validatingDeskIds":["#(presDeskId)","#(premvicepresDeskId)"],"type":"SIGNATURE","parallelType":"OR"}
    ],
    "name":"V_DGSETDirFin_SE_SG_S_PresOU1VP",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)",
    "finalDeskId": "##EMITTER##"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

#    Scenario: Create "V_DGS_S_PresOU1VP_SE_SG" workflow in "Benoit XVI"
#        * def tenantId = ip5.api.v1.entity.getIdByName('Benoit XVI')
#        * def dgsDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Directrice Générale des Services')
#        * def presDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Président du département')
#        * def premvicepresDeskId = ip5.api.v1.desk.getIdByName(tenantId, '1er Vice Président du Département')
#        * def secgenDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Secrétariat Général')
#        * def id = 'v_dgs_s_presou1vp_se_sg'
#        * def payload =
#"""
#{
#    "steps":[
#        {"validators":["#(dgsDeskId)"],"validationMode":"SIMPLE","name":"VISA","type":"VISA","parallelType":"OR"},
#        {"validators":["#(presDeskId)","#(premvicepresDeskId)"],"validationMode":"OR","name":"SIGNATURE","type":"SIGNATURE","parallelType":"OR"},
#        {"validators":["#(secgenDeskId)"],"validationMode":"SIMPLE","name":"EXTERNAL_SIGNATURE","type":"EXTERNAL_SIGNATURE","parallelType":"OR"}
#    ],
#    "name":"V_DGS_S_PresOU1VP_SE_SG",
#    "id":"#(id)",
#    "key":"#(id)",
#    "deploymentId":"#(id)"
#}
#"""
#        Given url baseUrl
#            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
#            And header Accept = 'application/json'
#            And request payload
#        When method POST
#        Then status 201

    Scenario: Create "VVS_Chefde" workflow in "Benoit XVI"
        * def tenantId = ip5.api.v1.entity.getIdByName('Benoit XVI')
        * def id = 'vs_chefde'
        * def payload =
"""
{
    "steps":[
        {"validatingDeskIds":["##BOSS_OF##"],"type":"VISA","parallelType":"OR"},
        {"validatingDeskIds":["##BOSS_OF##"],"type":"VISA","parallelType":"OR"},
        {"validatingDeskIds":["##BOSS_OF##"],"type":"SIGNATURE","parallelType":"OR"},
    ],
    "name":"VVS_Chefde",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)",
    "finalDeskId": "##EMITTER##"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/type.create.feature') __row

        Examples:
            | tenant     | name               | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!        |
            | Benoit XVI | ACTES              | ACTES    | PADES           | Montpellier       |                  | true              | {"x":350,"y":50,"page":0} |
            | Benoit XVI | BONS DE COMMANDE   | NONE     | PADES           | Montpellier       |                  | true              | {"x":100,"y":50,"page":0} |
            | Benoit XVI | CONVENTIONS        | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":350,"y":50,"page":1} |
            | Benoit XVI | COURRIERS          | NONE     | PADES           | GIVORS            |                  | false             | {"x":358,"y":50,"page":1} |
            | Benoit XVI | DOCUMENTS INTERNES | NONE     | PADES           | Givors            |                  | true              | {"x":350,"y":50,"page":1} |
            | Benoit XVI | FACTURES           | NONE     | PADES           | Montpellier       |                  | true              | {"x":350,"y":50,"page":0} |
            | Benoit XVI | MARCHES AUTO       | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":350,"y":50,"page":0} |
            | Benoit XVI | MARCHES CADES      | NONE     | PKCS7           |                   |                  | false             | {}                        |
            | Benoit XVI | MARCHES PADES      | NONE     | PADES           | Montpellier       |                  | true              | {"x":350,"y":50,"page":0} |
            | Benoit XVI | MARCHES XADES      | NONE     | XADES_DETACHED  | Montpellier       | 34000            | false             | {}                        |
            | Benoit XVI | PES                | HELIOS   | PES_V2          | Lyon              | 69000            | false             | {}                        |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/subtype.create.feature') __row

        Examples:
            | tenant     | type               | name                        | annotationsAllowed! | multiDocuments! | creationPermittedDeskIds!                                                                                                               | creationWorkflowId | validationWorkflowId            | externalSignatureConfigId | sealAutomatic! | sealCertificateId                                  | secureMailServerId | digitalSignatureMandatory! | workflowSelectionScript!                                            | subtypeLayerList!                         |
            | Benoit XVI | ACTES              | Arrêté                      | false               | false           | ['Application Générique', 'Application Pastell', 'Application Webdelib', 'Secrétariat Général']                                         |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | ACTES              | Délibération                | false               | false           | ['Application Générique', 'Application Pastell', 'Application Webdelib', 'Secrétariat Général']                                         |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | ACTES              | Délibération à finaliser    | true                | false           | ['Application Générique', 'Application Pastell', 'Application Webdelib', 'Secrétariat Général']                                         | V_DGS              | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | BONS DE COMMANDE   | Bon de commande             | false               | false           | ['Application Gestion Financière', 'Application Générique', 'Application Pastell', 'Service des Marchés Publics']                       |                    |                                 |                           | null           |                                                    |                    | true                       | 'classpath:files/workflowSelectionScript/benoit-xvi-bdc-bdc.groovy' | []                                        |
            | Benoit XVI | BONS DE COMMANDE   | Bon de commande sign Pres   | false               | false           | ['Application Gestion Financière', 'Application Générique', 'Application Pastell', 'Service Finances']                                  |                    | S_Pres_MS_ServFin               |                           | null           |                                                    | Recette mailSec    | true                       |                                                                     | []                                        |
            | Benoit XVI | CONVENTIONS        | Conv. à cosigner externe    | false               | false           | ['Application Générique', 'Application Pastell', 'Secrétariat Général', 'Service des Marchés Publics']                                  |                    | V_DGSETDirFin_SE_SG_S_PresOU1VP | SE Docage                 | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | CONVENTIONS        | Convention à signer         | false               | false           | ['Service Finances', 'Service Informatique', 'Service des Marchés Publics', 'Service des Ressources Humaines']                          |                    | VVS_Chefde                      |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | CONVENTIONS        | Convention à viser          | false               | true            | ['Application Générique', 'Service Finances', 'Service Informatique', 'Service des Marchés Publics', 'Service des Ressources Humaines'] |                    | V_Pres                          |                           | null           |                                                    |                    | false                      |                                                                     | []                                        |
            | Benoit XVI | COURRIERS          | Courrier à cacheter         | true                | false           | ['Application Générique', 'Service Finances', 'Service Informatique', 'Service des Marchés Publics', 'Service des Ressources Humaines'] |                    | CS_Pres                         |                           | true           | Christian Buffin - Default tenant - Cachet serveur |                    | false                      |                                                                     | []                                        |
            | Benoit XVI | COURRIERS          | Courrier à signer Président | true                | false           | ['Application Générique', 'Service Finances', 'Service Informatique', 'Service des Marchés Publics', 'Service des Ressources Humaines'] | V_Chefde           | S_CS_Pres                       |                           | true           | Christian Buffin - Default tenant - Cachet serveur |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | DOCUMENTS INTERNES | Document à signer           | false               | false           | ['Application Générique']                                                                                                               |                    | S_Consultant                    |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | FACTURES           | Service Fait                | false               | false           | ['Service Finances']                                                                                                                    |                    | V_Var_SF                        |                           | null           |                                                    |                    | false                      |                                                                     | [ { "Test calque SF": "MAIN_DOCUMENT" } ] |
            | Benoit XVI | MARCHES AUTO       | Acte d'Engagement           | false               | false           | ['Directeur des Marchés Publics', 'Service des Marchés Publics']                                                                        |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | MARCHES AUTO       | Acte Engagement Sign Pres   | false               | false           | ['Application Générique']                                                                                                               |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | MARCHES CADES      | Acte d'Engagement           | false               | true            | ['Directeur des Marchés Publics', 'Service des Marchés Publics']                                                                        |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | MARCHES PADES      | Acte d'Engagement           | false               | true            | ['Application Pastell', 'Directeur des Marchés Publics', 'Service des Marchés Publics']                                                 |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | MARCHES XADES      | Acte d'Engagement           | false               | true            | ['Directeur des Marchés Publics', 'Service des Marchés Publics']                                                                        |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
            | Benoit XVI | PES                | Bordereau                   | false               | false           | ['Application Gestion Financière', 'Application Pastell', 'Service Finances']                                                           |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |                                                                     | []                                        |
