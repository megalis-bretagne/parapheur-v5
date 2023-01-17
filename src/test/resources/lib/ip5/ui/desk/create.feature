@karate-function
Feature: UI desk lib

    Scenario: Ajout d'un bureau
        * def selectOwners =
"""
function (owners) {
    var idx, selector = "//input[normalize-space(@placeholder)='Rechercher un utilisateur']";
    // @todo: attendre un élément particulier ?
    ip.pause(5);
    for(idx = 0;idx < owners.length;idx++) {
        value(selector, '');
        input(selector, owners[idx]);
        //@info: timeout
        //waitForResultCount("//table//thead//th[text()='Utilisateurs']/ancestor::table//tbody//tr", 1);
        click("//tr//td[contains(normalize-space(text()), '" + owners[idx] + "')]/ancestor::tr//*[@title='Ajouter']")
    }
}
"""
        * def selectPermissions =
"""
function (permissions) {
    var available = ['Créer des dossiers', 'Traiter des dossiers', 'Traiter des dossiers en fin de circuit', 'Enchaîner des dossiers terminés dans un nouveau circuit'],
        idx,
        diffs;
    // Check all permissions are in availables
    diffs = permissions.filter(x => !available.includes(x));
    if (diffs.length > 0) {
        karate.fail('Les habilitations suivantes ne sont pas disponibles: ' + diffs.join(', '));
    }
    // Unselect elements
    diffs = available.filter(x => !permissions.includes(x));
    for(idx = 0;idx < diffs.length;idx++) {
        click("{^}" + diffs[idx]);
    }
}
"""

      * def selectAssociated =
"""
function (associatedDesks) {
    var idx, selector = "//input[normalize-space(@placeholder)='Rechercher un bureau']";
    // @todo: attendre un élément particulier ?
    ip.pause(5);
    for(idx = 0;idx < associatedDesks.length;idx++) {
        value(selector, '');
        input(selector, associatedDesks[idx]);
        //@info: timeout
        //waitForResultCount("//table//thead//th[text()='Utilisateurs']/ancestor::table//tbody//tr", 1);
        click("//tr//td[contains(normalize-space(text()), '" + associatedDesks[idx] + "')]/ancestor::tr//*[@title='Ajouter']")
    }
}
"""

        Given assert exists("//app-header") == true
            And click(ip5.ui.locator.header['Administration'])
        #Then waitFor(ip5.ui.element.breadcrumb("Administration / Informations serveur"))

        When ip5.ui.admin.selectTenant(tenant)
        And click("{^}Bureaux")
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Bureaux"))

        When click("{^}Créer un Bureau")
            And input(ip5.ui.locator.input("Titre"), title)
            And input(ip5.ui.locator.input("Nom court"), shortName)
            And click("{^}Acteurs")
            And selectOwners(owners)
            And click("{^}Habilitations")
            And selectPermissions(permissions)
            # @todo: metadonnées
            And click("{^}Bureaux associés")
            And selectAssociated(typeof associatedDesks === 'undefined' ? [] : associatedDesks)
            * ip.pause(1)
            And waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Bureaux"))
            And waitFor(ip5.ui.toast.success("Le bureau " + title + " a été créé avec succès"))
            And waitFor("//tbody//td[contains(text(),'" + title + "')]")
