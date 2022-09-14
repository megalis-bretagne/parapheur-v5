@business @formats-de-signature @folder
Feature: ...

    Scenario: ...
        * api_v1.auth.login("ws-fds", "a123456")
        * def download = {}
        * download["normal"] = v5.business.api.folder.download("Formats de signature", "WebService", "finished", __arg.name + " - normal")
        * download["surcharge"] = v5.business.api.folder.download("Formats de signature", "WebService", "finished", __arg.name + " - surcharge")
