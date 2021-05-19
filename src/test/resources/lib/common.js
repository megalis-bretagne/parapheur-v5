function fn(config) {

    config['scenario'] = {'outline': {}};
    config.scenario.outline['existing'] = function(exists){
        return exists == true ? 'an existing' : 'a non existing';
    };
    config.scenario.outline['role'] = function(role){
        return role !== '' && role !== null ? 'a user with the role "' + role + '"' : 'an unauthenticated user';
    };
    config.scenario.outline['status'] = function(status){
        return String(status).match(/^[2-3]/) ? 'can' : 'cannot';
    };
    // @todo: deprecate
    config['title'] = config.scenario.outline;
    config['title']['can'] = config.title.status;

    config['pause'] = function(seconds){
        java.lang.Thread.sleep(seconds * 1000);
    };

    /**
     * utils
     */
    config['utils'] = {};
    config.utils['eval'] = function (value) {
        var matches = (''+value).match(/^eval\((.*)\)$/),
            result = value;
        if (matches !== null) {
            result = karate.eval(matches[1]);//@todo: try/catch
        }
        return result;
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
        karate.log(result);
        if (result.pass !== true) {
            karate.fail(result.message);
        }
        return result;
    };
    /**
     * utils.string
     */
    config.utils['string'] = {
        'letters_lowercase': 'abcdefghijklmnopqrstuvwxyz',
        'letters_uppercase': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'numbers': '9876543210',
    };
    config.utils.string['letters'] = config.utils.string['letters_lowercase'] + config.utils.string['letters_uppercase'];
    config.utils.string['getByLength'] = function(length, prefix = null, characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') {
        prefix = prefix === null ? '' : prefix;
        let charactersLength = String(characters).length;
        // karate.log({length: length, characters: charactersLength, charactersLength: charactersLength, current: Math.ceil(length/charactersLength)});
        return String(String(prefix) + String(characters).repeat(Math.ceil(length/charactersLength))).substr(0, length);
    };

    return config;
}
