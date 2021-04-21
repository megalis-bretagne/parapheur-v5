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

    // @see https://medium.com/@babusekaran/organizing-re-usable-functions-karatedsl-575cd76daa27
    config = karate.call('classpath:lib/api_v1.js', config);
    config = karate.call('classpath:lib/common.js', config);
    config = karate.call('classpath:lib/ui.js', config);

    return config;
}
