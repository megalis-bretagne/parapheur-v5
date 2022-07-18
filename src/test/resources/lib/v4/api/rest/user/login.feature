@karate-function @ignore
Feature: IP v.4 REST user lib

    Scenario: Successful login
        * configure cookies = null
        * url baseUrl

        # Get session ID
        * path "/"
        * method GET
        * status 200
        * assert responseCookies.JSESSIONID.name == "JSESSIONID"
        * def JSESSIONID = responseCookies.JSESSIONID.value

        # Try to log in
        * path "/iparapheur/dologin"
        * form field username = __arg.username
        * form field password = __arg.password
        * header Content-Type = "application/x-www-form-urlencoded; charset=utf-8"
        * method POST
        * status 200

        # Check we are logged in
        * assert responseCookies.alfLogin.name == "alfLogin"
        * assert responseCookies.alfUsername2.name == "alfUsername2"

#        * def cookies = { alfLogin: "#(responseCookies.alfLogin.value)", alfUsername2: "#(responseCookies.alfUsername2.value)", JSESSIONID: "#(JSESSIONID)" };
#        * karate.set('_cookies', cookies)
#        * karate.configure('cookies', cookies)
#        * configure cookies = { alfLogin: "#(responseCookies.alfLogin.value)", alfUsername2: "#(responseCookies.alfUsername2.value)", JSESSIONID: "#(JSESSIONID)" };
