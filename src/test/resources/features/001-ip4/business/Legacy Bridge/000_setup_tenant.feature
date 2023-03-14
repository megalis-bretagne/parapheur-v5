@legacy-bridge @ip4 @setup @tenant-create
Feature: Création de l'entité "legacy-bridge" (IP 4)

    Scenario Outline: Création de la collectivité "${tenantDomain}"
        # @see https://stackoverflow.com/questions/52392614/how-to-skip-ssl-certificate-verification-with-karate
        * configure ssl = true

        * ip4.business.api.user.login("admin", "admin")

        * configure readTimeout = 100000
        * call read('classpath:lib/ip4/business/api/tenant/create.feature') __row

        Examples:
            | tenantDomain  | password | title         | description   |
            | legacy-bridge | a123456a123456  | legacy-bridge | legacy-bridge |
