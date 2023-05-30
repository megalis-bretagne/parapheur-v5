@karate-function @ignore
    Feature: User setup lib

    Scenario: Create user
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
        * def associatedTenantIds = [tenantId]
        * def complementaryField = ip.utils.isEmpty(__row['complementaryField']) === undefined ? null : __row['complementaryField']
        * def administeredDeskName = __row['administeredDesk'];
        * def administeredDeskId = ip.utils.isNullOrEmpty(administeredDeskName) ? null : ip5.api.v1.desk.getIdByName(tenantId, administeredDeskName);
        * def administeredDesks = administeredDeskId === null ? [] : [administeredDeskId]
        * def complementaryField = ip.utils.isEmpty(__row['complementaryField']) === undefined ? null : __row['complementaryField']

        Given url baseUrl
            And path '/api/provisioning/v1/admin/tenant/', tenantId, '/user'
            And header Accept = 'application/json'
            And request
"""
{
    userName : '#(userName)',
    email: '#(email)',
    firstName: '#(firstName)',
    lastName: '#(lastName)',
    password: '#(password)',
    complementaryField: '#(complementaryField)',
    privilege: '#(privilege)',
    notificationsCronFrequency: '#(notificationsCronFrequency)',
    administeredDeskIds: '#(administeredDesks)',
    associatedTenantIds: '#(associatedTenantIds)'
}
"""
            When method POST
            Then status 201

        * def userId = ip5.api.v1.user.getIdByEmail(tenantId, email)

        # @fixme: complementaryField, bien que fourni, sauvegarde une valeur null
        Given url baseUrl
      And path '/api/provisioning/v1/admin/tenant/', tenantId, '/user/' + userId
            And header Accept = 'application/json'
            And request
"""
{
    userName : '#(userName)',
    email: '#(email)',
    firstName: '#(firstName)',
    lastName: '#(lastName)',
    password: '#(password)',
    complementaryField: '#(complementaryField)',
    privilege: '#(privilege)',
    notificationsCronFrequency: '#(notificationsCronFrequency)',
    administeredDesks: '#(administeredDesks)',
    associatedTenantIds: '#(associatedTenantIds)'
}
"""
        When method PUT
        Then status 200

      * ip5.api.v1.auth.login(userName, password)
      * ip5.api.v1.user.updateCurrentUserNotificationFrequency('none')


#
#      # PUT pour corriger la disparition de complementaryField ... mais ça ne marche pas
#      Given url baseUrl
#      And path '/api/v1/admin/tenant/', tenantId, '/user/' + userId
#      And header Accept = 'application/json'
#      And request
#"""
#{
#    userName : '#(userName)',
#    email: '#(email)',
#    firstName: '#(firstName)',
#    lastName: '#(lastName)',
#    password: '#(password)',
#    complementaryField: '#(complementaryField)',
#    privilege: '#(privilege)',
#    notificationsCronFrequency: '#(notificationsCronFrequency)'
#}
#"""
#      When method PUT
#      Then status 200
