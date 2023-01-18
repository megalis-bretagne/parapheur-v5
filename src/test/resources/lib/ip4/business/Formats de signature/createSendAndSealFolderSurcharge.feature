@business @formats-de-signature @folder
Feature: ...

    Scenario: ...
        * def defaults = {}
        * ip4.business.api.user.login("ws@fds", "a123456")
        * def params = karate.merge(defaults, { annotation: "démarrage", username: "ws@fds", desktop: "WebService" }, __arg, { title: __arg.name + " - surcharge" })
        * call read("classpath:lib/ip4/business/api/folder/create.feature") params

        * ip.pause(1)
        * ip4.business.api.user.login("gnacarat@fds", "a123456")
        * call read("classpath:lib/ip4/business/api/folder/seal.feature") karate.merge(defaults, { annotation: "cachet", username: "gnacarat", desktop: "Nacarat", folder: __arg.name + " - surcharge" }, __arg)
