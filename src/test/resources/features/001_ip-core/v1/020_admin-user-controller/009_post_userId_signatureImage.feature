@ip-core @api-v1
Feature: POST /api/admin/tenant/{tenantId}/user/signatureImage (Create user's signature image)

    @permissions @karate-todo @karate-todo-title-when-the-signature-already-exists
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} create an existing user signature image in an existing tenant
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: '<path>', 'contentType': 'image/png' }
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")

        Examples:
            | role             | username     | password | email                  | path                                         | status |
            # @todo: when the image already exists...
            | ADMIN            | cnoir        | a123456  | ltransparent@dom.local | classpath:files/signature - ltransparent.png | 409    |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | email                  | path                                         | status |
            | ADMIN            | cnoir        | a123456  | stranslucide@dom.local | classpath:files/signature - stranslucide.png | 201    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | email                  | path                                         | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | ltransparent@dom.local | classpath:files/signature - ltransparent.png | 403    |
            | NONE             | ltransparent | a123456  | ltransparent@dom.local | classpath:files/signature - ltransparent.png | 403    |
            |                  |              |          | ltransparent@dom.local | classpath:files/signature - ltransparent.png | 401    |
