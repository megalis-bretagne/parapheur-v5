@proposal @ignore
Feature: ...

    Background:
        * api_v1.auth.login('user', 'password')
        * def createTmpNumberedTenants =
"""
function (max) {
    var result = [],
      length = max.toString().length;
    for (var i=1;i<=max;i++) {
        result.push(
          {name: 'tmp-%counter%'.replace('%counter%', i.toString().padStart(length, "0"))}
        );
    }
    return result;
}
"""

    Scenario: Create
        # @info: 20220117 9h30 (à la connexion Mozilla Firefox 96.0 (64 bits), + 1 (Default tenant))
        # 31 -> OK
        # 32 -> 400 Bad Request Request Header Or Cookie Too Large
        * def names = createTmpNumberedTenants(30)
        * call read('classpath:lib/setup/tenant.create.feature') names

    Scenario: Cleanup
        * def list = api_v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/setup/tenant.delete.feature') list
