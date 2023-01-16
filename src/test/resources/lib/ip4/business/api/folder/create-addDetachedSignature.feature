@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Create folder - add main document
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/detachedsignature/" + __arg.documentId
        * header Accept = 'application/json'
        * def toBase64 =
"""
function(path) {
    var cmd = [
      "/bin/sh",
      "-c",
      "python3 -m base64 -e \"" + path + "\" | tr -d '\\n'"
    ];
    return ip.utils.safeExec(cmd);
}
"""
        * def signature = toBase64(karate.toAbsolutePath(__arg.file))
        * def payload =
"""
{
    "mimetype": "#(ip.utils.file.mime(__arg.file))",
    "signature": "#(signature)",
}
"""
        * request payload
        * method POST
        * status 201
        * karate.log(response)
