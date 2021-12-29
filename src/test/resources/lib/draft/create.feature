@ignore
Feature:
#    Scenario:
#        * def payload =
#"""
#{
#    "name": "#(name)",
#    "subtypeId": "#(subtypeId)",
#    "typeId": "#(typeId)"
#}
#"""
#
#      Given url baseUrl
#          And path '/api/v1/tenant/' + tenantId + '/desk/' + deskId + '/draft'
#          And header Accept = 'application/json'
#          And multipart file draftFolderParams = { 'value': '#(payload)', 'contentType': 'application/json' }
#          And multipart file mainFiles = { read: 'classpath:files/dummy.pdf', 'contentType': 'application/pdf', 'fileName': 'dummy.pdf' }
#      When method POST
#      Then status 201
#
    Scenario:
      Given url baseUrl
          And path path
          And header Accept = 'application/json'
          And multipart file draftFolderParams = { 'value': '#(draftFolderParams)', 'contentType': 'application/json' }
          And multipart file mainFiles = { read: 'classpath:files/dummy.pdf', 'contentType': 'application/pdf', 'fileName': 'dummy.pdf' }
      When method POST
      Then status 201
