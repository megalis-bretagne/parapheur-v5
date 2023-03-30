/*
 * iparapheur
 * Copyright (C) 2019-2023 Libriciel SCOP
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
    config['ip'] = config['ip'] || {};
    config.ip['ui'] = config.ip['ui'] || {};

    /**
     * Driver
     **/
    config.ip.ui['driver'] = {};
    // @see https://github.com/intuit/karate/blob/master/karate-demo/src/test/java/driver/demo/demo-01.feature
    config.ip.ui.driver['configure'] = {
        executable: config.CHROME_BIN,
        headless: config.headless,
        showDriverLog: false,
        type: 'chrome',
        // @see https://github.com/karatelabs/karate/blob/master/karate-docker/karate-chrome/supervisord.conf
        // @see https://stackoverflow.com/questions/73337435/karate-dsl-options-window-size-and-incognito-is-not-working-for-chromedrive
        addOptions: ['--disable-gpu','lang=fr_FR,fr', '--remote-allow-origins=*'],
        //addOptions: ['--windows-size=1024,768'],
        /*webDriverSession: {
            capabilities: { 'goog:chromeOptions': { 'credentials_enable_service': false, 'profile.password_manager_enabled': false } },
            desiredCapabilities: { 'goog:chromeOptions': { 'credentials_enable_service': false, 'profile.password_manager_enabled': false } },
            prefs: { 'credentials_enable_service': false, 'profile.password_manager_enabled': false },
        }*/
    };

    config.ip.ui['expect'] = function(locator, retries = 10, context = null) {
        var cnt = 0;
        karate.log("Expecting locator (" + String(retries) + " retries max)" + locator);
        while(exists(locator) === false && cnt < retries) {
            karate.log("Retry #" + String(cnt + 1));
            cnt++;
            ip.pause(1);
        }
        if(exists(locator) === false) {
            driver.screenshot();
            if (typeof context !== "undefined") {
                karate.log("... HTML context: " + html(context));
            }
            karate.fail("... not found " + locator);
            throw new Error("Expected locator not found " + locator);
        } else {
            // @todo: not when found ?
            if (typeof context !== "undefined" && context !== null) {
                karate.log("... HTML context: " + html(context));
            }
            karate.log("... found " + locator);
            return locate(locator);
        }
    };

    return config;
}
