function fn() {
    var env = karate.env; // get system property 'karate.env'
    karate.log('karate.env system property was:', env);
    if (!env) {
        env = 'dev';
    }
    var config = {
        env: env,
        baseUrl: 'http://iparapheur.dom.local/'
    }
    if (env === 'dev') {
        // customize
        // e.g. config.foo = 'bar';
    } else if (env === 'e2e') {
        // customize
    }

    // @see https://medium.com/@babusekaran/organizing-re-usable-functions-karatedsl-575cd76daa27
    config = karate.call('classpath:lib/api_v1.js', config);
    config = karate.call('classpath:lib/common.js', config);
    config = karate.call('classpath:lib/ui.js', config);

    return config;
}
