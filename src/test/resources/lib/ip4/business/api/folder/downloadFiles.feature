@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Download folder files
        # GET /iparapheur/proxy/alfresco/parapheur/dossiers?asc=true&bureau=5f18d935-0e50-4bb9-90fe-60674ee98bd4&corbeilleName=a-archiver&filter={"and":[{"or":[]},{"or":[]}]}&metas={"metas":[]}&page=0&pageSize=10&pendingFile=0&skipped=0&sort=cm:title
        * def desktop = ip4.business.api.desktop.getByName(__arg.desktop)
        * def target = ip4.business.api.folder.getByName(desktop.id, __arg.state, __arg.title)
        * def folder = ip4.business.api.folder.getById(desktop.id, target.id)
        * def download = ip4.utils.folder.download(folder)
