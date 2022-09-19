@business @formats-de-signature @folder
Feature: ...

    Scenario: ...
        * ip5.api.v1.auth.login("ws-fds", "a123456")
        * def download = {}
        * download["normal"] = ip5.business.api.folder.download("Formats de signature", "WebService", "finished", __arg.name + " - normal")
        * download["surcharge"] = ip5.business.api.folder.download("Formats de signature", "WebService", "finished", __arg.name + " - surcharge")
