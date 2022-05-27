@karate-function
Feature: UI desk lib

    Scenario: Ajout d'un bureau
        * def selectOwners =
"""
function (owners) {
    var idx, selector = "//input[normalize-space(@placeholder)='Rechercher un utilisateur']";
    // @todo: attendre un élément particulier ?
    pause(5);
    for(idx = 0;idx < owners.length;idx++) {
        value(selector, '');
        input(selector, owners[idx]);
        waitForResultCount("//table//thead//th[text()='Utilisateurs']/ancestor::table//tbody//tr", 1);
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

        Given assert exists("//app-header") == true
            And click("//app-header//*[@routerLink='/admin']")
        Then waitFor(ui.element.breadcrumb("Administration / Informations serveur"))

        When ui.admin.selectTenant(tenant)
        And click("{^}Bureaux")
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Bureaux"))

        When click("{^}Créer un Bureau")
            And input(ui.locator.input("Titre"), title)
            And input(ui.locator.input("Nom court"), shortName)
            And click("{^}Acteurs")
            And selectOwners(owners)
            And click("{^}Habilitations")
            And selectPermissions(permissions)
            # @todo: metadonnées
            # @todo: bureaux associés
            And waitForEnabled(ui.locator.button("Enregistrer")).click()
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Bureaux"))
            And waitFor(ui.toast.success("Le bureau " + title + " a été créé avec succès"))
            And waitFor("//tbody//td[contains(text(),'" + title + "')]")
