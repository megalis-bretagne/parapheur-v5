@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Signature placements
        * def details = v5.business.api.folder.getDetails(__arg.tenant.id, __arg.desktop.id, __arg.folder.id)
        * def setSignaturePlacements =
"""
function (tenant, desktop, details, positions) {
    var documentId, idx, keys = Object.keys(positions), params;
    for(idx=0;idx<keys.length;idx++) {
        documentId = karate.jsonPath(details, "$.documentList[?(@.name=='" + keys[idx] + "')].id")
        // @todo: fail/log when not found
        params = { tenant: tenant, desktop: desktop, folder: details, document: { id: documentId }, position: positions[keys[idx]] };
        karate.call("classpath:lib/v5/business/api/folder/signaturePlacement.feature", params);
    }
}
"""
        * setSignaturePlacements(__arg.tenant, __arg.desktop, details, __arg.positions)
