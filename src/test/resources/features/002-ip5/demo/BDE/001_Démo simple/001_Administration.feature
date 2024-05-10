@ip5 @ip-web @l10n @demo-simple-bde @setup @this
Feature: 001 - Scénario de démo simple, partie administration

  Background:
    * configure driver = ip.ui.driver.configure
    * driver baseUrl + ip5.ui.url.logout
    * waitFor('#kc-logout').click()

  @basic
  Scenario: Connexion avec un superadmin
    * ip5.ui.user.login("user", adminUserPwd)

  @basic
  Scenario: Enregistrement de la frequence de notification pour le superadmin
    * ip5.api.v1.auth.login("user", adminUserPwd)
    * ip5.api.v1.user.updateCurrentUserNotificationFrequency('none')

  @basic
  Scenario: Créer une entité
    * ip5.ui.user.login("user", adminUserPwd)
    * call read('classpath:lib/ip5/ui/tenant/create.feature') { tenant: "simple-toDelete" }

  @basic
  Scenario: Supprimer une entité
    * ip5.ui.user.login("user", adminUserPwd)
    * call read('classpath:lib/ip5/ui/tenant/delete.feature') { tenant: "simple-toDelete" }

  @basic
  Scenario: Créer une entité
    * ip5.ui.user.login("user", adminUserPwd)
    * call read('classpath:lib/ip5/ui/tenant/create.feature') { tenant: "Démo simple" }

  @basic
  Scenario Outline: Créer un utilisateur ${role} et connexion avec celui-ci
    * ip5.ui.user.login("user", adminUserPwd)
    * call read('classpath:lib/ip5/ui/user/create.feature') __row
    * ip5.ui.user.logout()
    * ip5.ui.user.login(username, password)

    Examples:
      | tenant      | username                 | lastName  | firstName | email                    | password | role                    |
      | Démo simple | admin@demo-simple        | Demortain | Benoit    | admin@dom.local          | a123456a123456  | Administrateur          |
      | Démo simple | admin-entite@demo-simple | Buffin    | Christian | admin-entite@dom.local   | a123456a123456  | Administrateur d'entité |
      | Démo simple | mpiaumier@demo-simple    | Piaumier  | Matthieu  | mpiaumier-demo@dom.local | a123456a123456  | Aucun privilège         |
      | Démo simple | ws@demo-simple           | Service   | Web       | ws-demo@dom.local        | a123456a123456  | Aucun privilège         |


  @issue-ip-compose-537 @basic
  Scenario Outline: Créer un user sans droit avec notif unitaire et image de signature
    # User creation
    * ip5.ui.user.login("admin-entite@demo-simple", "a123456a123456")
    * call read('classpath:lib/ip5/ui/user/create.feature') __row
    * ip5.ui.user.logout()

    # Adding signature image
    * ip5.api.v1.auth.login("user", adminUserPwd)
    * def existingTenantId = ip5.api.v1.entity.getIdByName("<tenant>")
    * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, "<email>")

    Given url baseUrl
    And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
    And header Accept = 'application/json'
    And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
    When method POST
    Then status 201

    # Setting up notifications
    * ip5.ui.user.login(username, password)
    * ip5.ui.user.menu("{^}Profil")
    * waitFor(ip5.ui.element.breadcrumb("Accueil / Profil"))
    * waitFor("{^}Notifications").click()
    # thead .slider is the "activate all notifications" slider
    * waitFor("thead .slider").click()
    * waitFor("{^}Unitaire").click()
    * waitFor(ip5.ui.locator.button("Enregistrer")).click()

    # TODO (or not) if we really want to check, reload and see if unitary notif are checked

    Examples:
      | tenant      | username               | lastName  | firstName | email                     | password       | role            |
      | Démo simple | flosserand@demo-simple | Losserand | Frédéric  | flosserand-demo@dom.local | a123456a123456 | Aucun privilège |

  Scenario Outline: Créer un bureau ${title} pour ${description} utilisateur sans droit
    * ip5.ui.user.login("admin-entite@demo-simple", "a123456a123456")
    * call read('classpath:lib/ip5/ui/desk/create.feature') __row

    Examples:
      | tenant      | title      | shortName  | owners!                    | permissions!                                                                             | associatedDesks! | description!                                             |
      | Démo simple | DGS        | DGS        | ['mpiaumier@demo-simple']  | ['Traiter des dossiers']                                                                 | []               | utilisateur sans droit                                   |
      | Démo simple | WebService | WebService | ['ws@demo-simple']         | ['Créer des dossiers', 'Traiter des dossiers', 'Traiter des dossiers en fin de circuit'] | []               | WebService                                               |
      | Démo simple | Président  | Président  | ['flosserand@demo-simple'] | ['Traiter des dossiers']                                                                 | ['DGS']          | utilisateur sans droit et association avec le bureau DGS |

  Scenario Outline: Créer un circuit 1 étape de ${type} du bureau ${desk}
    * ip5.ui.user.login("admin-entite@demo-simple", "a123456a123456")
    * call read('classpath:lib/ip5/ui/workflow/create_1_step.feature') __row

    Examples:
      | tenant      | name      | type      | desk      |
      | Démo simple | Signature | Signature | Président |
      | Démo simple | Visa      | Visa      | Président |

  Scenario Outline: Créer un type ACTES/PAdES
    * ip5.ui.user.login("admin-entite@demo-simple", "a123456a123456")
    * call read('classpath:lib/ip5/ui/type/create.feature') __row

    Examples:
      | tenant      | name  | description | protocol | format | ville          | stamp! |
      | Démo simple | ACTES | ACTES       | ACTES    | PAdES  | Pont-à-Mousson | true   |

  Scenario Outline: Créer un sous-type ${type} / ${name} pour le circuit ${workflow}
    * ip5.ui.user.login("admin-entite@demo-simple", "a123456a123456")
    * call read('classpath:lib/ip5/ui/subtype/create.feature') __row

    Examples:
      | tenant      | type  | name         | description  | workflow  |
      | Démo simple | ACTES | Délibération | Délibération | Signature |
      | Démo simple | ACTES | Visa         | Visa         | Visa      |
