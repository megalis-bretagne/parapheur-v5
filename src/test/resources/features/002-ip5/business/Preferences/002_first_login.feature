@ip5 @ip-web @l10n @preferences @tests @wip
Feature: 002 - Scénario de test des préférences, première connexion

  Background:
    * configure driver = ip.ui.driver.configure
    * driver baseUrl + ip5.ui.url.logout

  Scenario: ...
    * ip5.ui.user.login('kpapin', 'a123456')
    * def choucroute =
    """
      function() {
          var actual = [], idx, lines, xpathPrefix = "//*[contains(concat(' ', @class, ' '), ' desk-layout ')]//a/text()";
          waitFor(xpathPrefix);
          lines = locateAll(xpathPrefix);
          for (idx = 1;idx <= lines;idx++) {
              actual.push(text(lines[idx]).trim());
          }
          return actual;
      }
    """
    * karate.log(choucroute())
