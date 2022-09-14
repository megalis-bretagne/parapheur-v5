@karate-function @ignore
Feature: External signature setup lib

    Scenario: Create external signature config
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def payload = ip.utils.filterMap(__row)
        * remove payload['tenant']

        Given url baseUrl
              And path '/api/v1/admin/tenant/' + tenantId + '/externalSignature/config'
              And header Accept = 'application/json'
              And request payload
          When method POST
          Then status 201
