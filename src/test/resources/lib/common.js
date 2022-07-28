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
        config['downloadpath'] = {};
    // @todo: fail si le jsonPath ne retourne rien
    config.downloadpath['annexe'] = function(files, basename, prefix) {
        prefix = typeof prefix === "undefined" ? "file://" : prefix;
        return prefix + buildDir + karate.jsonPath(files, "$.annexes['" + basename +"']");
    };
    config.downloadpath['detached'] = function(files, basename, prefix) {
        prefix = typeof prefix === "undefined" ? "file://" : prefix;
        return prefix + buildDir + karate.jsonPath(files, "$.documents[*][*].detached['" + basename +"']");
    };
    config.downloadpath['document'] = function(files, basename, prefix) {
        prefix = typeof prefix === "undefined" ? "file://" : prefix;
        return prefix + buildDir + karate.jsonPath(files, "$.documents[*]['" + basename +"'].path");
    };
    config.downloadpath['readAnnexe'] = function(files, basename, prefix) {
        return karate.read(downloadpath.annexe(files, basename, prefix));
    };
    config.downloadpath['readDetached'] = function(files, basename, prefix) {
        return karate.read(downloadpath.detached(files, basename, prefix));
    };
    config.downloadpath['readDocument'] = function(files, basename, prefix) {
        return karate.read(downloadpath.document(files, basename, prefix));
    };
    // Classpath shortcuts for common files
    config['commonpath'] = {};
    config.commonpath['absolute'] = function(basename) {
        return karate.toAbsolutePath(commonpath.get(basename));
    };
    config.commonpath['get'] = function(basename) {
        var paths = {
            "document_libre_office.odt": "classpath:files/formats/document_libre_office/document_libre_office.odt",
            "document_rtf.rtf": "classpath:files/formats/document_rtf/document_rtf.rtf",
            "document_rtf/signature_cades.p7s": "classpath:files/formats/document_rtf/signature_cades.p7s",
            "document_rtf/signature_xades.xml": "classpath:files/formats/document_rtf/signature_xades.xml",
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
    config.commonpath['read'] = function(basename) {
        return karate.read(commonpath.get(basename));
    };

    config['scenario'] = {'title': {}};

    //==================================================================================================================
    // Scenario titles
    //==================================================================================================================
/*
You are here: @666

Scenario Outline: ${scenario.title.permissions(role, 'get the tenant list', status)}
Scenario Outline: ${scenario.title.searching('ADMIN', 'get the tenant list', 200, total, searchTerm, sortBy, asc)}

Scenario Outline: ${scenario.title.permissions(role, 'create a tenant', status)}
Scenario Outline: ${scenario.title.validation('ADMIN', 'create a tenant', status, wrong_data)}

Scenario Outline: ${scenario.title.permissions(role, 'edit an existing tenant', status)}
Scenario Outline: ${scenario.title.permissions(role, 'edit a non-existing tenant', status)}
Scenario Outline: ${scenario.title.validation('ADMIN', 'edit a tenant', status, wrong_data)}

Scenario Outline: ${scenario.title.permissions(role, 'delete an existing tenant', status)}
Scenario Outline: ${scenario.title.permissions(role, 'delete a non-existing tenant', status)}
*/

    config.scenario.title['existing'] = function(exists){
        return exists == true ? 'an existing' : 'a non existing';
    };

    config.scenario.title['role'] = function(role){
        return role !== '' && role !== null ? 'a user with the role "' + role + '"' : 'an unauthenticated user';
    };

    config.scenario.title['permissions'] = function(role, target, status){
        role = scenario.title.role(utils.string.normalize(role));
        status = scenario.title.status(status);
        target = utils.string.normalize(target);

        return 'Permissions - ' + role + ' ' + status + ' ' + target;
    };

    config.scenario.title['validation'] = function(role, target, status, data){
        role = scenario.title.role(utils.string.normalize(role));
        status = scenario.title.status(status);
        target = utils.string.normalize(target);

        return 'Data validation - ' + role + ' ' + status + ' ' + target + ' with ' + String(data);
    };

    config.scenario.title['searching'] = function(role, target, status, total, searchTerm = null, sortBy = null, asc = null){
        role = scenario.title.role(utils.string.normalize(role));
        searchTerm = utils.string.normalize(searchTerm);
        status = scenario.title.status(status);
        target = utils.string.normalize(target);

        return 'Searching - ' + role + ' ' + status + ' '
            + target
            + ( searchTerm === '' ? '' : ' filtered with "' + searchTerm + '"' ) + ' '
            + scenario.title.sorted(sortBy, asc)
            + ' and obtain ' + total + ' ' + (total < 2 ? 'result' : 'results') + ' '
        ;
    };

    config.scenario.title['sorted'] = function(field = null, direction = null){
        field = utils.string.normalize(field);

        if (field === '' || utils.string.normalize(direction) === '') {
            return '';
        } else {
            return 'sorted by ' + field + ' ' + (direction === true ? 'ascending' : 'descending');
        }
    };

    config.scenario.title['status'] = function(status){
        return String(status).match(/^[2-3]/) ? 'can' : 'cannot';
    };

    config['pause'] = function(seconds){
        java.lang.Thread.sleep(seconds * 1000);
    };

    /**
     * utils
     */
    config['utils'] = {};

    config.utils['array'] = {};
    // @see https://stackoverflow.com/a/43046408
    config.utils.array['getUnique'] = function (arr) {
        var a = [];
        for (var i=0, l=arr.length; i<l; i++)
            if (a.indexOf(arr[i]) === -1 && arr[i] !== '')
                a.push(arr[i]);
        return a;
    };

    config.utils['certificate'] = {};
    config.utils.certificate['alias'] = function(path, password) {
        return utils.safeExec([karate.toAbsolutePath("classpath:lib/certinfos.sh"), "alias", karate.toAbsolutePath(path), password]);
    };
    config.utils.certificate['base64Public'] = function(path) {
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
    config.utils.certificate['signHash'] = function(path, hash) {
        var cmd = [
            "/bin/sh",
            "-c",
            "echo \"" + hash +" \" | python -m base64 -d | openssl dgst -sha256 -sign \"" + karate.toAbsolutePath(path) +"\" | python -m base64 | tr -d '\\n'"
        ];
        return utils.safeExec(cmd);
    };
    config.utils.certificate['enddate'] = function(path, password) {
        return utils.safeExec([karate.toAbsolutePath("classpath:lib/certinfos.sh"), "enddate", karate.toAbsolutePath(path), password]);
    };
    config.utils.certificate['issuer'] = function(path, password) {
        return utils.safeExec([karate.toAbsolutePath("classpath:lib/certinfos.sh"), "issuer", karate.toAbsolutePath(path), password]);
    };
    config.utils.certificate['subject'] = function(path, password) {
        return utils.safeExec([karate.toAbsolutePath("classpath:lib/certinfos.sh"), "subject", karate.toAbsolutePath(path), password]);
    };

    config.utils.array['getSortedUnique'] = function (array) {
        return utils.array.getUnique(array).sort();
    };

    config.utils['eval'] = function (value) {
        var matches = (''+value).match(/^eval\((.*)\)$/),
            result = value;
        if (matches !== null) {
            result = karate.eval(matches[1]);//@todo: try/catch
        }
        return result;
    };
    config.utils['file'] = {};
    config.utils.file['basename'] = function (path) {
        return String(path).replace(/.*\/([^\/]+)$/, '$1');
    };
    config.utils.file['extension'] = function (path) {
        return path.split(".").pop().toLowerCase();
    };
    config.utils.file['mime'] = function(filename) {
        var extension = utils.file.extension(filename),
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
    config.utils.file['payload'] = function(path, defaultValue) {
        defaultValue = typeof defaultValue === undefined ? null : defaultValue;
        if (utils.isEmpty(path) === false) {
            return { read: path, 'contentType': utils.file.mime(path), 'filename': utils.file.basename(path) };
        }
        return defaultValue;
    }
    config.utils['filterMap'] = function (map) {
        var result = {};

        for (const key in map) {
            const value = map[key];
            karate.log({value: value, key: key});
            if (utils.isEmpty(value) === false) {
                result[key] = value;
            }
        }

        return result;
    };
    config.utils['getDraftDocumentId'] = function (response, fileName) {
        fileName = utils.file.basename(fileName);
        for (var idx = 0;idx < response.documentList.length;idx++) {
            if (fileName === response.documentList[idx].name && response.documentList[idx].id !== null) {
                return response.documentList[idx].id;
            }
        }
        return null;
    };
    // @see https://stackoverflow.com/a/14794066
    config.utils['isInteger'] = function (value) {
        return !isNaN(value) && parseInt(Number(value)) == value && !isNaN(parseInt(value, 10));
    };
    config.utils['getUUID'] = function (length = 32) {
        // @see https://github.com/intuit/karate#commonly-needed-utilities
        return java.util.UUID.randomUUID() + '';
    };
    config.utils['getUniqueName'] = function(prefix) {
        return String(prefix) + Date.now();
    };
    config.utils['assert'] = function(string) {
        var result = karate.match(string)
        if (result.pass !== true) {
            karate.fail(result.message);
        }
        return result;
    };
    /**
     * utils.string
     */
    config.utils['isEmpty'] = function (value) {
        // https://stackoverflow.com/a/32108184
        var isEmptyObject = value && Object.keys(value).length === 0 && Object.getPrototypeOf(value) === Object.prototype;
        var isEmptyArray = Array.isArray(value) && value.length == 0;
        if (value == undefined || value == null || value == '' || isEmptyObject || value == []) {
            return true;
        }
        return false;
    };
    config.utils['safeExec'] = function(command) {
        var proc = karate.fork(command);
        proc.waitSync();
        if (proc.exitCode !== 0) {
            karate.fail('Got status code ' + proc.exitCode + ' for command ' + command);
        }
        return proc.sysOut.replace(/\n$/, '');
    };
    /**
     * utils.string
     */
    config.utils['string'] = {
        'letters_lowercase': 'abcdefghijklmnopqrstuvwxyz',
        'letters_uppercase': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'numbers': '9876543210',
    };
    config.utils.string.normalize = function(text) {
        return (text === null ? '' : String(text)).trim();

    };
    config.utils.string['letters'] = config.utils.string['letters_lowercase'] + config.utils.string['letters_uppercase'];
    // @deprecated
    config.utils.string['getByLength'] = function(length, prefix = null, characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') {
        prefix = prefix === null ? '' : prefix;
        let charactersLength = String(characters).length;
        return String(String(prefix) + String(characters).repeat(Math.ceil(length/charactersLength))).substr(0, length);
    };
    config.utils.string['getRandom'] = function(length, prefix = null, characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') {
        // @see https://stackoverflow.com/a/1349426
        prefix = prefix === null ? '' : prefix;
        let charactersLength = String(characters).length,
            result =  [];
        for ( var i = 0; i < length - String(prefix).length; i++ ) {
            result.push(characters.charAt(Math.floor(Math.random()*charactersLength)));
        }
        return String(String(prefix) + result.join('')).substr(0, length);
    };

    config.utils['xmlPathSortedUnique'] = function(xml, expression) {
        var extracted = karate.xmlPath(xml, expression)
        if (typeof extracted !== 'object') {
            extracted = [extracted];
        }
        return (extracted == '#notpresent') ? [] : utils.array.getSortedUnique(extracted);
    };

    config.utils['signature'] = {};
    config.utils.signature['pkcs7'] = {};
    config.utils.signature.pkcs7['check'] = function(document, pkcs7, certificate) {
        var cmd = [
            "/bin/sh",
            "-c",
            "openssl smime -verify -binary -inform PEM -in \"" + pkcs7 + "\" -content \"" + document + "\" -certfile \"" + certificate + "\" -nointern -noverify > /dev/null"
        ];
        utils.safeExec(cmd)
    };
    // @deprecated
    config.utils.signature['checkPkcs7'] = function(document, pkcs7, certificate) {
        var cmd = [
            "/bin/sh",
            "-c",
            "openssl smime -verify -binary -inform PEM -in \"" + pkcs7 + "\" -content \"" + document + "\" -certfile \"" + certificate + "\" -nointern -noverify > /dev/null"
        ];
        utils.safeExec(cmd)
    };
    config.utils.signature['pdf'] = {};
    config.utils.signature.pdf['get'] = function (path) {
        var cmd = [ "pdfsig", "-nocert", path ],
            idx,
            lines,
            matches,
            proc,
            result = [],
            signature = {};
        proc = karate.fork(cmd);
        proc.waitSync();
        /*if (proc.exitCode !== 0) {
            karate.fail('Got status code ' + proc.exitCode + ' for command ' + command);
        }*/
        tmp = proc.sysOut.replace(/\n$/, '');
        lines = tmp.split(/\r?\n/).filter(element => element);

        for (idx=0;idx<lines.length;idx++) {
            if (matches = lines[idx].match(/^Signature #([0-9]+):$/)) {
                if (karate.keysOf(signature).length > 0) {
                    result.push(signature);
                }
                signature = {};
            } else if(matches = lines[idx].match(/^\s+- Signer Certificate Common Name: (.*)$/)) {
                signature["commonName"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signer full Distinguished Name: (.*)$/)) {
                signature["distinguishedName"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signing Time: (.*)$/)) {
                signature["timestamp"] = new Date(matches[1]).getTime();
            } else if(matches = lines[idx].match(/^\s+- Signing Hash Algorithm: (.*)$/)) {
                signature["algorithm"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signature Type: (.*)$/)) {
                signature["type"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signature Validation: (.*)$/)) {
                signature["valid"] = matches[1] === "Signature is Valid.";
            } else if(matches = lines[idx].match(/^\s+- (Not total document signed|Total document signed)$/)) {
                signature["wholeDocumentSigned"] = matches[1] === "Total document signed";
            }
        }

        if (karate.keysOf(signature).length > 0) {
            result.push(signature);
        }

        result.sort(function compare(a, b) { if (a.timestamp < b.timestamp) return -1; if (a.timestamp > b.timestamp) return 1; return 0; } );
        for (idx=0;idx<result.length;idx++) {
            delete result[idx].timestamp;
        }

        return result;
    };
    // @deprecated
    config.utils.signature['getPdfSignatures'] = function (path) {
        var cmd = [ "pdfsig", "-nocert", path ],
            idx,
            lines,
            matches,
            proc,
            result = [],
            signature = {};
        proc = karate.fork(cmd);
        proc.waitSync();
        /*if (proc.exitCode !== 0) {
            karate.fail('Got status code ' + proc.exitCode + ' for command ' + command);
        }*/
        tmp = proc.sysOut.replace(/\n$/, '');
        lines = tmp.split(/\r?\n/).filter(element => element);

        for (idx=0;idx<lines.length;idx++) {
            if (matches = lines[idx].match(/^Signature #([0-9]+):$/)) {
                if (karate.keysOf(signature).length > 0) {
                    result.push(signature);
                }
                signature = {};
            } else if(matches = lines[idx].match(/^\s+- Signer Certificate Common Name: (.*)$/)) {
                signature["commonName"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signer full Distinguished Name: (.*)$/)) {
                signature["distinguishedName"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signing Hash Algorithm: (.*)$/)) {
                signature["algorithm"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signature Type: (.*)$/)) {
                signature["type"] = matches[1];
            } else if(matches = lines[idx].match(/^\s+- Signature Validation: (.*)$/)) {
                signature["valid"] = matches[1] === "Signature is Valid.";
            } else if(matches = lines[idx].match(/^\s+- (Not total document signed|Total document signed)$/)) {
                signature["wholeDocumentSigned"] = matches[1] === "Total document signed";
            }
        }

        if (karate.keysOf(signature).length > 0) {
            result.push(signature);
        }

        return result;
    };

    return config;
}
