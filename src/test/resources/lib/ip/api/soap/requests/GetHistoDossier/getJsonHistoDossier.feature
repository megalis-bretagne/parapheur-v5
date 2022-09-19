@karate-function @ignore
Feature: SOAP GetCircuit lib

    Scenario: getHistoDossier
        * def cleanupXmlResponseToJson =
"""
function (xml) {
    var idx,
        line,
        result = [],
        tmp = karate.xmlPath(xml, "/Envelope/Body/GetHistoDossierResponse/LogDossier");
    for (idx=0;idx<tmp.length;idx++) {
        line = tmp[idx]["LogDossier"];
        delete line["timestamp"];
        result.push(line);
    }
    return result;
}
"""
        # 1. Récupération d'un dossier en particulier
        * def rv = call read('classpath:lib/ip/api/soap/requests/RechercherDossiers/simple.feature') __arg
        * def dossiersIds = karate.xmlPath(rv.response, '/Envelope/Body/RechercherDossiersResponse/LogDossier/nom');
        # "Filtrage" des résultats
        * def dossierId = ip.api.soap.dossier.filterDossiersIdsByName(dossiersIds, __arg.name, { username: "ws@legacy-bridge", password: "a123456" })

        # 2. Récupération du journal des événements de ce dossier
        * def params = { dossierId: "#(dossierId)", username: "#(__arg.username)", password: "#(__arg.password)" }
        * call read('classpath:lib/ip/api/soap/requests/GetHistoDossier/simple.feature') params
        * match response == karate.read('classpath:lib/ip/api/soap/schemas/GetHistoDossierResponse/OK.xml')
        * def jsonHistoDossier = cleanupXmlResponseToJson(response)
