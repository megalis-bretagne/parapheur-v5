@business @formats-de-signature @folder
Feature: ...

    Scenario: ...
        * def defaults = {}
        * ip4.business.api.user.login("ws@fds", "a123456")
        * def params = karate.merge(defaults, { annotation: "démarrage", username: "ws@fds", desktop: "WebService" }, __arg, { title: __arg.name + " - normal" })
        * call read("classpath:lib/ip4/business/api/folder/create.feature") params

        * ip4.business.api.user.login("fgarance@fds", "a123456")
        * call read("classpath:lib/ip4/business/api/folder/seal.feature") karate.merge(defaults, { annotation: "cachet", username: "fgarance", desktop: "Nacarat", folder: __arg.name + " - normal" }, __arg)
