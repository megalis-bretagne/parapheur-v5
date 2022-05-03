@business @benoit-xvi @proposal @setup @wip
Feature: Paramétrage métier "Benoit XVI"

    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name       |
            | Benoit XVI |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/setup/metadata.create.feature') __row

        Examples:
            | tenant     | key                  | name                 | type  | restrictedValues!                                                      |
            | Benoit XVI | date_service_fait    | Date du service fait | DATE  | []                                                                     |
            | Benoit XVI | montant              | Montant HT           | FLOAT | []                                                                     |
            | Benoit XVI | service_gestionnaire | Service gestionnaire | TEXT  | ['finances', 'informatique', 'marchés publics', 'ressources humaines'] |

    # @todo: même certificat que Benoît (Test cachet LS + mot de passe)
    Scenario Outline: Create a seal certificate from file "${path}" in "${tenant}"
        * call read('classpath:lib/setup/seal-certificate.create.feature') __row

        Examples:
            | tenant     | path                                                  | password                        | image!                                           |
            | Benoit XVI | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | 'classpath:files/images/cachet - benoit xvi.png' |

    # @todo: même configuration que Benoît (id entité ?)
    Scenario Outline:
        * call read('classpath:lib/setup/secure-mail.create.feature') __row

        Examples:
            | tenant     | name            | url                                      | login                                 | password | entity |
            | Benoit XVI | Recette mailSec | https://pastell.partenaire.libriciel.fr/ | ws-pa-cbuffin-recette-ip500ea-mailsec | a123456  | 116    |

    Scenario: Create external signature config for 'Docage'
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/externalSignature/config'
            And header Accept = 'application/json'
            And request {'name':'SE Docage','url':'https://api.docage.com','serviceName':'docage','login':'signature@libriciel.coop','password':'44ba77ae-f081-49c0-8240-868ef5c69b67'}
        When method POST
        Then status 201

    Scenario: Create external signature config for 'Universign'
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/externalSignature/config'
            And header Accept = 'application/json'
            And request {'name':'SE Universign','url':'https://sign.test.cryptolog.com/sign/rpc/','serviceName':'universign','login':'stephane.vast@libriciel.coop','password':'29Xdx6xW2H8rd9Cs377NCKJyx'}
        When method POST
        Then status 201

    Scenario: Create external signature config for 'Yousign'
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/externalSignature/config'
            And header Accept = 'application/json'
            And request {'name':'SE Yousign','url':'https://staging-api.yousign.com','serviceName':'yousign','token':'d57a9d267085963488746561cf22a02a'}
        When method POST
        Then status 201

    # @todo: Calques d'impression des dossiers

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant     | userName              | email                                                  | firstName   | lastName           | password | privilege    | notificationsCronFrequency | complementaryField |
            | Benoit XVI | admin@demortain       | benoit.demortain+admin50+benoit-xvi@libriciel.coop     | Demortain   | Benoît             | a123456  | TENANT_ADMIN | single_notifications       |                    |
            | Benoit XVI | nboulier@demortain    | benoit.demortain+boulier+benoit-xvi@libriciel.coop     | Natacha     | Boulier            | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | mcaprano@demortain    | benoit.demortain+caprano+benoit-xvi@libriciel.coop     | Marissa     | Caprano            | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | fcarignon@demortain   | benoit.demortain+carignon+benoit-xvi@libriciel.coop    | Francine    | Carignon           | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | dcrouton@demortain    | benoit.demortain+crouton+benoit-xvi@libriciel.coop     | David       | Crouton            | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | aelaissa@demortain    | benoit.demortain+elaissa+benoit-xvi@libriciel.coop     | Aline       | El Aissa           | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | wsgenerique           | benoit.demortain+generique+benoit-xvi@libriciel.coop   | User        | Générique          | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | wsgestionfi           | benoit.demortain+gf+benoit-xvi@libriciel.coop          | User        | Gestion Financière | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | egiscard@demortain    | benoit.demortain+giscard+benoit-xvi@libriciel.coop     | Emilie      | Giscard            | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | fmarlin@demortain     | benoit.demortain+marlin+benoit-xvi@libriciel.coop      | François    | Marlin             | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | rmorbier@demortain    | benoit.demortain+morbier+benoit-xvi@libriciel.coop     | Richard     | Morbier            | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | aparisi@demortain     | benoit.demortain+parisi+benoit-xvi@libriciel.coop      | Alicia      | Parisi             | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | wspastell             | benoit.demortain+pastell+benoit-xvi@libriciel.coop     | User        | Pastell            | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | pperez@demortain      | benoit.demortain+perez+benoit-xvi@libriciel.coop       | Philippe    | Perez              | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | dprimo@demortain      | benoit.demortain+primo+benoit-xvi@libriciel.coop       | David       | Primo              | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | superadmin            | benoit.demortain+test190+benoit-xvi@libriciel.coop     | Toto        | Superadmin         | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | superviseur@demortain | benoit.demortain+superviseur+benoit-xvi@libriciel.coop | Utilisateur | Superviseur        | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | rtarpex@demortain     | benoit.demortain+tarpex+benoit-xvi@libriciel.coop      | Richard     | Tarpex             | a123456  | NONE         | single_notifications       |                    |
            | Benoit XVI | wswebdelib            | benoit.demortain+webdelib+benoit-xvi@libriciel.coop    | User        | Webdelib           | a123456  | NONE         | disabled                   |                    |
            | Benoit XVI | wswebgfc              | benoit.demortain+webgfc+benoit-xvi@libriciel.coop      | User        | Webgfc             | a123456  | NONE         | disabled                   |                    |

    # @todo: ajout de bureaux liés après coup (+ noms courts ?)
    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant     | name                                  | owners!                                                                                                                                 | parent!                              | associated!                                                                                       | permissions!                                                            |
            | Benoit XVI | APPLICATIONS                          | ['sample-user@dom.local']                                                                                                               | ''                                   | []                                                                                                | {}                                                                      |
            | Benoit XVI | Application Générique                 | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+generique+benoit-xvi@libriciel.coop', 'sample-user@dom.local'] | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Application Gestion Financière        | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+gf+benoit-xvi@libriciel.coop']                                 | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Application Pastell                   | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+pastell+benoit-xvi@libriciel.coop']                            | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Application Webdelib                  | ['benoit.demortain+webdelib+benoit-xvi@libriciel.coop']                                                                                 | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Application Webgfc                    | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+webgfc+benoit-xvi@libriciel.coop']                             | 'APPLICATIONS'                       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Consultant Fonctionnel Libriciel SCOP | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop']                                                                                  | ''                                   | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Président du département              | ['benoit.demortain+tarpex+benoit-xvi@libriciel.coop', 'sample-user@dom.local']                                                          | ''                                   | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': false}   |
            | Benoit XVI | 1er Vice Président du Département     | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+primo+benoit-xvi@libriciel.coop']                              | 'Président du département'           | []                                                                                                | {'action': true, 'archiving': false, 'chain': false, 'creation': false} |
            | Benoit XVI | Directrice Générale des Services      | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+carignon+benoit-xvi@libriciel.coop']                           | 'Président du département'           | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Directeur de l'Informatique           | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+perez+benoit-xvi@libriciel.coop']                              | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': false, 'chain': false, 'creation': false} |
            | Benoit XVI | Directeur des Finances                | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+morbier+benoit-xvi@libriciel.coop', 'sample-user@dom.local']   | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': false, 'chain': false, 'creation': false} |
            | Benoit XVI | Directeur des Marchés Publics         | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+crouton+benoit-xvi@libriciel.coop']                            | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Directrice des Ressources Humaines    | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+caprano+benoit-xvi@libriciel.coop']                            | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': false, 'chain': false, 'creation': false} |
            | Benoit XVI | Secrétariat Général                   | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+parisi+benoit-xvi@libriciel.coop']                             | 'Directrice Générale des Services'   | []                                                                                                | {'action': true, 'archiving': true, 'chain': false, 'creation': true}   |
            | Benoit XVI | Service Informatique                  | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+boulier+benoit-xvi@libriciel.coop']                            | 'Directeur de l\'Informatique'       | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Service Finances                      | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+marlin+benoit-xvi@libriciel.coop']                             | 'Directeur des Finances'             | []                                                                                                | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Service des Marchés Publics           | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+giscard+benoit-xvi@libriciel.coop']                            | 'Directeur des Marchés Publics'      | ['Directrice Générale des Services', 'Directeur des Marchés Publics', 'Président du département'] | {'action': true, 'archiving': true, 'chain': true, 'creation': true}    |
            | Benoit XVI | Service des Ressources Humaines       | ['benoit.demortain+admin50+benoit-xvi@libriciel.coop', 'benoit.demortain+parisi+benoit-xvi@libriciel.coop']                             | 'Directrice des Ressources Humaines' | []                                                                                                | {'action': true, 'archiving': true, 'chain': false, 'creation': true}   |

    Scenario Outline: Create "${name}" workflow in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant     | name            | deskName                              | type               | mandatoryValidationMetadata! | mandatoryRejectionMetadata! |
            | Benoit XVI | CS_Dir_MP       | Directeur des Marchés Publics         | SEAL               | []                           | []                          |
            | Benoit XVI | CS_Pres         | Président du département              | SEAL               | []                           | []                          |
            | Benoit XVI | S_BurVar_script | ##VARIABLE_DESK##                     | SIGNATURE          | []                           | []                          |
            | Benoit XVI | S_Consultant    | Consultant Fonctionnel Libriciel SCOP | SIGNATURE          | []                           | []                          |
            | Benoit XVI | Se_Dir_MP       | Directeur des Marchés Publics         | EXTERNAL_SIGNATURE | []                           | []                          |
            | Benoit XVI | S_Pres          | Président du département              | SIGNATURE          | []                           | []                          |
            | Benoit XVI | V_Chefde        | ##BOSS_OF##                           | VISA               | []                           | []                          |
            | Benoit XVI | V_DGS           | Directrice Générale des Services      | VISA               | []                           | []                          |
            | Benoit XVI | V_Pres          | Président du département              | VISA               | []                           | []                          |
            | Benoit XVI | V_Var_SF        | ##VARIABLE_DESK##                     | VISA               | []                           | []                          |

    Scenario: Create "S_CS_Pres" workflow in "Benoit XVI"
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')
        * def presDeskId = api_v1.desk.getIdByName(tenantId, 'Président du département')
        * def id = 's_cs_pres'
        * def payload =
