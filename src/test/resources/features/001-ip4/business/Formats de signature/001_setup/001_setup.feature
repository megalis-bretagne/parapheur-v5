@business @ip4 @formats-de-signature @setup
Feature: Paramétrage IP 4 métier pour l'entité "fds ("Formats de signature")

    Background:
        * configure ssl = true
        * configure readTimeout = 100000
        * ip4.business.api.user.login("admin@fds", "a123456")

    Scenario Outline: Création du cachet serveur "${title}"
        * call read('classpath:lib/ip4/business/api/seal/create.feature') __row

        Examples:
            | title  | certificate                                           | password                        | image                                          | text |
            | Cachet | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | classpath:files/images/cachet - benoit xvi.png |      |

    Scenario Outline: Création de l'utilisateur "${username}@fds"
        * call read('classpath:lib/ip4/business/api/user/create.feature') __row

        Examples:
            | username | password | lastName | firstName | email                                       |
            | fgarance | a123456  | Garance  | Florence  | fgarance-fds-ip4@mailcatchall.libriciel.net |
            | gnacarat | a123456  | Nacarat  | Gilles    | gnacarat-fds-ip4@mailcatchall.libriciel.net |
            | ws       | a123456  | Web      | Service   | ws-fds-ip4@mailcatchall.libriciel.net       |

    Scenario Outline: Ajout des informations complémentaires de l'utilisateur "${username}@fds"
        * def rv = call read('classpath:lib/ip4/business/api/user/search.feature') { username: "#(__row.username)" }
        * def user = rv.response[0]
        * user.metadata = __row.metadata
        * call read('classpath:lib/ip4/business/api/user/update.feature') user

        Examples:
            | username | metadata                                                         |
            | gnacarat | TITRE="Responsable des méthodes",VILLE="Agde",CODEPOSTAL="34300" |

    # @todo: ajouter au scénario précédent
    # @todo: image de signature, autres options à la modif
    # @todo: rôle / droits
    # @todo: notifications -> PUT https://ip4.dom.local/iparapheur/proxy/alfresco/parapheur/utilisateurs/bf568a87-150c-4738-8887-6d64967fa654/notifications
    # Rôle administrateur -> {"admin":"admin","isAdmin":true,"isAdminFonctionnel":false,"bureauxAdministres":[]}
    # Rôle utilisateur -> {"admin":"aucun","isAdmin":false,"isAdminFonctionnel":false,"bureauxAdministres":[]}
    # Rôle admin fonctionnel avec 1 bureau -> {"admin":"adminFonctionnel","isAdmin":false,"isAdminFonctionnel":true,"bureauxAdministres":["07997e12-2908-471b-b198-831e57a6fc67"]}

    Scenario Outline: Ajout de l'image de signature pour l'utilisateur "${username}@fds"
        * def rv = call read('classpath:lib/ip4/business/api/user/search.feature') { username: "#(__row.username)" }
        * def user = rv.response[0]
        * def Base64 = Java.type('java.util.Base64')
        * def encoded = Base64.getEncoder().encodeToString(karate.read(path));
        * user.signatureData = encoded
        * call read('classpath:lib/ip4/business/api/user/update.feature') user

        Examples:
            | username | path                                            |
            | fgarance | classpath:files/images/signature - fgarance.png |
            | gnacarat | classpath:files/images/signature - gnacarat.png |

#    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
#        * call read('classpath:lib/ip5/api/setup/user.create.feature') __row
#
#        Examples:
#            | tenant               | userName | email              | firstName | lastName | password | privilege | notificationsCronFrequency | complementaryField                                               |
#            | Formats de signature | fgarance | fgarance@dom.local | Florence  | Garance  | a123456  | NONE      | disabled                   |                                                                  |
#            | Formats de signature | gnacarat | gnacarat@dom.local | Gilles    | Nacarat  | a123456  | NONE      | disabled                   | TITRE="Responsable des méthodes",VILLE="Agde",CODEPOSTAL="34300" |
#            | Formats de signature | ws-fds   | ws-fds@dom.local   | Service   | Web      | a123456  | NONE      | disabled                   |                                                                  |

    # @info -> OK, mais il manque éventuellement des options, voir la requête envoyée
    # @todo: permissions (plus tard) -> "hab_enabled":true,"hab_enchainement":true,"hab_archivage":true,"hab_traiter":true,"hab_transmettre":true,"hab_secretariat":false
    # POST https://ip4.dom.local/iparapheur/proxy/alfresco/parapheur/bureaux
    # {"delegations-possibles":[],"metadatas-visibility":[],"proprietaires":[{"firstName":"Gilles","lastName":"Nacarat","metadata":"TITRE=\"Responsable des méthodes\",VILLE=\"Agde\",CODEPOSTAL=\"34300\"","hasCertificate":false,"isSecretaire":false,"isFromLdap":false,"id":"bf568a87-150c-4738-8887-6d64967fa654","isAdmin":false,"isProprietaire":false,"email":"gnacarat-fds-ip4@mailcatchall.libriciel.net","username":"gnacarat@fds","isAdminFonctionnel":false,"admin":"aucun","groups":[],"bureauxAdministres":[],"signature":"b43bd216-b6bf-4b5c-8d12-d018beb2ae77"}],"secretaires":[],"description":"description","profondeur":0,"name":"nom_court","title":"titre","hab_enabled":true,"hab_enchainement":true,"hab_archivage":true,"hab_traiter":true,"hab_transmettre":true,"hab_secretariat":false}

    Scenario Outline: Création du bureau "${name}"
        * call read('classpath:lib/ip4/business/api/desktop/create.feature') __row

        Examples:
            | name       | title      | proprietaires!                   | secretaires! |
            | Nacarat    | Nacarat    | ["fgarance@fds", "gnacarat@fds"] | []           |
            | WebService | WebService | ["ws@fds"]                       | []           |

