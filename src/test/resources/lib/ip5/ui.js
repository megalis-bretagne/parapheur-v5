/*
 * iparapheur
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
    config['ip5'] = config['ip5'] || {};

    config.ip5['ui'] = config.ip5['ui'] || {};

    /**
     * Desk
     **/
    config.ip5.ui['desk'] = {};
    config.ip5.ui.desk['getTileBadges'] = function(desk) {
        var actual = {},
            clasName,
            classes,
            count,
            idx,
            badges,
            row,
            badgesXpath = "//a[text()='" + desk + "']/parent::div/div[contains(concat(' ', @class, ' '), ' folder-count-badges ')]//*[contains(concat(' ', @class, ' '), ' badge ')]";

        waitFor(badgesXpath);

        badges = karate.sizeOf(locateAll(badgesXpath));
        for (idx = 1;idx <= badges;idx++) {
            classes = " " + text(badgesXpath + "[" + idx + "]/@class").trim() + " ";
            clasName = classes.replace(/^.* (badge\-[^ ]+) .*$/, '$1');
            actual[clasName.replace(/^badge-/, '')] = parseInt(text(badgesXpath + "[" + idx + "]/text()").trim(), 10);
        }
        return actual;
    };

    /**
     * Folder
     **/
    config.ip5.ui['folder'] = {};
    /**
     * Annotations
     **/
    config.ip5.ui.folder['annotate'] = {};
    config.ip5.ui.folder.annotate['both'] = function(username, action, folder) {
        waitFor("{label}Annotation publique").input(ip.templates.annotations.getPublic(username, action, folder));
        waitFor("{label}Annotation privée").input(ip.templates.annotations.getPrivate(username, action, folder));
    };
    config.ip5.ui.folder['getAnnotations'] = function(singular, plural) {
        var actual = [],
            idx,
            linePrefix,
            lines,
            row,
            annotationXpath = '//*[normalize-space(text())=\'' + singular + '\' or normalize-space(text())=\'' + plural + '\']/ancestor::app-annotation-display',
            xpath;

        waitFor(annotationXpath);

        linePrefix = annotationXpath + '/div/div[2]/div';
        lines = karate.sizeOf(locateAll(linePrefix));
        for (idx = 1;idx <= lines;idx++) {
            row = {};
            row[singular] = text(linePrefix + "[" + idx + "]/text()").trim();
            row['Utilisateur'] = text(linePrefix + "[" + idx + "]/div").trim().replace(/^(.*) +Le +[0-9]+ +[^ ]+ [0-9]+ +à [0-9]+:[0-9]+:[0-9]+$/i, '$1');
            actual.push(row);
        }
        return actual;
    };
    config.ip5.ui.folder['getPrivateAnnotations'] = function() {
        return ip5.ui.folder.getAnnotations('Annotation privée', 'Annotations privées');
    };
    config.ip5.ui.folder['getPublicAnnotations'] = function() {
        return ip5.ui.folder.getAnnotations('Annotation publique', 'Annotations publiques');
    };

    /**
     * Journal des événements
     **/
    config.ip5.ui.folder['getEventLog'] = function() {
        var actual = [],
            idx,
            lines,
            row,
            tableBodyXpath = '//ngb-modal-window//app-history-popup//table//tbody',
            xpath;

        waitFor(tableBodyXpath + '//tr');
        lines = karate.sizeOf(locateAll(tableBodyXpath + '//tr'));

        // 1. Extract actual table content
        for (idx = 1;idx <= lines;idx++) {
            row = {
                'Bureau': text(tableBodyXpath + "/tr[" + idx + "]//td[2]").trim(),
                'Utilisateur': text(tableBodyXpath + "/tr[" + idx + "]//td[3]").trim(),
                'Annotation publique': text(tableBodyXpath + "/tr[" + idx + "]//td[4]").trim(),
                'Action': text(tableBodyXpath + "/tr[" + idx + "]//td[5]").trim(),
                'État': text(tableBodyXpath + "/tr[" + idx + "]//td[6]").trim()
            };
            actual.push(row);
        }
        return actual;
    };

    /**
     * Locator
     * @todo: find lib or port custom from behat's
     **/
    config.ip5.ui['locator'] = {};
    config.ip5.ui.locator['button'] = function (text) {
        return '//button[contains(., \'' + text + '\')]';
    };
    config.ip5.ui.locator['header'] = {};
    config.ip5.ui.locator.header['iparapheur'] = '//app-header//*[@routerlink=\'/\'][1]';
    config.ip5.ui.locator.header['Maison'] = '//app-header//*[@routerlink=\'/\'][last()]';
    config.ip5.ui.locator.header['Archives'] = '//app-header//*[@routerlink=\'/archive\']';
    config.ip5.ui.locator.header['Statistiques'] = '//app-header//*[@routerlink=\'/stats\']';
    config.ip5.ui.locator.header['Administration'] = "//app-header//*[contains(@class, 'fa-wrench')]//parent::fa-icon";
    config.ip5.ui.locator.header['Profil'] = '//app-header//*[@routerlink=\'/profile\']';
    config.ip5.ui.locator.header['Déconnexion'] = '//app-header//fa-icon[last()]';
    config.ip5.ui.locator['input'] = function (text) {
        // return '//input[@id=//label[contains(., \'' + text + '\')]/@for]';
            return '//input[@id=//label[contains(., \'' + text.replace("'", "\\\u0027") + '\')]/@for]';
    };

    config.ip5.ui.locator['tray'] = {};
    config.ip5.ui.locator.tray['filter'] = {};
    config.ip5.ui.locator.tray.filter['apply'] = "//app-folder-filter-panel//button//span[text()='Filtrer']";
    config.ip5.ui.locator.tray.filter['toggle'] = "//ngb-pagination/parent::div//button//span[text()='Filtrer']";

    /**
     * URL
     **/
    config.ip5.ui['admin'] = {};
    config.ip5.ui.admin['getRoleIndex'] = function(name) {
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
    config.ip5.ui.admin['selectTenant'] = function(tenant) {
        waitFor("//input[@aria-autocomplete='list']");
        click("//input[@aria-autocomplete='list']");
        input("//input[@aria-autocomplete='list']", tenant);
        click("//div[@class='ng-dropdown-panel-items scroll-host']//*[text()='" + tenant + "']");
    };

    /**
     * Elements
     **/
    config.ip5.ui['element'] = {};
    config.ip5.ui.element['breadcrumb'] = function(path) {
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
    config.ip5.ui['toast'] = {};
    config.ip5.ui.toast['success'] = function(message) {
        if (typeof message !== 'undefined') {
            return "//div[contains(@class, 'toast-success')]//*[contains(normalize-space(text()), '" + message + "')]";
        } else {
            return "//div[contains(@class, 'toast-success')]";
        }
    };

    /**
     * URL
     **/
    config.ip5.ui['url'] = {};
    config.ip5.ui.url['logout'] = '/auth/realms/api/protocol/openid-connect/logout';

    /**
     * User
     **/
    config.ip5.ui['user'] = {};
    config.ip5.ui.user['login'] = function(username, password) {
        karate.call('classpath:lib/ip5/ui/user/login.feature', { username: username, password: password });
    };
    config.ip5.ui.user['logout'] = function() {
        ip5.ui.user.menu("{^}Se déconnecter");
        waitFor('{^}Veuillez saisir vos identifiants de connexion');
    };
    config.ip5.ui.user['menu'] = function(locator) {
        mouse().move("//div[contains(@class, 'header-menu ')]").go();
        click(locator);
        // @todo: move somewhere else
    };

    //--------------------------------------------------------------------------

    // # @todo: à mettre ailleurs(ngSelect)  + généraliser l'usage
    // # Ne pas mettre les métadonnées dans l'intégration continue (@demo-simple-bde,@legacy-bridge,@formats-de-signature)
    config.ip5.ui['ngSelect'] = function(xpath, value) {
        ip.ui.expect(xpath + "//*[contains(concat(' ', @class, ' '),' ng-select-container ')]").click().script("_.dispatchEvent(new Event('mousedown'))");
        ip.ui.expect(xpath + "//*[@role='combobox'][@aria-expanded='true']");
        ip.ui.expect(xpath + "//ng-dropdown-panel[@role='listbox']");
        // @todo: value -> String (bool, etc...)
        ip.ui.expect(xpath + "//*[@role='option']//*[contains(concat(' ', @class, ' '),' ng-option-label ')][normalize-space(text())='" + value +"']").click();
    };

    // # @todo: à mettre ailleurs(ip_5.ip5.ui.business.metadatas.extract(?))
    config.ip5.ui['getMetadatas'] = function() {
        var actual = {},
            content,
            idx,
            label,
            lines,
            inputType,
            xpath = "//strong[text()='Métadonnées']/parent::div/parent::div/parent::div//app-step-metadata-list/div",
            inputXpath;

        lines = karate.sizeOf(locateAll(xpath));

        for (idx = 1;idx <= lines;idx++) {
            label = text(xpath + "[position() = " + idx + "]/label").trim();

            content = null;
            if (exists(xpath + "[position() = " + idx + "]/app-metadata-input//ng-select") === true) {
                inputXpath = xpath + "[position() = " + idx + "]/app-metadata-input//ng-select";
                content = text(inputXpath + "//span[contains(@class, 'ng-value-label')]").trim();//@fixme: la valeur ? ou reformater ?
                if (content !== "") {
                    inputType = ip.business.metadonnees.types[ip.business.metadonnees.inverse[label]];
                    if (inputType === "BOOLEAN") {
                        if (content === "Oui") {
                            content = true;
                        } else if (content === "Non") {
                            content = false;
                        }
                    } else if (inputType === "DATE") {
                        content = content.replace(/^(..)\/(..)\/(....)$/, "$3-$2-$1");
                    } else if (inputType === "FLOAT") {
                        content = parseFloat(content);
                    } else if (inputType === "INTEGER") {
                        content = parseInt(content, 10);
                    }
                }
            } else if (exists(xpath + "[position() = " + idx + "]/app-metadata-input//input") === true) {
                inputXpath = xpath + "[position() = " + idx + "]/app-metadata-input//input";
                content = value(inputXpath).trim();
                if (content !== "") {
                    inputType = ip.business.metadonnees.types[ip.business.metadonnees.inverse[label]];
                    if (inputType === "FLOAT") {
                        content = parseFloat(content);
                    } else if (inputType === "INTEGER") {
                        content = parseInt(content, 10);
                    }
                }
            } else {
                karate.fail('Champ non trouvé via "' + xpath + "[position() = " + idx + "]/app-metadata-input//ng-select" + '" ou "' + xpath + "[position() = " + idx + "]/app-metadata-input//input" + '"');
            }

            actual[ip.business.metadonnees.inverse[label]] = content;
        }

        return actual;
    };

    return config;
}
