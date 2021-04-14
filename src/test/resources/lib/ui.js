function fn(config) {
    config['ui'] = {};

    /**
     * Driver
     **/
    config.ui['driver'] = {};
    // @see https://github.com/intuit/karate/blob/master/karate-demo/src/test/java/driver/demo/demo-01.feature
    config.ui.driver['configure'] = { type: 'chrome', showDriverLog: false, executable: "/usr/bin/chromium-browser" };

    /**
     * Locator
     * @todo: find lib or port custom from behat's
     **/
    config.ui['locator'] = {};
    config.ui.locator['button'] = function (text) {
        return '//button[contains(., \'' + text + '\')]';
    };
    config.ui.locator['header'] = {};
    // usage: ui.locator.header['i-Parapheur']
    config.ui.locator.header['i-Parapheur'] = '//app-header//*[@routerlink=\'/\'][1]';
    config.ui.locator.header['Maison'] = '//app-header//*[@routerlink=\'/\'][last()]';
    config.ui.locator.header['Archives'] = '//app-header//*[@routerlink=\'/archive\']';
    config.ui.locator.header['Statistiques'] = '//app-header//*[@routerlink=\'/stats\']';
    config.ui.locator.header['Administration'] = '//app-header//*[@routerlink=\'/admin\']';
    config.ui.locator.header['Profil'] = '//app-header//*[@routerlink=\'/profile\']';
    config.ui.locator.header['Déconnexion'] = '//app-header//fa-icon[last()]';
    config.ui.locator['input'] = function (text) {
        return '//input[@id=//label[contains(., \'' + text + '\')]/@for]';
    };

    /**
     * URL
     **/
    config.ui['url'] = {};
    config.ui.url['logout'] = '/auth/realms/api/protocol/openid-connect/logout';

    return config;
}
