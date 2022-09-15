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
    config.ip['templates'] = config.ip['templates'] || (function (config) {
        var templates = {};

        templates['annotations'] = {};
        templates.annotations['getPrivate'] = function (username, action, folder) {
            return "Annotation privée " + username + " (" + karate.lowerCase(action) + " du dossier " + folder + ")";
        };
        templates.annotations['getPublic'] = function (username, action, folder) {
            return "Annotation publique " + username + " (" + karate.lowerCase(action) + " du dossier " + folder + ")";
        };
        templates['certificate'] = {};
        templates.certificate['default'] = function (subPath) {
            return {
                public: "classpath:files/certificates/" + subPath + "/public.pem",
                private: "classpath:files/certificates/" + subPath + "/private.pem"
            };
        };

        return templates;
    })(config);

    return config;
}
