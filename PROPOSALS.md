# Proposals

- [ ] `@fixme-karate-proposal` or `@proposal`
- [ ] make same proposal for POST and PUT tenant and for PUT user -> proposals.md

## @todo

- `admin-tenant-controller`
    - `POST`and `PUT`
        - value with only a space
        - forbidden characters
        - value with forbidden characters
- `admin-user-controller`
    - `POST`and `PUT`
        - value with only a space
        - forbidden characters or values
        - values too long (see `POST /api/admin/tenant` and `PUT /api/admin/tenant/{tenantId}`)

### @see

- `src/test/java/api/v1/scenarios/_000_minimal/020_admin-user-controller/002_post.feature`
  - `Scenario: Permissions - a user with an "ADMIN" role can create a user in an existing tenant`

### New validation rules

- POST /api/admin/tenant
    - Scenario: Data validation - a user with an "ADMIN" role cannot create a tenant with an empty name
    - Scenario: Data validation - a user with an "ADMIN" role cannot create a tenant with a name that already exists
    - @todo Scenario: Data validation - a user with an "ADMIN" role cannot create a tenant with a name that contains unaccepted characters
- PUT /api/admin/tenant/{tenantId}
    - Scenario: Data validation - a user with an "ADMIN" role cannot edit a tenant with an empty name
    - Scenario: Data validation - a user with an "ADMIN" role cannot edit a tenant with a name that already exists
- POST /api/admin/tenant/{tenantId}/user
    - @fixme Scenario: Data validation - a user with an "ADMIN" role cannot create a user with empty data
    - @fixme ...
- PUT /api/admin/tenant/{tenantId}/user/{userId}
    - @fixme ...

### Examples

- @todo: proposal in 010_admin-tenant-controller/002_post.feature
- @todo: proposal in 010_admin-tenant-controller/003_put_tenantId.feature
- @todo: proposal in 020_admin-user-controller/004_put_userId.feature

## HTTP status 201

Should return a JSON response containing the newly created object (or at least its `id`) ?

#### `admin-user-controller`

##### Feature: `POST /api/admin/tenant/{tenantId}/user` (Create a new user)

###### `Scenario: Data validation - a user with an "ADMIN" role cannot create a user with empty data`

```gherkin
    # ...
    Then status 400
        And match response ==
"""
{
    "path": "#string",
    "error": "Bad Request",
    "message": "#string",
    "timestamp": "#(matchers.timestamp)",
    "status": 400,
    "errors": {
        "userName": [ "Mandatory field" ],
        "email": [ "Mandatory field" ],
        "firstName": [ "Mandatory field" ],
        "lastName": [ "Mandatory field" ],
        "password": [ "Mandatory field" ],
        "privilege": [ "Mandatory field" ],
        "notificationsCronFrequency": [ "Mandatory field" ],
        "notificationsRedirectionMail": [ "Mandatory field" ]
    }
}
"""
```

###### `Scenario: Data validation - a user with an "ADMIN" role cannot create a user with empty data`

```gherkin
    # ...
    Then status 400
        And match response ==
"""
{
    "path": "#string",
    "error": "Bad Request",
    "message": "",
    "timestamp": "#(matchers.timestamp)",
    "status": 400,
    "errors": {
        "userName": [ "Value already in use" ],
        "email": [ "Value already in use" ],
    }
}
"""

```

##### Feature: `PUT /api/admin/tenant/{tenantId}/user/{userId}` (Update user)

###### Scenario: Permissions - a user with an "ADMIN" role can edit an existing user from an existing tenant

- [ ] @todo: on success (code 200), return the newly created element (like `PUT /api/admin/tenant/{tenantId}`) ? 

```gherkin
    # ...
    When method PUT
    Then status 200
      And match $ == schemas.user.element
      And match $ contains userData
"""
```

###### Scenario: Data validation - a user with an "ADMIN" role cannot edit a user with empty values

- [ ] @todo: when sending partial data (`userName` only), get a 500

```gherkin
    # ...
    Then status 400
        And match response ==
"""
{
    "path": "#string",
    "error": "Bad Request",
    "message": "",
    "timestamp": "#(matchers.timestamp)",
    "status": 400,
    "errors": {
        "userName": [ "Mandatory field" ],
        "email": [ "Mandatory field" ],
        "firstName": [ "Mandatory field" ],
        "lastName": [ "Mandatory field" ],
        "password": [ "Mandatory field" ],
        "privilege": [ "Mandatory field" ],
        "notificationsCronFrequency": [ "Mandatory field" ],
        "notificationsRedirectionMail": [ "Mandatory field" ]
    }
}
"""
```

###### Scenario: Data validation - a user with an "ADMIN" role cannot edit a user with already existing userName or email values

- [ ] @todo: 409 is for PUT / versioning: https://tools.ietf.org/html/rfc7231#section-6.5.8 ?

```gherkin
    # ...
    Then status 400
        And match response ==
"""
{
    "path": "#string",
    "error": "Bad Request",
    "message": "##string",
    "timestamp": "#(matchers.timestamp)",
    "status": 400,
    "errors": {
        "userName": [ "Value already in use" ],
        "email": [ "Value already in use" ],
    }
}
"""
```