#        Examples:
#            | tenant               | name       | owners!                                      | parent! | associated! | permissions!                                                         |
#            | Formats de signature | Nacarat    | ['fgarance@dom.local', 'gnacarat@dom.local'] | ''      | []          | {'action': true}                                                     |
#            | Formats de signature | WebService | ['ws-fds@dom.local']                         | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Création du circuit "${name}" à une étape de "${action}" sur le bureau "${desktop}"
        * call read('classpath:lib/ip4/business/api/workflow/createSingleStep.feature') __row

        Examples:
            | name      | action    | desktop |
            | Cachet    | CACHET    | Nacarat |
            | Signature | SIGNATURE | Nacarat |

    # @todo: position de signature à la modification
    Scenario Outline: Création du type "${name}"
        * call read('classpath:lib/ip4/business/api/type/create.feature') __row
        # @info: permet d'éviter la 503
        * ip.pause(1)

        Examples:
            | name               | description        | protocol | format          | location    | postalCode |
            | ACTES - CAdES      | ACTES - CAdES      | ACTES    | PKCS#7/single   | Montpellier | 34000      |
            | ACTES - PAdES      | ACTES - PAdES      | ACTES    | PAdES/basic     | Montpellier | 34000      |
            | Automatique        | Automatique        | aucun    | AUTO            | Montpellier | 34000      |
            | CAdES              | CAdES              | aucun    | PKCS#7/single   | Montpellier | 34000      |
            | HELIOS - XAdES env | HELIOS - XAdES env | HELIOS   | XAdES/enveloped | Montpellier | 34000      |
            | PAdES              | PAdES              | aucun    | PAdES/basic     | Montpellier | 34000      |
            | XAdES det          | XAdES det          | aucun    | XAdES/detached  | Montpellier | 34000      |

    Scenario Outline: Position de la signature pour le type "${id}"
         * call read('classpath:lib/ip4/business/api/type/overridePades.feature') __row
        # @info: permet d'éviter la 503
        * ip.pause(1)

        Examples:
            | id            | active! | stamp!                            |
            | ACTES - PAdES | true    | {"page": "1", "x": "0", "y": "0"} |
            | Automatique   | true    | {"page": "1", "x": "0", "y": "0"} |
            | PAdES         | true    | {"page": "1", "x": "0", "y": "0"} |

    Scenario Outline: Création du sous-type "${type} / ${name}"
        * call read('classpath:lib/ip4/business/api/subtype/create.feature') __row
        # @info: permet d'éviter la 503
        * ip.pause(1)

        Examples:
            | type               | name                         | description                  | parapheurs!    | multidoc | cachet | workflow  | isCachetAuto |
            | ACTES - CAdES      | Signature                    | Signature                    | ['WebService'] | false    |        | Signature |              |
            | ACTES - PAdES      | Cachet serveur               | Cachet serveur               | ['WebService'] | false    | Cachet | Cachet    | false        |
            | ACTES - PAdES      | Cachet serveur auto          | Cachet serveur auto          | ['WebService'] | false    | Cachet | Cachet    | true         |
            | ACTES - PAdES      | Signature                    | Signature                    | ['WebService'] | false    |        | Signature |              |
            | Automatique        | Signature                    | Signature                    | ['WebService'] | false    |        | Signature |              |
            | Automatique        | Signature multidoc           | Signature multidoc           | ['WebService'] | true     |        | Signature |              |
            | CAdES              | Signature                    | Signature                    | ['WebService'] | false    |        | Signature |              |
            | CAdES              | Signature multidoc           | Signature multidoc           | ['WebService'] | true     |        | Signature |              |
            | HELIOS - XAdES env | Signature                    | Signature                    | ['WebService'] | false    |        | Signature |              |
            | PAdES              | Cachet serveur               | Cachet serveur               | ['WebService'] | false    | Cachet | Cachet    | false        |
            | PAdES              | Cachet serveur auto          | Cachet serveur auto          | ['WebService'] | false    | Cachet | Cachet    | true         |
            | PAdES              | Cachet serveur multidoc      | Cachet serveur multidoc      | ['WebService'] | true     | Cachet | Cachet    | false        |
            | PAdES              | Cachet serveur multidoc auto | Cachet serveur multidoc auto | ['WebService'] | true     | Cachet | Cachet    | true         |
            | PAdES              | Signature                    | Signature                    | ['WebService'] | false    |        | Signature |              |
            | PAdES              | Signature multidoc           | Signature multidoc           | ['WebService'] | true     |        | Signature |              |
            | XAdES det          | Signature                    | Signature                    | ['WebService'] | false    |        | Signature |              |
