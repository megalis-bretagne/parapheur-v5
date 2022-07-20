@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Sign folder
        # utils.signature.getBase64FromFile
        * def getPublicPemBase64 =
"""
function(path) {
    var collect = false,
        content = karate.readAsString(path),
        idx,
        lines = content.split(/\r?\n/),
        result = '';

    for(idx = 0;idx < lines.length;idx++) {
        if (lines[idx].match(/^\-+ *BEGIN/) !== null) {
            collect = true;
        } else if (lines[idx].match(/^\-+ *END/) !== null) {
            collect = false;
        } else if(collect === true) {
            result += lines[idx];
        }
    }

    return result;
}
"""
        # 1. Récupération des hash des documents à signer du dossier
        * url baseUrl
        * def certBase64 = getPublicPemBase64("file://" + karate.toAbsolutePath(__arg.publicCert))
        * path "/iparapheur/proxy/alfresco/parapheur/signature/" + __arg.desktop.id + "/" + folder.id
        * header Accept = "application/json"
        * request
"""
{
  "certificate": "#(certBase64)",
  "index": 0
}
"""
        * method POST
        * def signatureDateTime = karate.jsonPath(response, "$[0].signatureDateTime")
        * def dataToSignBase64List = karate.jsonPath(response, "$[0].dataToSignBase64List")

        # -----------------------------------------------------------------------
        # 2. Signature du hash (on ne prend que le premier)
        # -----------------------------------------------------------------------
        # @todo: workDir build/runId?/dossierId, ici: 67, 68, ... -> utiliser karate.properties['org.gradle.test.worker']
        # * karate.log(karate.properties['org.gradle.test.worker'])
        * def workDir = utils.safeExec("mktemp -d /tmp/karate.iparaheur.signature." + folder.id + ".XXXXXXXXXX")
        * def Base64 = Java.type('java.util.Base64')

        * def decoded = Base64.getDecoder().decode(dataToSignBase64List.getBytes())
        * karate.write(decoded, folder.id + "/" + __arg.folder.id + ".bin")

        # @todo: factoriser dans utils.safeExec
        * def cmd = "openssl dgst -sha256 -sign " + karate.toAbsolutePath(__arg.privateCert) + " -out " + workDir + "/" + __arg.folder.id + ".sig " + karate.properties['user.dir'] + "/build/" + folder.id + "/" + __arg.folder.id + ".bin"
        * utils.safeExec(cmd)

        * def content = karate.readAsString("file://" + workDir + "/" + __arg.folder.id + ".sig")
        * def signature = Base64.getEncoder().encodeToString(content.getBytes())
        * karate.exec("rm -rf " + workDir)

        # -----------------------------------------------------------------------
        # 3. Envoi du hash signé
        # -----------------------------------------------------------------------
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + folder.id + "/signature"
        * header Accept = "application/json"
        * def payload =
"""
{
  "annotPub": "#(__arg.annotPub)",
  "annotPriv": "#(__arg.annotPriv)",
  "bureauCourant": "#(__arg.desktop.id)",
  "certificate": "#(certBase64)",
  "signature": {
    "signature": [
      "#(signature)"
    ],
    "signatureDateTime": [
      #(signatureDateTime)
    ]
  }
}
"""
        * request payload
        * method POST
        * status 200
        # @todo: check response content