"""
{
    "steps":[
        {"validators":["#(presDeskId)"],"validationMode":"SIMPLE","name":"SIGNATURE","type":"SIGNATURE","parallelType":"OR"},
        {"validators":["#(presDeskId)"],"validationMode":"SIMPLE","name":"SEAL","type":"SEAL","parallelType":"OR"}
    ],
    "name":"S_CS_Pres",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)"
}
"""
        Given url baseUrl
        And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
        And header Accept = 'application/json'
        And request payload
        When method POST
        Then status 201

    Scenario: Create "S_Pres_MS_ServFin" workflow in "Benoit XVI"
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')
        * def presDeskId = api_v1.desk.getIdByName(tenantId, 'Président du département')
        * def finServDeskId = api_v1.desk.getIdByName(tenantId, 'Service Finances')
        * def id = 's_pres_ms_servfin'
        * def payload =
"""
{
    "steps":[
        {"validators":["#(presDeskId)"],"validationMode":"SIMPLE","name":"SIGNATURE","type":"SIGNATURE","parallelType":"OR","mandatoryValidationMetadata":['montant']},
        {"validators":["#(finServDeskId)"],"validationMode":"SIMPLE","name":"SECURE_MAIL","type":"SECURE_MAIL","parallelType":"OR"}
    ],
    "name":"S_Pres_MS_ServFin",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario: Create "S_Var_OU_Pres" workflow in "Benoit XVI"
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')
        * def presDeskId = api_v1.desk.getIdByName(tenantId, 'Président du département')
        * def appDeskId = api_v1.desk.getIdByName(tenantId, 'APPLICATIONS')
        * def id = 's_var_ou_pres'
        * def payload =
"""
{
    "steps":[
        {"validators":["##VARIABLE_DESK##","#(presDeskId)"],"validationMode":"AND","name":"Visa","type":"VISA","parallelType":"AND"},
        {"validators":["#(presDeskId)","#(appDeskId)","##EMITTER##"],"validationMode":"OR","name":"Visa","type":"VISA","parallelType":"OR"}
    ],
    "name":"S_Var_OU_Pres",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario: Create "V_DGSETDirFin_SE_SG_S_PresOU1VP" workflow in "Benoit XVI"
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')
        * def dgsDeskId = api_v1.desk.getIdByName(tenantId, 'Directrice Générale des Services')
        * def dfinDeskId = api_v1.desk.getIdByName(tenantId, 'Directeur des Finances')
        * def secgenDeskId = api_v1.desk.getIdByName(tenantId, 'Secrétariat Général')
        * def presDeskId = api_v1.desk.getIdByName(tenantId, 'Président du département')
        * def premvicepresDeskId = api_v1.desk.getIdByName(tenantId, '1er Vice Président du Département')
        * def id = 'v_dgsetdirfin_se_sg_s_presou1vp'
        * def payload =
"""
{
    "steps":[
        {"validators":["#(dgsDeskId)","#(dfinDeskId)"],"validationMode":"AND","name":"Visa","type":"VISA","parallelType":"AND"},
        {"validators":["#(secgenDeskId)"],"validationMode":"SIMPLE","name":"EXTERNAL_SIGNATURE","type":"EXTERNAL_SIGNATURE","parallelType":"OR"},
        {"validators":["#(presDeskId)","#(premvicepresDeskId)"],"validationMode":"OR","name":"SIGNATURE","type":"SIGNATURE","parallelType":"OR"}
    ],
    "name":"V_DGSETDirFin_SE_SG_S_PresOU1VP",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario: Create "V_DGS_S_PresOU1VP_SE_SG" workflow in "Benoit XVI"
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')
        * def dgsDeskId = api_v1.desk.getIdByName(tenantId, 'Directrice Générale des Services')
        * def presDeskId = api_v1.desk.getIdByName(tenantId, 'Président du département')
        * def premvicepresDeskId = api_v1.desk.getIdByName(tenantId, '1er Vice Président du Département')
        * def secgenDeskId = api_v1.desk.getIdByName(tenantId, 'Secrétariat Général')
        * def id = 'v_dgs_s_presou1vp_se_sg'
        * def payload =
"""
{
    "steps":[
        {"validators":["#(dgsDeskId)"],"validationMode":"SIMPLE","name":"VISA","type":"VISA","parallelType":"OR"},
        {"validators":["#(presDeskId)","#(premvicepresDeskId)"],"validationMode":"OR","name":"SIGNATURE","type":"SIGNATURE","parallelType":"OR"},
        {"validators":["#(secgenDeskId)"],"validationMode":"SIMPLE","name":"EXTERNAL_SIGNATURE","type":"EXTERNAL_SIGNATURE","parallelType":"OR"}
    ],
    "name":"V_DGS_S_PresOU1VP_SE_SG",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario: Create "VVS_Chefde" workflow in "Benoit XVI"
        * def tenantId = api_v1.entity.getIdByName('Benoit XVI')
        * def id = 'vs_chefde'
        * def payload =
"""
{
    "steps":[
        {"validators":["##BOSS_OF##"],"validationMode":"SIMPLE","name":"VISA","type":"VISA","parallelType":"OR"},
        {"validators":["##BOSS_OF##"],"validationMode":"SIMPLE","name":"VISA","type":"VISA","parallelType":"OR"},
        {"validators":["##BOSS_OF##"],"validationMode":"SIMPLE","name":"SIGNATURE","type":"SIGNATURE","parallelType":"OR"},
    ],
    "name":"VVS_Chefde",
    "id":"#(id)",
    "key":"#(id)",
    "deploymentId":"#(id)"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

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
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant     | type               | name                        | annotationsAllowed! | multiDocuments! | creationPermittedDeskIds!                                                                                                               | creationWorkflowId | validationWorkflowId            | externalSignatureConfigId | sealAutomatic! | sealCertificateId                                  | secureMailServerId | digitalSignatureMandatory! |
            | Benoit XVI | ACTES              | Arrêté                      | false               | false           | ['Application Générique', 'Application Pastell', 'Application Webdelib', 'Secrétariat Général']                                         |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | ACTES              | Délibération                | false               | false           | ['Application Générique', 'Application Pastell', 'Application Webdelib', 'Secrétariat Général']                                         |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | ACTES              | Délibération à finaliser    | true                | false           | ['Application Générique', 'Application Pastell', 'Application Webdelib', 'Secrétariat Général']                                         | V_DGS              | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | BONS DE COMMANDE   | Bon de commande             | false               | false           | ['Application Gestion Financière', 'Application Générique', 'Application Pastell', 'Service des Marchés Publics']                       |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | BONS DE COMMANDE   | Bon de commande sign Pres   | false               | false           | ['Application Gestion Financière', 'Application Générique', 'Application Pastell', 'Service Finances']                                  |                    | S_Pres_MS_ServFin               |                           | null           |                                                    | Recette mailSec    | true                       |
            | Benoit XVI | CONVENTIONS        | Conv. à cosigner externe    | false               | false           | ['Application Générique', 'Application Pastell', 'Secrétariat Général', 'Service des Marchés Publics']                                  |                    | V_DGSETDirFin_SE_SG_S_PresOU1VP | SE Docage                 | null           |                                                    |                    | true                       |
            | Benoit XVI | CONVENTIONS        | Convention à signer         | false               | false           | ['Service Finances', 'Service Informatique', 'Service des Marchés Publics', 'Service des Ressources Humaines']                          |                    | VVS_Chefde                      |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | CONVENTIONS        | Convention à viser          | false               | true            | ['Application Générique', 'Service Finances', 'Service Informatique', 'Service des Marchés Publics', 'Service des Ressources Humaines'] |                    | V_Pres                          |                           | null           |                                                    |                    | false                      |
            | Benoit XVI | COURRIERS          | Courrier à cacheter         | true                | false           | ['Application Générique', 'Service Finances', 'Service Informatique', 'Service des Marchés Publics', 'Service des Ressources Humaines'] |                    | CS_Pres                         |                           | true           | Christian Buffin - Default tenant - Cachet serveur |                    | false                      |
            | Benoit XVI | COURRIERS          | Courrier à signer Président | true                | false           | ['Application Générique', 'Service Finances', 'Service Informatique', 'Service des Marchés Publics', 'Service des Ressources Humaines'] | V_Chefde           | S_CS_Pres                       |                           | true           | Christian Buffin - Default tenant - Cachet serveur |                    | true                       |
            | Benoit XVI | DOCUMENTS INTERNES | Document à signer           | false               | false           | ['Application Générique']                                                                                                               |                    | S_Consultant                    |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | FACTURES           | Service Fait                | false               | false           | ['Service Finances']                                                                                                                    |                    | V_Var_SF                        |                           | null           |                                                    |                    | false                      |
            | Benoit XVI | MARCHES AUTO       | Acte d'Engagement           | false               | false           | ['Directeur des Marchés Publics', 'Service des Marchés Publics']                                                                        |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | MARCHES AUTO       | Acte Engagement Sign Pres   | false               | false           | ['Application Générique']                                                                                                               |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | MARCHES CADES      | Acte d'Engagement           | false               | true            | ['Directeur des Marchés Publics', 'Service des Marchés Publics']                                                                        |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | MARCHES PADES      | Acte d'Engagement           | false               | true            | ['Application Pastell', 'Directeur des Marchés Publics', 'Service des Marchés Publics']                                                 |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | MARCHES XADES      | Acte d'Engagement           | false               | true            | ['Directeur des Marchés Publics', 'Service des Marchés Publics']                                                                        |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |
            | Benoit XVI | PES                | Bordereau                   | false               | false           | ['Application Gestion Financière', 'Application Pastell', 'Service Finances']                                                           |                    | S_Pres                          |                           | null           |                                                    |                    | true                       |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant     | email                                               | path                                                       |
            | Benoit XVI | benoit.demortain+admin50+benoit-xvi@libriciel.coop  | classpath:files/images/signature - admin@demortain.png     |
            | Benoit XVI | benoit.demortain+carignon+benoit-xvi@libriciel.coop | classpath:files/images/signature - fcarignon@demortain.png |
            | Benoit XVI | benoit.demortain+tarpex+benoit-xvi@libriciel.coop   | classpath:files/images/signature - rtarpex@demortain.png   |
