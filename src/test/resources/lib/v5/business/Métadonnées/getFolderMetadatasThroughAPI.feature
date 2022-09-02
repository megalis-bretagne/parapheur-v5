@business @metadonnees @folder @ignore
Feature: ...

    Scenario: ...
        * api_v1.auth.login(__arg.username, 'a123456')
        * def tenant = v5.business.api.tenant.getByName(__arg.tenant)
        * def desktop = v5.business.api.desktop.getByName(tenant.id, __arg.desktop)
        * def folder = v5.business.api.folder.getByName(tenant.id, desktop.id, __arg.state, __arg.folder)

        * def internal =
"""
{
    "workflow_internal_final_group_id": "#uuid",
    "workflow_internal_steps": "#present",
    "i_Parapheur_internal_emitter_id": "#uuid",
    "workflow_internal_validation_workflow_id": "#string"
}
"""
        * def valuesToString =
"""
function (dict) {
    var key;
    for (key in dict) {
        switch(typeof dict[key]) {
            case "boolean":
                if (dict[key] === true) {
                    dict[key] = "true";
                }
                else if (dict[key] === false) {
                    dict[key] = "false";
                }
                break;
            case "number":
                dict[key] = String(dict[key]);
                break;
        }
    }
    return dict;
}
"""
        * def expected = karate.merge(internal, valuesToString(map[__arg.folder]))
        * match folder.metadata == expected
