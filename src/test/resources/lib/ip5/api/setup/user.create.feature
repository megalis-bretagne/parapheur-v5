@karate-function @ignore
    Feature: User setup lib

    Scenario: Create user
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
        * def administredDesk = ip5.api.v1.desk.getIdByName(tenantId, 'null_desk')
        * def complementaryField = ip.utils.isEmpty(__row['complementaryField']) === undefined ? null : __row['complementaryField']

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
    notificationsCronFrequency: '#(notificationsCronFrequency)',
    administeredDesks: [
        {
            id: '#(administredDesk)',
            name: 'null_desk'
        }
    ]
}
"""
            When method POST
            Then status 201

        * def userId = ip5.api.v1.user.getIdByEmail(tenantId, email)

        # @fixme: complementaryField, bien que fourni, sauvegarde une valeur null
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/user/' + userId
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
    administeredDesks: [
        {
            id: '#(administredDesk)',
            name: 'null_desk'
        }
    ]
}
"""
        When method PUT
        Then status 200
