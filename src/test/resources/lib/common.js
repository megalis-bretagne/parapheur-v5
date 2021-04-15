function fn(config) {

    config['pause'] = function(seconds){
        java.lang.Thread.sleep(seconds * 1000);
    };

    return config;
}
