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

    return config;
}
