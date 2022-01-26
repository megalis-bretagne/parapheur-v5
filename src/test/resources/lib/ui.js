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
        return '//input[@id=//label[contains(., \'' + text + '\')]/@for]';
    };

    /**
     * URL
     **/
    config.ui['url'] = {};
    config.ui.url['logout'] = '/auth/realms/api/protocol/openid-connect/logout';

    return config;
}
