@recette @ip4 @mhuetter @setup @wip
Feature: Paramétrage IP 4 pour l'entité mhuetter

    Background:
        * configure ssl = true
        * configure readTimeout = 100000
        * ip4.business.api.user.login("admin@mhuetter", "a123456")

    # @todo: image de signature
    Scenario Outline: Création de l'utilisateur "${username}@mhuetter"
        * call read('classpath:lib/ip4/business/api/user/create.feature') __row

        Examples:
            | username   | password | lastName | firstName  | email                                          |
            | emetteur   | a123456  | Emetteur | WebService | emetteur-mhuetter@mailcatchall.libriciel.net   |
            | signature1 | a123456  | Clarins  | Elea       | signature1-mhuetter@mailcatchall.libriciel.net |
            | visa1      | a123456  | Prada    | André      | visa1-mhuetter@mailcatchall.libriciel.net      |

    Scenario Outline: Création du bureau "${name}"
        * call read('classpath:lib/ip4/business/api/desktop/create.feature') __row

        Examples:
            | name       | title      | proprietaires!          | secretaires! |
            | WebService | WebService | ["emetteur@mhuetter"]   | []           |
            | Signature1 | Signature1 | ["signature1@mhuetter"] | []           |
            | Visa1      | Visa1      | ["visa1@mhuetter"]      | []           |

    Scenario Outline: Création du circuit "${name}" à une étape de "${action}" sur le bureau "${desktop}"
        * call read('classpath:lib/ip4/business/api/workflow/createSingleStep.feature') __row

        Examples:
            | name             | action    | desktop    |
            | Signature simple | SIGNATURE | Signature1 |
            | Visa simple      | VISA      | Visa1      |

    Scenario Outline: Création du type "${name}"
        * call read('classpath:lib/ip4/business/api/type/create.feature') __row

        Examples:
            | name          | description | protocol | format      | location    | postalCode |
            | PAdES         | Description | aucun    | PAdES/basic | Montpellier | 34000      |

    Scenario Outline: Création du sous-type "${type} / ${name}"
        * call read('classpath:lib/ip4/business/api/subtype/create.feature') __row
        # @info: permet d'éviter la 503
        * ip.pause(1)

        Examples:
            | type  | name             | description | parapheurs!    | workflow         | multidoc | cachet | mailsec | metadatas! |
            | PAdES | Signature simple | Description | ['WebService'] | Signature simple | false    |        |         | []         |
            | PAdES | Visa simple      | Description | ['WebService'] | Visa simple      | false    |        |         | []         |
