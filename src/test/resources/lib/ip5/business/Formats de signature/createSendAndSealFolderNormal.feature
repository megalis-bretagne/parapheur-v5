@business @formats-de-signature @folder
Feature: ...

Scenario: ...
    * def defaults = { tenant: "Formats de signature" }
    * ip5.api.v1.auth.login("ws-fds", "Ilenfautpeupouretreheureux")
    * ip5.business.api.draft.createAndSendSimple(karate.merge(defaults, { annotation: "démarrage", username: "ws-fds", desktop: "WebService" }, __arg, { name: __arg.name + " - normal" }))

    * ip5.api.v1.auth.login("fgarance", "Ilenfautpeupouretreheureux")
    * call read("classpath:lib/ip5/business/api/folder/seal.feature") karate.merge(defaults, { annotation: "signature", username: "fgarance", desktop: "Nacarat", folder: __arg.name + " - normal" }, __arg)
