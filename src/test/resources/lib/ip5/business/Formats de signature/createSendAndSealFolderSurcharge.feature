@business @formats-de-signature @folder
Feature: ...

Scenario: ...
    * def defaults = { tenant: "Formats de signature" }
    * ip5.api.v1.auth.login("ws-fds", "a123456a123456")
    * ip5.business.api.draft.createAndSendSimple(karate.merge(defaults, { annotation: "démarrage", username: "ws-fds", desktop: "WebService" }, __arg, { name: __arg.name + " - surcharge" }))

    * ip5.api.v1.auth.login("gnacarat", "a123456a123456")
    * call read("classpath:lib/ip5/business/api/folder/seal.feature") karate.merge(defaults, { annotation: "signature", username: "gnacarat", desktop: "Nacarat", folder: __arg.name + " - surcharge" }, __arg)
