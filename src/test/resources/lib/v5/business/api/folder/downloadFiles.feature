@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Download folder files
        * def tenant = v5.business.api.tenant.getByName(__arg.tenant)
        * def desktop = v5.business.api.desktop.getByName(tenant.id, __arg.desktop)

        * def folder = v5.business.api.folder.getByName(tenant.id, desktop.id, __arg.state, __arg.name)
        * def details = v5.business.api.folder.getDetails(tenant.id, desktop.id, folder.id)
        * def files = v5.utils.folder.downloadFiles(tenant, details)
        * def download = v5.utils.folder.download(tenant, details)
#        * def foo = new DownloadFiles(download._basePath, download._files)
#        * karate.log(typeof foo)
#        * karate.log(foo)
#        * karate.log(foo.all())
