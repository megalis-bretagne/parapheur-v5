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

function fn() {
    var env = karate.env; // get system property 'karate.env'
    karate.log('karate.env system property was:', env);

    if (!env) {
        env = 'dev';
    }
    const baseUrl = karate.properties['karate.baseUrl'] || 'http://iparapheur.dom.local/';
    const soapBaseUrl = karate.properties['karate.soapBaseUrl'] || baseUrl;
    const chromeBin = karate.properties['karate.chromeBin'] || '/usr/bin/chromium-browser';
    const adminUserPwd = karate.properties['karate.adminUserPwd'] || 'pass';

    // Skip SSL certificate validation
    karate.configure("ssl", true);

    var config = {
        env: env,
        //@fixme: APPLICATION_HOST, APPLICATION_PROTOCOL and CHROME_BIN -> null ?
        //baseUrl: java.lang.System.getenv('APPLICATION_PROTOCOL') + '://' + java.lang.System.getenv('APPLICATION_HOST'),
        baseUrl: baseUrl,
        buildDir: karate.toAbsolutePath("classpath:karate-config.js").replace(/^(.*\/build\/).*$/, '$1'),
        soapBaseUrl: soapBaseUrl,
        adminUserPwd:  adminUserPwd,
        // baseUrl: 'https://iparapheur-5-0.dev.libriciel.net/',
        // baseUrl: 'https://iparapheur-5-0.recette.libriciel.net/',
        // CHROME_BIN: java.lang.System.getenv('CHROME_BIN'),
        CHROME_BIN: chromeBin,
        headless: (function () {
            var headless = String(karate.properties['karate.headless']).toLowerCase();
            if (headless === '' || headless === 'true') {
                return true;
            } else if (headless === 'false') {
                return false;
            } else {
                karate.fail(
                    'Invalid value for karate.headless ('
                    + String(karate.properties['karate.headless'])
                    + '), please use one of: false, true'
                );
            }
        })()
    };

    if (env === 'dev') {
        // customize
        // e.g. config.foo = 'bar';
    } else if (env === 'e2e') {
        // customize
    } else if (env === 'ci') {
        karate.configure('driverTarget', {docker: 'ptrthomas/karate-chrome'});
    }

    karate.configure('headers', {Accept: 'application/json'});

    // @see https://medium.com/@babusekaran/organizing-re-usable-functions-karatedsl-575cd76daa27
    // Common code
    config = karate.call('classpath:lib/ip/api/soap.js', config);
    config = karate.call('classpath:lib/ip/business/metadonnees.js', config);
    config = karate.call('classpath:lib/ip/common.js', config);
    config = karate.call('classpath:lib/ip/signature.js', config);
    config = karate.call('classpath:lib/ip/templates.js', config);
    config = karate.call('classpath:lib/ip/ui.js', config);
    // IP 4 code
    config = karate.call('classpath:lib/ip4/common.js', config);
    // IP 5 code
    config = karate.call('classpath:lib/ip5/api/v1.js', config);
    config = karate.call('classpath:lib/ip5/business.js', config);
    config = karate.call('classpath:lib/ip5/common.js', config);
    config = karate.call('classpath:lib/ip5/ui.js', config);

    return config;
}
