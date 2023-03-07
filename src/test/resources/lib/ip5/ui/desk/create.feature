@karate-function
Feature: UI desk lib

  Scenario: Ajout d'un bureau
    * def selectOwners =
    """
    (owners) => {
      const selector = "//input[normalize-space(@placeholder)='Rechercher un utilisateur']";
      ip.pause(5);

      for(let i = 0; i < owners.length; i++) {
        value(selector, '');
        input(selector, owners[i]);
        waitFor("//tr//td[contains(normalize-space(text()), '" + owners[i] + "')]/ancestor::tr//*[@title='Ajouter']").click()
      }
    }
    """

    * def selectPermissions =
    """
    (permissions) => {
      let available = ['Créer des dossiers', 'Traiter des dossiers', 'Traiter des dossiers en fin de circuit', 'Enchaîner des dossiers terminés dans un nouveau circuit'];

      // Check all permissions are in available
      let diffs = permissions.filter(x => !available.includes(x));
      if (diffs.length > 0) {
        karate.fail('Les habilitations suivantes ne sont pas disponibles: ' + diffs.join(', '));
      }

      // Unselect elements
      diffs = available.filter(x => !permissions.includes(x));
      for(let i = 0; i < diffs.length; i++) {
        waitFor("{^}" + diffs[i]).click();
      }
    }
    """

    * def selectAssociated =
    """
    (associatedDesks) => {
      let selector = "//input[normalize-space(@placeholder)='Rechercher un bureau']";
      ip.pause(5);

      for(let i = 0; i < associatedDesks.length; i++) {
        value(selector, '');
        input(selector, associatedDesks[i]);

        waitFor("//tr//td[contains(normalize-space(text()), '" + associatedDesks[i] + "')]/ancestor::tr//*[@title='Ajouter']").click()
      }
    }
    """

    # Move to Admin / {tenant} / desks
    * waitFor("//app-header")
    * waitFor(ip5.ui.locator.header['Administration']).click()
    * ip5.ui.admin.selectTenant(tenant)
    * ip.pause(2)
    * waitFor("{^}Bureaux").click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Bureaux"))

    # Create desk
    * waitFor("{^}Créer un Bureau").click()
    * input(ip5.ui.locator.input("Titre"), [title, Key.ENTER], 300)
    * input(ip5.ui.locator.input("Nom court"), [shortName, Key.ENTER], 300)
    * waitFor("{^}Acteurs").click()
    * selectOwners(owners)
    * waitFor("{^}Habilitations").click()
    * selectPermissions(permissions)

    # Check desk creation
    * waitFor("{^}Bureaux associés").click()
    * selectAssociated(!associatedDesks ? [] : associatedDesks)
    * ip.pause(1)
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Bureaux"))
    * waitFor("//tbody//td[contains(text(),'" + title + "')]")
