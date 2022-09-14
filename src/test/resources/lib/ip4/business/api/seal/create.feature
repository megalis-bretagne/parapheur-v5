@karate-function @ignore
Feature: IP v.4 REST seal lib

    Scenario: Create seal
        * def Base64 = Java.type('java.util.Base64')

        * def sealContent = karate.read(certificate)
        * def sealCertificate = Base64.getEncoder().encodeToString(sealContent)

        * def imageContent = karate.read(image)
        * def sealImage = Base64.getEncoder().encodeToString(imageContent)

        * def alias = utils.certificate.alias(certificate, password)
        * def enddate = utils.certificate.enddate(certificate, password)
        * def issuer = utils.certificate.issuer(certificate, password)
        * def subject = utils.certificate.subject(certificate, password)

        Given def payload =
"""
{
    "isNew": true,
    "title": "#(title)",
    "editing": true,
    "originalName": "#(utils.file.basename(certificate))",
    "certificate": "#(sealCertificate)",
    "description": {
        "notAfter": #(enddate),
        "issuerDN": "#(issuer)",
        "alias": "#(alias)",
        "subjectDN": "#(subject)"
    },
    "password": "#(password)",
    "loadChange": false,
    "imageName": "#(utils.file.basename(image))",
    "image": "#(sealImage)",
    "additionalText": "#(text)"
}
"""
        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/seals"
            And header Accept = "application/json"
            And request payload
        When method POST
        Then status 200
            And match response contains { "id": "#uuid" }
