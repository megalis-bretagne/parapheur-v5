/*
 * i-Parapheur
 * Copyright (C) 2019-2021 Libriciel SCOP
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

    var config = {
        env: env,
        //@fixme: APPLICATION_HOST, APPLICATION_PROTOCOL and CHROME_BIN -> null ?
        //baseUrl: java.lang.System.getenv('APPLICATION_PROTOCOL') + '://' + java.lang.System.getenv('APPLICATION_HOST'),
        baseUrl: 'http://iparapheur.dom.local/',
        // baseUrl: 'https://iparapheur-5-0.recette.libriciel.net/',
        // CHROME_BIN: java.lang.System.getenv('CHROME_BIN'),
        CHROME_BIN: '/usr/bin/chromium-browser',
        headless: String(karate.properties['karate.headless']).toLowerCase() !== 'false'
    };

    if (env === 'dev') {
        // customize
        // e.g. config.foo = 'bar';
    } else if (env === 'e2e') {
        // customize
    }

    karate.configure('headers', { Accept: 'application/json' });

    // @see https://medium.com/@babusekaran/organizing-re-usable-functions-karatedsl-575cd76daa27
    config = karate.call('classpath:lib/api_v1.js', config);
    config = karate.call('classpath:lib/common.js', config);
    config = karate.call('classpath:lib/ui.js', config);

    return config;
}
