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

    // Classpath shortcuts for common files
    config.ip['commonpath'] = {};
    config.ip.commonpath['absolute'] = function(basename) {
        return karate.toAbsolutePath(ip.commonpath.get(basename));
    };
    config.ip.commonpath['get'] = function(basename) {
        var paths = {
            "document_libre_office.odt": "classpath:files/formats/document_libre_office/document_libre_office.odt",
            "document_office.doc": "classpath:files/formats/document_office/document_office.doc",
            "document_office/signature_cades.p7s": "classpath:files/formats/document_office/signature_cades.p7s",
            "document_office/signature_xades.xml": "classpath:files/formats/document_office/signature_xades.xml",
            "document_ooxml.docx": "classpath:files/formats/document_ooxml/document_ooxml.docx",
            "document_ooxml/signature_cades.p7s": "classpath:files/formats/document_ooxml/signature_cades.p7s",
            "document_ooxml/signature_xades.xml": "classpath:files/formats/document_ooxml/signature_xades.xml",
            "document_rtf.rtf": "classpath:files/formats/document_rtf/document_rtf.rtf",
            "document_rtf/signature_cades.p7s": "classpath:files/formats/document_rtf/signature_cades.p7s",
            "document_rtf/signature_xades.xml": "classpath:files/formats/document_rtf/signature_xades.xml",
            "PESALR1_unsigned.xml": "classpath:files/formats/PESALR1_unsigned.xml",
            "pesWithASAP_unsigned.xml": "classpath:files/formats/pesWithASAP_unsigned.xml",
            "PDF_avec_tags.pdf": "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf",
            "PDF_avec_tags/signature_cades.p7s": "classpath:files/formats/PDF_avec_tags/signature_cades.p7s",
            "PDF_avec_tags/signature_xades.xml": "classpath:files/formats/PDF_avec_tags/signature_xades.xml",
            "PDF_avec_tags-signature_pades.pdf": "classpath:files/formats/PDF_avec_tags/PDF_avec_tags-signature_pades.pdf",
            "PDF_sans_tags.pdf": "classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf",
            "PDF_sans_tags/signature_cades.p7s": "classpath:files/formats/PDF_sans_tags/signature_cades.p7s",
            "PDF_sans_tags/signature_xades.xml": "classpath:files/formats/PDF_sans_tags/signature_xades.xml",
            "PDF_sans_tags-signature_pades.pdf": "classpath:files/formats/PDF_sans_tags/PDF_sans_tags-signature_pades.pdf",
        };
        if (paths.hasOwnProperty(basename) === true) {
            return paths[basename];
        }

        karate.log("File \"" + basename + "\" is missing from commonpath");
        karate.fail("File \"" + basename + "\" is missing from commonpath");
    };
    config.ip.commonpath['read'] = function(basename) {
        return karate.read(ip.commonpath.get(basename));
    };

    config.ip['pause'] = function(seconds){
        java.lang.Thread.sleep(seconds * 1000);
    };

    /**
     * utils
     */
    config['utils'] = {};

    config.ip.utils['array'] = {};
    // @see https://stackoverflow.com/a/43046408
    config.ip.utils.array['getUnique'] = function (arr) {
        var a = [];
        for (var i=0, l=arr.length; i<l; i++)
            if (a.indexOf(arr[i]) === -1 && arr[i] !== '')
                a.push(arr[i]);
        return a;
    };

    config.ip.utils['certificate'] = {};
    config.ip.utils.certificate['alias'] = function(path, password) {
        return ip.utils.safeExec([karate.toAbsolutePath("classpath:lib/certinfos.sh"), "alias", karate.toAbsolutePath(path), password]);
    };
    config.ip.utils.certificate['base64Public'] = function(path) {
        var collect = false,
            content = karate.readAsString(path),
            idx,
            lines = content.split(/\r?\n/),
            result = '';

        for(idx = 0;idx < lines.length;idx++) {
            if (lines[idx].match(/^\-+ *BEGIN/) !== null) {
                collect = true;
            } else if (lines[idx].match(/^\-+ *END/) !== null) {
                collect = false;
            } else if(collect === true) {
                result += lines[idx];
            }
        }

        return result;
    };
    config.ip.utils.certificate['signHash'] = function(path, hash) {
        var cmd = [
            "/bin/sh",
            "-c",
            "echo \"" + hash +" \" | python3 -m base64 -d | openssl dgst -sha256 -sign \"" + karate.toAbsolutePath(path) +"\" | python3 -m base64 | tr -d '\\n'"
        ];
        return ip.utils.safeExec(cmd);
    };
    config.ip.utils.certificate['enddate'] = function(path, password) {
        return ip.utils.safeExec([karate.toAbsolutePath("classpath:lib/certinfos.sh"), "enddate", karate.toAbsolutePath(path), password]);
    };
    config.ip.utils.certificate['issuer'] = function(path, password) {
        return ip.utils.safeExec([karate.toAbsolutePath("classpath:lib/certinfos.sh"), "issuer", karate.toAbsolutePath(path), password]);
    };
    config.ip.utils.certificate['subject'] = function(path, password) {
        return ip.utils.safeExec([karate.toAbsolutePath("classpath:lib/certinfos.sh"), "subject", karate.toAbsolutePath(path), password]);
    };

    config.ip.utils.array['getSortedUnique'] = function (array) {
        return ip.utils.array.getUnique(array).sort();
    };

    config.ip.utils['eval'] = function (value) {
        var matches = (''+value).match(/^eval\((.*)\)$/),
            result = value;
        if (matches !== null) {
            result = karate.eval(matches[1]);//@todo: try/catch
        }
        return result;
    };
    config.ip.utils['file'] = {};
    config.ip.utils.file['basename'] = function (path) {
        return String(path).replace(/^(.*)\/([^\/]+)$/, '$2');
    };
    config.ip.utils.file['dirname'] = function (path) {
        return String(path).replace(/^(.*)\/([^\/]+)$/, '$1');
    };
    config.ip.utils.file['extension'] = function (path) {
        return path.split(".").pop().toLowerCase();
    };
    config.ip.utils.file['mime'] = function(filename) {
        var extension = ip.utils.file.extension(filename),
            associations = {
                'doc': 'application/msword',
                'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                'odt': 'application/vnd.oasis.opendocument.text',
                'p7s': 'application/pkcs7-signature',
                'pdf': 'application/pdf',
                'png': 'image/png',
                'rtf': 'application/rtf',
                'xml': 'text/xml'
            };
        if (extension in associations) {
            return associations[extension];
        } else {
            // @todo: warn
            return 'application/octet-stream';
        }
    };
    config.ip.utils.file['payload'] = function(path, defaultValue) {
        defaultValue = typeof defaultValue === undefined ? null : defaultValue;
        if (ip.utils.isEmpty(path) === false) {
            return { read: path, 'contentType': ip.utils.file.mime(path), 'filename': ip.utils.file.basename(path) };
        }
        return defaultValue;
    }
    config.ip.utils['filterMap'] = function (map) {
        var result = {};

        for (const key in map) {
            const value = map[key];
            karate.log({value: value, key: key});
            if (ip.utils.isEmpty(value) === false) {
                result[key] = value;
            }
        }

        return result;
    };
    // @see https://stackoverflow.com/a/14794066
    config.ip.utils['isInteger'] = function (value) {
        return !isNaN(value) && parseInt(Number(value)) == value && !isNaN(parseInt(value, 10));
    };
    config.ip.utils['getUUID'] = function (length = 32) {
        // @see https://github.com/intuit/karate#commonly-needed-utilities
        return java.util.UUID.randomUUID() + '';
    };
    config.ip.utils['getUniqueName'] = function(prefix) {
        return String(prefix) + Date.now();
    };
    config.ip.utils['assert'] = function(string) {
        var result = karate.match(string)
        if (result.pass !== true) {
            karate.fail(result.message);
        }
        return result;
    };
    /**
     * ip.utils.string
     */
    config.ip.utils['isEmpty'] = function (value) {
        // https://stackoverflow.com/a/32108184
        var isEmptyObject = value && Object.keys(value).length === 0 && Object.getPrototypeOf(value) === Object.prototype;
        var isEmptyArray = Array.isArray(value) && value.length == 0;
        if (value == undefined || value == null || value == '' || isEmptyObject || value == []) {
            return true;
        }
        return false;
    };
    config.ip.utils['safeExec'] = function(command) {
        var proc = karate.fork(command);
        proc.waitSync();
        if (proc.exitCode !== 0) {
            karate.fail('Got status code ' + proc.exitCode + ' for command ' + command);
        }
        return proc.sysOut.replace(/\n$/, '');
    };
    /**
     * ip.utils.string
     */
    config.ip.utils['string'] = {
        'letters_lowercase': 'abcdefghijklmnopqrstuvwxyz',
        'letters_uppercase': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'numbers': '9876543210',
    };
    config.ip.utils.string.normalize = function(text) {
        return (text === null ? '' : String(text)).trim();

    };
    config.ip.utils.string['letters'] = config.ip.utils.string['letters_lowercase'] + config.ip.utils.string['letters_uppercase'];
    // @deprecated
    config.ip.utils.string['getByLength'] = function(length, prefix = null, characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') {
        prefix = prefix === null ? '' : prefix;
        let charactersLength = String(characters).length;
        return String(String(prefix) + String(characters).repeat(Math.ceil(length/charactersLength))).substr(0, length);
    };
    config.ip.utils.string['getRandom'] = function(length, prefix = null, characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') {
        // @see https://stackoverflow.com/a/1349426
        prefix = prefix === null ? '' : prefix;
        let charactersLength = String(characters).length,
            result =  [];
        for ( var i = 0; i < length - String(prefix).length; i++ ) {
            result.push(characters.charAt(Math.floor(Math.random()*charactersLength)));
        }
        return String(String(prefix) + result.join('')).substr(0, length);
    };

    config.ip.utils['xmlPathSortedUnique'] = function(xml, expression) {
        var extracted = karate.xmlPath(xml, expression)
        if (typeof extracted !== 'object') {
            extracted = [extracted];
        }
        return (extracted == '#notpresent') ? [] : ip.utils.array.getSortedUnique(extracted);
    };

    return config;
}
