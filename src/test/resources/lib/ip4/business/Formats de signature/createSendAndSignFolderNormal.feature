@business @formats-de-signature @folder
Feature: ...

    Scenario: ...
        * def defaults = {}
        * def params = karate.merge(defaults, { annotation: "démarrage", username: "ws@fds", desktop: "WebService" }, __arg, { title: __arg.name + " - normal" })
        * ip4.business.api.user.login("ws@fds", "a123456")
        * call read("classpath:lib/ip4/business/api/folder/create.feature") params

        * ip4.business.api.user.login("fgarance@fds", "a123456")
        * call read("classpath:lib/ip4/business/api/folder/sign.feature") karate.merge(defaults, { annotation: "signature", username: "fgarance@fds", desktop: "Nacarat", certificate: "signature", folder: __arg.name + " - normal" }, __arg)
