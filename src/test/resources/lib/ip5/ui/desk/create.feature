@karate-function
Feature: UI desk lib

  Scenario: Ajout d'un bureau
    * def selectOwners =
    """
    (owners) => {
        let idx, selector = "//input[normalize-space(@placeholder)='Rechercher un utilisateur']";
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
    (permissions) => {
        let available = ['Créer des dossiers', 'Traiter des dossiers', 'Traiter des dossiers en fin de circuit', 'Enchaîner des dossiers terminés dans un nouveau circuit'],
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
    (associatedDesks) => {
        let idx, selector = "//input[normalize-space(@placeholder)='Rechercher un bureau']";
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

    # Move to Admin / tenants / Desks
    * eval if (exists("//app-header") == true) click(ip5.ui.locator.header['Administration'])
    * ip5.ui.admin.selectTenant(tenant)
    * waitFor("{^}Bureaux").click()

    # Create desk
    * waitFor("{^}Créer un Bureau").click()
    * input(ip5.ui.locator.input("Titre"), title)
    * input(ip5.ui.locator.input("Nom court"), shortName)
    * waitFor("{^}Acteurs").click()
    * selectOwners(owners)
    * waitFor("{^}Habilitations").click()
    * selectPermissions(permissions)
    * waitFor("{^}Bureaux associés").click()
    * selectAssociated(typeof associatedDesks === 'undefined' ? [] : associatedDesks)
    * ip.pause(1)
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()

    # Check creation
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Bureaux"))
    * waitFor("//tbody//td[contains(text(),'" + title + "')]")
