@business @ip5 @circuits-unitaires @folder
Feature: Création de dossiers pour le paramétrage métier "Circuits unitaires"

    Scenario Outline: Create ${count} "${subtype}" draft folders ${withOrWithout} annex
        * def params =
"""
{
    tenant: '<tenant>',
    desktop: '<desktop>',
    type: '<type>',
    subtype: '<subtype>',
    mainFile: <mainFile>,
    nameTemplate: '<nameTemplate>',
    annotation: '<annotation>',
    username: '<username>',
}
"""
      * api_v1.auth.login('user', 'password')
      * def folders = api_v1.desk.draft.getPayloadMonodoc(params, <count>, <extra>, <start>)
      * api_v1.auth.login('<username>', '<password>')
      * def result = call read('classpath:lib/api/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders

          Examples:
                | tenant             | username | password | desktop    | type               | subtype        | mainFile!                                  | nameTemplate                                             | start! | count! | withOrWithout | extra! | annotation                          |
                | Circuits unitaires | ws-cu    | a123456  | WebService | ACTES - CAdES      | Mail securise  | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - CAdES - Mail securise - monodoc - PDF %counter%  | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | ACTES - CAdES      | Signature      | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - CAdES - Signature - monodoc - PDF %counter%      | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | ACTES - CAdES      | Visa           | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - CAdES - Visa - monodoc - PDF %counter%           | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | ACTES - PAdES      | Cachet serveur | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - PAdES - Cachet serveur - monodoc - PDF %counter% | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | ACTES - PAdES      | Mail securise  | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - PAdES - Mail securise - monodoc - PDF %counter%  | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | ACTES - PAdES      | Signature      | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - PAdES - Signature - monodoc - PDF %counter%      | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | ACTES - PAdES      | Visa           | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - PAdES - Visa - monodoc - PDF %counter%           | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | Automatique        | Mail securise  | 'classpath:files/pdf/main-1_1.pdf'         | Automatique - Mail securise - monodoc - PDF %counter%    | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | Automatique        | Signature      | 'classpath:files/pdf/main-1_1.pdf'         | Automatique - Signature - monodoc - PDF %counter%        | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | Automatique        | Visa           | 'classpath:files/pdf/main-1_1.pdf'         | Automatique - Visa - monodoc - PDF %counter%             | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | Automatique        | Mail securise  | 'classpath:files/office/main-1_1.odt'      | Automatique - Mail securise - monodoc - ODT %counter%    | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | Automatique        | Signature      | 'classpath:files/office/main-1_1.odt'      | Automatique - Signature - monodoc - ODT %counter%        | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | Automatique        | Visa           | 'classpath:files/office/main-1_1.odt'      | Automatique - Visa - monodoc - ODT %counter%             | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES              | Mail securise  | 'classpath:files/pdf/main-1_1.pdf'         | CAdES - Mail securise - monodoc - PDF %counter%          | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES              | Signature      | 'classpath:files/pdf/main-1_1.pdf'         | CAdES - Signature - monodoc - PDF %counter%              | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES              | Visa           | 'classpath:files/pdf/main-1_1.pdf'         | CAdES - Visa - monodoc - PDF %counter%                   | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | HELIOS - XAdES env | Mail securise  | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Mail securise - monodoc - PDF %counter%         | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | HELIOS - XAdES env | Signature      | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Signature - monodoc - PDF %counter%             | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | HELIOS - XAdES env | Visa           | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Visa - monodoc - PDF %counter%                  | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES              | Cachet serveur | 'classpath:files/pdf/main-1_1.pdf'         | PAdES - Cachet serveur - monodoc - PDF %counter%         | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES              | Mail securise  | 'classpath:files/pdf/main-1_1.pdf'         | PAdES - Mail securise - monodoc - PDF %counter%          | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES              | Signature      | 'classpath:files/pdf/main-1_1.pdf'         | PAdES - Signature - monodoc - PDF %counter%              | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES              | Visa           | 'classpath:files/pdf/main-1_1.pdf'         | PAdES - Visa - monodoc - PDF %counter%                   | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | XAdES det          | Mail securise  | 'classpath:files/xml/PESALR1_unsigned.xml' | XAdES - Mail securise - monodoc - XML %counter%          | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | XAdES det          | Signature      | 'classpath:files/xml/PESALR1_unsigned.xml' | XAdES - Signature - monodoc - XML %counter%              | 1      | 5      | without       | {}     | démarrage |
                | Circuits unitaires | ws-cu    | a123456  | WebService | XAdES det          | Visa           | 'classpath:files/xml/PESALR1_unsigned.xml' | XAdES - Visa - monodoc - XML %counter%                   | 1      | 5      | without       | {}     | démarrage |
