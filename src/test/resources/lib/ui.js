/*
 * i-Parapheur
 * Copyright (C) 2019-2022 Libriciel SCOP
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

function fn(config) {
    config['ui'] = {};

    /**
     * Driver
     **/
    config.ui['driver'] = {};
    // @see https://github.com/intuit/karate/blob/master/karate-demo/src/test/java/driver/demo/demo-01.feature
    config.ui.driver['configure'] = {
        executable: config.CHROME_BIN,
        headless: config.headless,
        showDriverLog: false,
        type: 'chrome'
    };

    /**
     * Locator
     * @todo: find lib or port custom from behat's
     **/
    config.ui['locator'] = {};
    config.ui.locator['button'] = function (text) {
        return '//button[contains(., \'' + text + '\')]';
    };
    config.ui.locator['header'] = {};
    // usage: ui.locator.header['i-Parapheur']
    config.ui.locator.header['i-Parapheur'] = '//app-header//*[@routerlink=\'/\'][1]';
    config.ui.locator.header['Maison'] = '//app-header//*[@routerlink=\'/\'][last()]';
    config.ui.locator.header['Archives'] = '//app-header//*[@routerlink=\'/archive\']';
    config.ui.locator.header['Statistiques'] = '//app-header//*[@routerlink=\'/stats\']';
    config.ui.locator.header['Administration'] = '//app-header//*[@routerlink=\'/admin\']';
    config.ui.locator.header['Profil'] = '//app-header//*[@routerlink=\'/profile\']';
    config.ui.locator.header['Déconnexion'] = '//app-header//fa-icon[last()]';
    config.ui.locator['input'] = function (text) {
        // return '//input[@id=//label[contains(., \'' + text + '\')]/@for]';
            return '//input[@id=//label[contains(., \'' + text.replace("'", "\\\u0027") + '\')]/@for]';
    };

    /**
     * URL
     **/
    config.ui['admin'] = {};
    config.ui.admin['getRoleIndex'] = function(name) {
        switch(name) {
            case 'Administrateur':
                return 1;
            case 'Administrateur d\'entité':
                return 2;
            case 'Administrateur fonctionnel':
                return 3;
            case 'Aucun privilège':
                return 4;
        }
        karate.fail('Role "' + name + '" does not exist');
    };
    config.ui.admin['selectTenant'] = function(tenant) {
        waitFor("//input[@aria-autocomplete='list']");
        click("//input[@aria-autocomplete='list']");
        input("//input[@aria-autocomplete='list']", tenant);
        click("//div[@class='ng-dropdown-panel-items scroll-host']//*[text()='" + tenant + "']");
    };

    /**
     * Elements
     **/
    config.ui['element'] = {};
    config.ui.element['breadcrumb'] = function(path) {
        var idx, tokens = path.split(/\s*\/\s*/), result = '';
        for (idx = 0; idx < tokens.length ; idx++) {
            if (idx === 0) {
                result = "//li//*[normalize-space(text())='" + tokens[idx] + "']";
            } else {
                result += "/ancestor::li/following-sibling::li//*[normalize-space(text())='" + tokens[idx] + "']";
            }
        }
        return result;
    };

    /**
     * Toast
     **/
    config.ui['toast'] = {};
    config.ui.toast['success'] = function(message) {
        return "//div[contains(@class, 'toast-success')]//*[contains(normalize-space(text()), '" + message + "')]";
    };

    /**
     * URL
     **/
    config.ui['url'] = {};
    config.ui.url['logout'] = '/auth/realms/api/protocol/openid-connect/logout';

    /**
     * User
     **/
    config.ui['user'] = {};
    config.ui.user['login'] = function(username, password) {
        karate.call('classpath:lib/ui/user/login.feature', { username: username, password: password });
    };
    config.ui.user['logout'] = function() {
        ui.user.menu("{^}Se déconnecter");
        waitFor('{^}Veuillez saisir vos identifiants de connexion');
    };
    config.ui.user['menu'] = function(locator) {
        mouse().move("//div[contains(@class, 'header-menu ')]").go();
        click(locator);
        // @todo: move somewhere else
    };

    return config;
}
