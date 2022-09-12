@ip_5 @migration @cdg59 @aniche @wip
    Feature: Vérification des utilisateurs de l'entité "CDG59/Aniche"

    Background:
        * api_v1.auth.login("user", "password")
        * def tenant = "Default tenant"

    Scenario Outline: Vérification de l'utilisateur "${userName}"
        * def tenantId = api_v1.entity.getIdByName(tenant)
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
