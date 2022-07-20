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
        var Base64 = Java.type('java.util.Base64'),
            cmd,
            content,
            decoded = Base64.getDecoder().decode(hash.getBytes()),
            files,
            signature,
            workDir = utils.safeExec("mktemp -d /tmp/karate.iparaheur.signature." + karate.properties['org.gradle.test.worker'] + ".XXXXXXXXXX");
        files = {
            bin: karate.properties['org.gradle.test.worker'] + ".bin",
            sig: workDir + "/" + karate.properties['org.gradle.test.worker'] + ".sig",
        };
        karate.log(files);
        karate.write(decoded, files.bin);

        cmd = "openssl dgst -sha256 -sign " + karate.toAbsolutePath(path) + " -out " + files.sig + " " + karate.toAbsolutePath("file://" + karate.properties['user.dir'] + "/build/" + files.bin);
        utils.safeExec(cmd);
        content = karate.readAsString("file://" + files.sig);
        signature = Base64.getEncoder().encodeToString(content.getBytes());
        karate.exec("rm -rf " + workDir);
        return signature;
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

    return config;
}
