Feature: Vérification des utilisateurs de l'entité "CDG59/Aniche"

  Background:
    * configure driver = ip.ui.driver.configure
    * driver baseUrl + ip5.ui.url.logout
    * def tenant = "aniche"

  Scenario Outline: Envoi de ${count} dossier(s) "${nameTemplate}" dans le circuit pour le sous-type ${type} / ${subtype}
    * def params =
"""
{
    tenant: '<tenant>',
    desktop: '<desk>',
    type: '<type>',
    subtype: '<subtype>',
    mainFile: '<document>',
    nameTemplate: '<nameTemplate>',
    annotation: '<annotation>',
    username: '<username>',
}
"""

    * ip5.api.v1.auth.login('user', 'password')
    * def folders = ip5.api.v1.desk.draft.getPayloadMonodoc(params, <count>, {}, 1)
    * ip5.api.v1.auth.login('<username>', '<password>')
    * def result = call read('classpath:lib/ip5/api/draft/create-and-send-monodoc-without-annex.feature') folders


    Examples:
      | username | password | desk          | document                                                | type            | subtype           | nameTemplate               | count! | annotation |
      | user     | password | Admin CREATIC | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | signature PADES | signature MONODOC | Délibération PDF %counter% | 2      | démarrage  |

  Scenario Outline: ${action} sur le dossier "${name}" (ACTES/Visa)
    * ip5.ui.user.login('<username>', '<password>')

    * click("{a}" + desktop)
    * click("{a}" + name)

    * if(action != 'Signature') click("//*[contains(normalize-space(text()), '" + action + "')]/ancestor-or-self::button")
    * if(action != 'Signature') ip5.ui.folder.annotate.both(username, action, name)
    * if(action != 'Signature') click("{^}Valider")
    * if(action != 'Signature') waitFor(ip5.ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

    * if(action == 'Signature') ip5.api.v1.auth.login('<username>', '<password>')
    * if(action == 'Signature') karate.call("classpath:lib/ip5/business/api/folder/sign.feature", { tenant: tenant, annotation: "signature", username: "<username>", desktop: "<desktop>", certificate: "signature", folder: "<name>"})



    Examples:
      | name               | action    | username | password | desktop       |
      | Délibération PDF 1 | Signature | user     | password | Admin CREATIC |
      | Délibération PDF 2 | Rejet     | user     | password | Admin CREATIC |

  @wip
  Scenario Outline: Vérification des dossiers rejetés
    * ip5.api.v1.auth.login('<username>', '<password>')
    * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
    * def desktop = ip5.business.api.desktop.getByName(tenantId, desktop)
    * def params =
"""
{
    searchData: '<name>',
    state: "#('<status>'.toUpperCase())"
}
"""

    Given url baseUrl
    And path '/api/v1/tenant/' + tenantId + '/desk/' + desktop.id + '/search/' + status
    And header Accept = 'application/json'
    * param asc = true
    * param page = 0
    * param pageSize = 50
    * param sortBy = "FOLDER_NAME"
    And request params
    When method POST
    Then status 200
    * match karate.jsonPath(response, "$.data").length == 1
    * match karate.jsonPath(response, "$.data[0].name") == "<name>"

    Examples:
      | name               | username | password | desktop       | status   |
      | Délibération PDF 1 | user     | password | Admin CREATIC | finished |
      | Délibération PDF 2 | user     | password | Admin CREATIC | rejected |
