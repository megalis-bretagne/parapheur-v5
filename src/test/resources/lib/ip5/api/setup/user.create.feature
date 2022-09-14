@karate-function @ignore
    Feature: User setup lib

    Scenario: Create user
        * def tenantId = api_v1.entity.getIdByName(tenant)
#        * karate.log(__row)
#        * def complementaryField = ip.utils.isEmpty(complementaryField) === true ? null : complementaryField
        * def complementaryField = ip.utils.isEmpty(__row['complementaryField']) === undefined ? null : __row['complementaryField']
#        * karate.log(complementaryField)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/user'
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
    notificationsCronFrequency: '#(notificationsCronFrequency)'
}
"""
            When method POST
            Then status 201

        * def userId = api_v1.user.getIdByEmail(tenantId, email)

        # @fixme: complementaryField, bien que fourni, sauvegarde une valeur null
        Given url baseUrl
            And path '/api/v1/admin/user/' + userId
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
    notificationsCronFrequency: '#(notificationsCronFrequency)'
}
"""
        When method PUT
        Then status 200
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
