@legacy-bridge @ip4 @folder-ui-processing
Feature: Traitement des dossiers

    Background:
        * configure ssl = true
        * configure readTimeout = 100000

    Scenario Outline: Traitement du dossier "${folder}" par "${username}"
        * v4.business.api.user.login(username, password)

        * call read('classpath:lib/ip4/business/api/folder/<action>.feature') __row

        Examples:
            | username                 | password | desktop   | folder                | action      | annotation            | to! | certificate |
            | lvermillon@legacy-bridge | a123456  | Vermillon | Auto_sign_avec_meta_1 | reject      | Auto_sign_avec_meta_1 | []  |             |
#            | lvermillon@legacy-bridge | a123456  | Vermillon | Auto_sign_avec_meta_2 | sign        | Auto_sign_avec_meta_2 | []  | signature   |
            | lvermillon@legacy-bridge | a123456  | Vermillon | Auto_visa_avec_meta_1 | visa        | Auto_visa_avec_meta_1 | []  |             |
            | lvermillon@legacy-bridge | a123456  | Vermillon | Auto_visa_avec_meta_2 | reject      | Auto_visa_avec_meta_2 | []  |             |
            | lvermillon@legacy-bridge | a123456  | Vermillon | Auto_visa_avec_meta_3 | visa        | Auto_visa_avec_meta_3 | []  |             |
            | lvermillon@legacy-bridge | a123456  | Vermillon | Auto_visa_avec_meta_4 | reject      | Auto_visa_avec_meta_4 | []  |             |
            | lvermillon@legacy-bridge | a123456  | Vermillon | PAdES_cachet_1        | seal        | PAdES_cachet_1        | []  |             |
            | lvermillon@legacy-bridge | a123456  | Vermillon | PAdES_cachet_2        | reject      | PAdES_cachet_2        | []  |             |
#            | lvermillon@legacy-bridge | a123456  | Vermillon | PAdES_mailsec_1       | mailsecSend | PAdES_mailsec_1       | []  |             |
            | lvermillon@legacy-bridge | a123456  | Vermillon | PAdES_mailsec_2       | reject      | PAdES_mailsec_2       | []  |             |
