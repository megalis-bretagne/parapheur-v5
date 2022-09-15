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
    config.ip['business'] = config.ip['business'] || {};
    config.ip.business['metadonnees'] = config.ip.business['metadonnees'] || {};

    config.ip.business.metadonnees['types'] = {
        booleen: "BOOLEAN",
        date: "DATE",
        date_restreinte: "DATE",
        nombre_virgule: "FLOAT",
        nombre_virgule_restreint: "FLOAT",
        nombre_entier: "INTEGER",
        nombre_entier_restreint: "INTEGER",
        texte: "TEXT",
        texte_restreint: "TEXT",
        url: "TEXT",
        url_restreint: "TEXT"
    };

    config.ip.business.metadonnees['labels'] = {
        booleen: "Booléen",
        date: "Date",
        date_restreinte: "Date restreinte",
        nombre_virgule: "Nombre à virgule",
        nombre_virgule_restreint: "Nombre à virgule restreint",
        nombre_entier: "Nombre entier",
        nombre_entier_restreint: "Nombre entier restreint",
        texte: "Texte",
        texte_restreint: "Texte restreint",
        url: "URL",
        url_restreint: "URL restreint"
    };

    config.ip.business.metadonnees['inverse'] = {
        "Booléen": "booleen",
        "Date": "date",
        "Date restreinte": "date_restreinte",
        "Nombre à virgule": "nombre_virgule",
        "Nombre à virgule restreint": "nombre_virgule_restreint",
        "Nombre entier": "nombre_entier",
        "Nombre entier restreint": "nombre_entier_restreint",
        "Texte": "texte",
        "Texte restreint": "texte_restreint",
        "URL": "url",
        "URL restreint": "url_restreint"
    };

    config.ip.business.metadonnees['tmp'] = {
        "Rejet - Aucune métadonnée": {},
        "Rejet - Booleen rejet": {booleen: false},
        "Rejet - Booleen visa": {},
        "Rejet - Booleen rejet et visa": {booleen: false},
        "Rejet - Texte rejet": {texte: "Texte rejet"},
        "Rejet - Texte visa": {},
        "Rejet - Texte rejet et visa": {texte: "Texte rejet"},
        "Rejet - Toutes visa et rejet": {
            booleen: false,
            date: "2022-09-01",
            date_restreinte: "2022-01-15",
            nombre_virgule: 0.33,
            nombre_virgule_restreint: 0,
            nombre_entier: 0,
            nombre_entier_restreint: 0,
            texte: "Texte rejet",
            texte_restreint: "a",
            url: "https://perdu.com/",
            url_restreint: "http://www.lesoir.be",
        },
        "Visa - Aucune métadonnée": {},
        "Visa - Booleen rejet": {},
        "Visa - Booleen visa": {booleen: true},
        "Visa - Booleen rejet et visa": {booleen: true},
        "Visa - Texte rejet": {},
        "Visa - Texte visa": {texte: "Texte visa"},
        "Visa - Texte rejet et visa": {texte: "Texte visa"},
        "Visa - Toutes visa et rejet": {
            booleen: true,
            date: "2022-09-02",
            date_restreinte: "2022-02-15",
            nombre_virgule: 0.77,
            nombre_virgule_restreint: 1.5,
            nombre_entier: 1,
            nombre_entier_restreint: 2,
            texte: "Texte visa",
            texte_restreint: "b",
            url: "https://dernierepage.com/",
            url_restreint: "https://www.libriciel.fr/nos-logiciels/",
        }
    };

    config.ip.business.metadonnees['map'] = {
        "Groupe - Rejet - Aucune métadonnée": config.ip.business.metadonnees.tmp['Rejet - Aucune métadonnée'],
        "Groupe - Rejet - Booleen rejet": config.ip.business.metadonnees.tmp['Rejet - Booleen rejet'],
        "Groupe - Rejet - Booleen visa": config.ip.business.metadonnees.tmp['Rejet - Booleen visa'],
        "Groupe - Rejet - Booleen rejet et visa": config.ip.business.metadonnees.tmp['Rejet - Booleen rejet et visa'],
        "Groupe - Rejet - Texte rejet": config.ip.business.metadonnees.tmp['Rejet - Texte rejet'],
        "Groupe - Rejet - Texte visa": config.ip.business.metadonnees.tmp['Rejet - Texte visa'],
        "Groupe - Rejet - Texte rejet et visa": config.ip.business.metadonnees.tmp['Rejet - Texte rejet et visa'],
        "Groupe - Rejet - Toutes visa et rejet": config.ip.business.metadonnees.tmp['Rejet - Toutes visa et rejet'],
        "Groupe - Visa - Aucune métadonnée": config.ip.business.metadonnees.tmp['Visa - Aucune métadonnée'],
        "Groupe - Visa - Booleen rejet": config.ip.business.metadonnees.tmp['Visa - Booleen rejet'],
        "Groupe - Visa - Booleen visa": config.ip.business.metadonnees.tmp['Visa - Booleen visa'],
        "Groupe - Visa - Booleen rejet et visa": config.ip.business.metadonnees.tmp['Visa - Booleen rejet et visa'],
        "Groupe - Visa - Texte rejet": config.ip.business.metadonnees.tmp['Visa - Texte rejet'],
        "Groupe - Visa - Texte visa": config.ip.business.metadonnees.tmp['Visa - Texte visa'],
        "Groupe - Visa - Texte rejet et visa": config.ip.business.metadonnees.tmp['Visa - Texte rejet et visa'],
        "Groupe - Visa - Toutes visa et rejet": config.ip.business.metadonnees.tmp['Visa - Toutes visa et rejet'],
        "Individuel - Rejet - Aucune métadonnée": config.ip.business.metadonnees.tmp['Rejet - Aucune métadonnée'],
        "Individuel - Rejet - Booleen rejet": config.ip.business.metadonnees.tmp['Rejet - Booleen rejet'],
        "Individuel - Rejet - Booleen visa": config.ip.business.metadonnees.tmp['Rejet - Booleen visa'],
        "Individuel - Rejet - Booleen rejet et visa": config.ip.business.metadonnees.tmp['Rejet - Booleen rejet et visa'],
        "Individuel - Rejet - Texte rejet": config.ip.business.metadonnees.tmp['Rejet - Texte rejet'],
        "Individuel - Rejet - Texte visa": config.ip.business.metadonnees.tmp['Rejet - Texte visa'],
        "Individuel - Rejet - Texte rejet et visa": config.ip.business.metadonnees.tmp['Rejet - Texte rejet et visa'],
        "Individuel - Rejet - Toutes visa et rejet": config.ip.business.metadonnees.tmp['Rejet - Toutes visa et rejet'],
        "Individuel - Visa - Aucune métadonnée": config.ip.business.metadonnees.tmp['Visa - Aucune métadonnée'],
        "Individuel - Visa - Booleen rejet": config.ip.business.metadonnees.tmp['Visa - Booleen rejet'],
        "Individuel - Visa - Booleen visa": config.ip.business.metadonnees.tmp['Visa - Booleen visa'],
        "Individuel - Visa - Booleen rejet et visa": config.ip.business.metadonnees.tmp['Visa - Booleen rejet et visa'],
        "Individuel - Visa - Texte rejet": config.ip.business.metadonnees.tmp['Visa - Texte rejet'],
        "Individuel - Visa - Texte visa": config.ip.business.metadonnees.tmp['Visa - Texte visa'],
        "Individuel - Visa - Texte rejet et visa": config.ip.business.metadonnees.tmp['Visa - Texte rejet et visa'],
        "Individuel - Visa - Toutes visa et rejet": config.ip.business.metadonnees.tmp['Visa - Toutes visa et rejet'],
        "Liste - Rejet - Aucune métadonnée": config.ip.business.metadonnees.tmp['Rejet - Aucune métadonnée'],
        "Liste - Rejet - Booleen rejet": config.ip.business.metadonnees.tmp['Rejet - Booleen rejet'],
        "Liste - Rejet - Booleen visa": config.ip.business.metadonnees.tmp['Rejet - Booleen visa'],
        "Liste - Rejet - Booleen rejet et visa": config.ip.business.metadonnees.tmp['Rejet - Booleen rejet et visa'],
        "Liste - Rejet - Texte rejet": config.ip.business.metadonnees.tmp['Rejet - Texte rejet'],
        "Liste - Rejet - Texte visa": config.ip.business.metadonnees.tmp['Rejet - Texte visa'],
        "Liste - Rejet - Texte rejet et visa": config.ip.business.metadonnees.tmp['Rejet - Texte rejet et visa'],
        "Liste - Rejet - Toutes visa et rejet": config.ip.business.metadonnees.tmp['Rejet - Toutes visa et rejet'],
        "Liste - Visa - Aucune métadonnée": config.ip.business.metadonnees.tmp['Visa - Aucune métadonnée'],
        "Liste - Visa - Booleen rejet": config.ip.business.metadonnees.tmp['Visa - Booleen rejet'],
        "Liste - Visa - Booleen visa": config.ip.business.metadonnees.tmp['Visa - Booleen visa'],
        "Liste - Visa - Booleen rejet et visa": config.ip.business.metadonnees.tmp['Visa - Booleen rejet et visa'],
        "Liste - Visa - Texte rejet": config.ip.business.metadonnees.tmp['Visa - Texte rejet'],
        "Liste - Visa - Texte visa": config.ip.business.metadonnees.tmp['Visa - Texte visa'],
        "Liste - Visa - Texte rejet et visa": config.ip.business.metadonnees.tmp['Visa - Texte rejet et visa'],
        "Liste - Visa - Toutes visa et rejet": config.ip.business.metadonnees.tmp['Visa - Toutes visa et rejet'],
    };

    return config;
}
