@proposal @ignore @ip4 @setup
Feature: ...
    # ./gradlew test --info -Dkarate.options="--tags @wip" -Dkarate.headless=true -Dkarate.baseUrl=https://iparapheur47.test.libriciel.fr

    Background:
        * v4.api.rest.user.login("admin", "password")

    Scenario Outline: Création du cachet serveur "${title}"
        * call read('classpath:lib/v4/api/rest/seal/create.feature') __row

        Examples:
            | title  | certificate                                           | password                        | image                                          | text |
            | Cachet | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | classpath:files/images/cachet - benoit xvi.png |      |

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
@x-wip
    # @todo: ...avec meta, PAdES/cachet, PAdES/mailsec
    # cachetCertificate:	"0dc73c67-e0e4-4548-879e-5d63e430715f"
    # pastellMailsec: "9943c0ca-8f44-4a75-97ed-6b45ce0cf3b3"
    Scenario Outline: Création du sous-type "${type}/${name}"
        * call read('classpath:lib/v4/api/rest/subtype/create.feature') __row

        Examples:
            | type          | name           | description | workflow  | multidoc |
            | Auto monodoc  | sign sans meta | Description | Signature | false    |
            | Auto monodoc  | visa sans meta | Description | Visa      | false    |
            | Auto multidoc | sign sans meta | Description | Signature | true     |
            | Auto multidoc | visa sans meta | Description | Visa      | true     |
            | PAdES         | signature      | Description | Signature | true     |
            | PAdES 1       | cachet         | Description | Signature | true     |

