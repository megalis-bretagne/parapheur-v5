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
    config['ip'] = config['ip'] || {};
    config.ip['api'] = config.ip['api'] || {};
    config.ip.api['soap'] = config.ip.api['soap'] || {};

    config.ip.api.soap['dossier'] = {};
    config.ip.api.soap.dossier['filterDossiersIdsByName'] = function (dossierIds, expected, params) {
        if(Array.isArray(dossierIds) === false) {
            dossierIds = [dossierIds];
        }

        for(var idx = 0;idx < dossierIds.length;idx++) {
            params['dossierId'] = dossierIds[idx];
            var rv = karate.call('classpath:lib/ip/api/soap/requests/GetDossier/simple.feature', params),
                name = karate.xmlPath(rv.response, '//MetaDonnee/nom[.="ph:dossierTitre"]/ancestor::MetaDonnee/valeur');
            if (name === expected) {
                return dossierIds[idx];
            }
        }

        karate.fail('Folder with name "' + expected + '" not found amongst the following ids: ' + JSON.stringify(dossierIds));
    };

    config.ip.api.soap['file'] = {};
    config.ip.api.soap.file['encode'] = function(path) {
        var Base64 = Java.type('java.util.Base64'),
            ext = ip.utils.file.extension(path),
            result;
        if (ext === 'xml') {
            result = karate.call('classpath:lib/ip/xmlstring.feature', { value: karate.read(path) });
            return result.xml;
        } else {
            return Base64.encoder.encodeToString(karate.read(path));
        }
    };

    config.ip.api.soap['schema'] = {};
    config.ip.api.soap.schema['folder'] = {};
    config.ip.api.soap.schema.folder['statuses'] = '#regex (Archive|CachetOK|EnCoursMailSecPastell|EnCoursVisa|Lu|NonLu|PretCachet|RejetCachet|RejetMailSecPastell|RejetSignataire|RejetVisa|Signe|Vise)';
    config.ip.api.soap.schema['logDossier'] = {};
    config.ip.api.soap.schema.logDossier['timestamp'] = '#regex ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}(Z|(\\+|-)[0-9]{2}:[0-9]{2})$';

    config.ip.api.soap['url'] = function() {
        return soapBaseUrl.replace(/\/$/, '') + "/ws-iparapheur-no-mtom";
    };

    config.ip.api.soap['user'] = {};
    config.ip.api.soap.user['authorization'] = function(username, password) {
        return karate.call(
            'classpath:lib/ip/basic-auth.js',
            {
                username: username,
                password: password
            }
        );
    };

    return config;
}
