@proposal @ignore @ip4 @setup
Feature: ...
    # ./gradlew test --info -Dkarate.options="--tags @wip" -Dkarate.headless=true -Dkarate.baseUrl=https://iparapheur47.test.libriciel.fr

    Background:
        #* v4.api.rest.user.login("admin", "password")
        # @fixme
        * v4.api.rest.user.login("admin@legacy-bridge", "chei1ahmaesohRaelooGh5")

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

