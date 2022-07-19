@proposal @ignore @ip4 @setup
Feature: Paramétrage IP 4 pour l'entité legacy-bridge

    Background:
        * v4.api.rest.user.login("admin", "password")

    Scenario Outline: Création du connecteur Pastell mail-sécurisé "${title}"
        * call read('classpath:lib/v4/api/rest/pastellConnector/create.feature') __row

        Examples:
            | title           | url                                      | login                                 | password | entity |
            | Recette mailSec | https://pastell.partenaire.libriciel.fr/ | ws-pa-cbuffin-recette-ip500ea-mailsec | a123456  | 116    |

    Scenario Outline: Création du cachet serveur "${title}"
        * call read('classpath:lib/v4/api/rest/seal/create.feature') __row

        Examples:
            | title  | certificate                                           | password                        | image                                          | text |
            | Cachet | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | classpath:files/images/cachet - benoit xvi.png |      |

    # @todo: image de signature
    Scenario Outline: Création de l'utilisateur "${username}@legacy-bridge"
        * call read('classpath:lib/v4/api/rest/user/create.feature') __row

        Examples:
            | username   | password | lastName  | firstName | email                                                |
            | lvermillon | a123456  | Vermillon | Lukas     | cbuffin+lvermillon-legacy-bridge@libriciel.net       |
            | ws         | a123456  | Web       | Service   | cbuffin+ws-legacy-bridge-legacy-bridge@libriciel.net |

    Scenario Outline: Création du bureau "${name}"
        * call read('classpath:lib/v4/api/rest/desktop/create.feature') __row

        Examples:
            | name       | title      | proprietaires!               | secretaires! |
            | Vermillon  | Vermillon  | ["lvermillon@legacy-bridge"] | []           |
            | WebService | WebService | ["ws@legacy-bridge"]         | []           |

    Scenario Outline: Création du circuit "${name}" à une étape de "${action}" sur le bureau "${desktop}"
        * call read('classpath:lib/v4/api/rest/workflow/createSingleStep.feature') __row

        Examples:
            | name      | action         | desktop   |
            | Cachet    | CACHET         | Vermillon |
            | Mailsec   | MAILSECPASTELL | Vermillon |
            | Signature | SIGNATURE      | Vermillon |
            | Visa      | VISA           | Vermillon |

    Scenario Outline: Création du type "${name}"
        * call read('classpath:lib/v4/api/rest/type/create.feature') __row

        Examples:
            | name          | description | protocol | format      | location    | postalCode |
            | Auto monodoc  | Description | aucun    | AUTO        | Montpellier | 34000      |
            | Auto multidoc | Description | aucun    | AUTO        | Montpellier | 34000      |
            | PAdES         | Description | ACTES    | PAdES/basic | Montpellier | 34000      |

    Scenario Outline: Création du sous-type "${type}/${name}"
        * call read('classpath:lib/v4/api/rest/subtype/create.feature') __row

        Examples:
            | type          | name           | description | parapheurs!    | workflow  | multidoc | cachet | mailsec         | metadatas!                                                                                   |
            | Auto monodoc  | sign avec meta | Description | ['WebService'] | Signature | false    |        |                 | [{id: "mameta_bool", mandatory: "true",editable: "false", default: "", fromCircuit: false }] |
            | Auto monodoc  | sign sans meta | Description | ['WebService'] | Signature | false    |        |                 | []                                                                                           |
            | Auto monodoc  | visa avec meta | Description | ['WebService'] | Visa      | false    |        |                 | [{id: "mameta_bool", mandatory: "true",editable: "false", default: "", fromCircuit: false }] |
            | Auto monodoc  | visa sans meta | Description | ['WebService'] | Visa      | false    |        |                 | []                                                                                           |
            | Auto multidoc | sign avec meta | Description | ['WebService'] | Signature | true     |        |                 | [{id: "mameta_bool", mandatory: "true",editable: "false", default: "", fromCircuit: false }] |
            | Auto multidoc | sign sans meta | Description | ['WebService'] | Signature | true     |        |                 | []                                                                                           |
            | Auto multidoc | visa avec meta | Description | ['WebService'] | Visa      | true     |        |                 | [{id: "mameta_bool", mandatory: "true",editable: "false", default: "", fromCircuit: false }] |
            | Auto multidoc | visa sans meta | Description | ['WebService'] | Visa      | true     |        |                 | []                                                                                           |
            | PAdES         | cachet         | Description | ['WebService'] | Cachet    | false    | Cachet |                 | []                                                                                           |
            | PAdES         | mailsec        | Description | ['WebService'] | Mailsec   | false    |        | Recette mailSec | []                                                                                           |
