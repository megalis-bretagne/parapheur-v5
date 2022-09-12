@ip_5 @migration @cdg59 @aniche
    Feature: Vérification des utilisateurs de l'entité "CDG59/Aniche"

    Background:
        * api_v1.auth.login("user", "password")
        * def tenant = "aniche"
        * def tenantId = api_v1.entity.getIdByName(tenant)

    Scenario Outline: Vérification des données de l'utilisateur "${userName}" par liste
        * url baseUrl
        * path "/api/v1/admin/tenant/" + tenantId + "/user"
        * param asc = true
        * param page = 0
        * param pageSize = 50
        * param searchTerm = "<userName>"
        * param sortBy = "LAST_NAME"
        * method GET
        * status 200

        * def jsonPath = "$.data[?(@.userName=='<userName>')]"
        * match karate.jsonPath(response, jsonPath).length == 1

        * match response == schemas.user.index
        * match karate.jsonPath(response, jsonPath)[0] contains __row

        Examples:
            | userName | email                        | firstName | lastName | notificationsRedirectionMail! | notificationsCronFrequency! | complementaryField! | signatureImageContentId! | privilege   | administeredTenants! | administeredDesks! | supervisedDesks! | isChecked! | isLocked! | isLdapSynchronized! | rolesCount! | notifiedOnConfidentialFolders! | notifiedOnLateFolders! | notifiedOnFollowedFolders! |
            | user     | ne-pas-repondre@adrien.local | Sample    | User     | null                          | null                        | null                | null                     | SUPER_ADMIN | null                 | null               | null             | null       | null      | false               | null        | false                          | false                  | false                      |

    Scenario Outline: Vérification des données de l'utilisateur "${userName}" par détails
        * def userId = api_v1.user.getIdByEmail(tenantId, '<email>')

        # Onglets Général, Signature (partiel), Droits
        * url baseUrl
        * path "/api/v1/admin/tenant/" + tenantId + "/user/" + userId
        * method GET
        * status 200

        * match response == schemas.user.element
        # @fixme: supprimer des colonnes de la réponse
        * def expected = __row
#        * delete expected["desktops"]
        * karate.remove("expected", "desktops")
        * match response contains __row

        # Onglet Bureaux (@todo)
        * url baseUrl
        * path "/api/v1/admin/tenant/" + tenantId + "/user/" + userId + "/desks"
        * param page = 0
        * param pageSize = 100
        * method GET
        * status 200

        * match response == schemas.desk.index
        * match karate.jsonPath(response, "$.data[*].name") == desktops

        # Onglet Supervision (@todo)
        # Onglet Gestion d'absences (@todo)

        # @fixme-ip5: les valeurs de notificationsCronFrequency et rolesCount sont correctes ici, mais sont envoyées tout de même à vide dans la liste (test ci-dessus)
        Examples:
            | userName         | email                           | firstName         | lastName     | notificationsRedirectionMail! | notificationsCronFrequency! | complementaryField!                         | signatureImageContentId! | privilege    | administeredTenants! | administeredDesks! | supervisedDesks! | isChecked! | isLocked! | isLdapSynchronized! | rolesCount! | notifiedOnConfidentialFolders! | notifiedOnLateFolders! | notifiedOnFollowedFolders! | desktops! |
            | user             | ne-pas-repondre@adrien.local    | Sample            | User         | null                          | 'none'                      | null                                        | null                     | SUPER_ADMIN  | null                 | null               | null             | null       | null      | false               | 4           | false                          | false                  | false                      | []        |
            | admin@aniche     | s.vast@adullact-projet.cooptest | Administrateur    | Adullact     | null                          | null                        | "Informations complémentaires"              | null                     | TENANT_ADMIN | null                 | null               | null             | null       | null      | false               | 4           | false                          | false                  | false                      | ["Utilisateur VIRTUEL"]        |
