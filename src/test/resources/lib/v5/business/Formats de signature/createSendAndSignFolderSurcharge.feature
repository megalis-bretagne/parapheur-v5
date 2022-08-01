@business @formats-de-signature @folder
Feature: ...

Scenario: ...
    * def defaults = { tenant: "Formats de signature" }
    * api_v1.auth.login("ws-fds", "a123456")
    * v5.business.api.draft.createAndSendSimple(karate.merge(defaults, { annotation: "démarrage", username: "ws-fds", desktop: "WebService" }, __arg, { name: __arg.name + " - surcharge" }))

    * api_v1.auth.login("gnacarat", "a123456")
    * call read("classpath:lib/v5/business/api/folder/sign.feature") karate.merge(defaults, { annotation: "signature", username: "gnacarat", desktop: "Nacarat", certificate: "signature", folder: __arg.name + " - surcharge" }, __arg)
