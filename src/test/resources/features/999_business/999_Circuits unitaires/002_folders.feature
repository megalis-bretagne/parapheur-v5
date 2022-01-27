@business @circuits-unitaires @folder @proposal
Feature: Création de dossiers pour le paramétrage métier "Circuits unitaires"

    Scenario Outline: Create ${count} "${subtype}" draft folders ${withOrWithout} annex
        * def params =
"""
{
    tenant: '<tenant>',
    desktop: '<desktop>',
    type: '<type>',
    subtype: '<subtype>',
    mainFile: '<mainFile>',
    nameTemplate: '<nameTemplate>'
}
"""
      * api_v1.auth.login('user', 'password')
      * def folders = api_v1.desk.draft.getPayloadMonodoc(params, <count>, <extra>, <start>)
      * api_v1.auth.login('<username>', '<password>')
      * def result = call read('classpath:lib/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders

      Examples:
          | tenant             | username | password | desktop    | type  | subtype                       | mainFile                             | nameTemplate                                           | start! | count! | withOrWithout | extra! |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur                | classpath:files/office/main-1_1.doc  | CAdES - Cachet serveur - DOC %counter%                 | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur                | classpath:files/office/main-1_1.docx | CAdES - Cachet serveur - DOCX %counter%                | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur                | classpath:files/office/main-1_2.ods  | CAdES - Cachet serveur - ODS %counter%                 | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur                | classpath:files/office/main-1_1.odt  | CAdES - Cachet serveur - ODT %counter%                 | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur                | classpath:files/pdf/main-1_1.pdf     | CAdES - Cachet serveur - PDF %counter%                 | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur                | classpath:files/office/main-1_2.xls  | CAdES - Cachet serveur - XLS %counter%                 | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur                | classpath:files/office/main-1_2.xlsx | CAdES - Cachet serveur - XLSX %counter%                | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur et metadonnees | classpath:files/office/main-1_1.doc  | CAdES - Cachet serveur et métadonnées - DOC %counter%  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur et metadonnees | classpath:files/office/main-1_1.docx | CAdES - Cachet serveur et métadonnées - DOCX %counter% | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur et metadonnees | classpath:files/office/main-1_2.ods  | CAdES - Cachet serveur et métadonnées - ODS %counter%  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur et metadonnees | classpath:files/office/main-1_1.odt  | CAdES - Cachet serveur et métadonnées - ODT %counter%  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur et metadonnees | classpath:files/pdf/main-1_1.pdf     | CAdES - Cachet serveur et métadonnées - PDF %counter%  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur et metadonnees | classpath:files/office/main-1_2.xls  | CAdES - Cachet serveur et métadonnées - XLS %counter%  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Cachet serveur et metadonnees | classpath:files/office/main-1_2.xlsx | CAdES - Cachet serveur et métadonnées - XLSX %counter% | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise                 | classpath:files/office/main-1_1.doc  | CAdES - Mail securise - DOC %counter%                  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise                 | classpath:files/office/main-1_1.docx | CAdES - Mail securise - DOCX %counter%                 | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise                 | classpath:files/office/main-1_2.ods  | CAdES - Mail securise - ODS %counter%                  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise                 | classpath:files/office/main-1_1.odt  | CAdES - Mail securise - ODT %counter%                  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise                 | classpath:files/pdf/main-1_1.pdf     | CAdES - Mail securise - PDF %counter%                  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise                 | classpath:files/office/main-1_2.xls  | CAdES - Mail securise - XLS %counter%                  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise et metadonnees  | classpath:files/office/main-1_1.doc  | CAdES - Mail securise et métadonnées - DOC %counter%   | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise et metadonnees  | classpath:files/office/main-1_1.docx | CAdES - Mail securise et métadonnées - DOCX %counter%  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise et metadonnees  | classpath:files/office/main-1_2.ods  | CAdES - Mail securise et métadonnées - ODS %counter%   | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise et metadonnees  | classpath:files/office/main-1_1.odt  | CAdES - Mail securise et métadonnées - ODT %counter%   | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise et metadonnees  | classpath:files/pdf/main-1_1.pdf     | CAdES - Mail securise et métadonnées - PDF %counter%   | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise et metadonnees  | classpath:files/office/main-1_2.xls  | CAdES - Mail securise et métadonnées - XLS %counter%   | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Mail securise et metadonnees  | classpath:files/office/main-1_2.xlsx | CAdES - Mail securise et métadonnées - XLSX %counter%  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature                     | classpath:files/office/main-1_1.doc  | CAdES - Signature - DOC %counter%                      | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature                     | classpath:files/office/main-1_1.docx | CAdES - Signature - DOCX %counter%                     | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature                     | classpath:files/office/main-1_2.ods  | CAdES - Signature - ODS %counter%                      | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature                     | classpath:files/office/main-1_1.odt  | CAdES - Signature - ODT %counter%                      | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature                     | classpath:files/pdf/main-1_1.pdf     | CAdES - Signature - PDF %counter%                      | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature                     | classpath:files/office/main-1_2.xls  | CAdES - Signature - XLS %counter%                      | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature                     | classpath:files/office/main-1_2.xlsx | CAdES - Signature - XLSX %counter%                     | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature et metadonnees      | classpath:files/office/main-1_1.doc  | CAdES - Signature et métadonnées - DOC %counter%       | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature et metadonnees      | classpath:files/office/main-1_1.docx | CAdES - Signature et métadonnées - DOCX %counter%      | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature et metadonnees      | classpath:files/office/main-1_2.ods  | CAdES - Signature et métadonnées - ODS %counter%       | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature et metadonnees      | classpath:files/office/main-1_1.odt  | CAdES - Signature et métadonnées - ODT %counter%       | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature et metadonnees      | classpath:files/pdf/main-1_1.pdf     | CAdES - Signature et métadonnées - PDF %counter%       | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature et metadonnees      | classpath:files/office/main-1_2.xls  | CAdES - Signature et métadonnées - XLS %counter%       | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Signature et metadonnees      | classpath:files/office/main-1_2.xlsx | CAdES - Signature et métadonnées - XLSX %counter%      | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa                          | classpath:files/office/main-1_1.doc  | CAdES - Visa - DOC %counter%                           | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa                          | classpath:files/office/main-1_1.docx | CAdES - Visa - DOCX %counter%                          | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa                          | classpath:files/office/main-1_2.ods  | CAdES - Visa - ODS %counter%                           | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa                          | classpath:files/office/main-1_1.odt  | CAdES - Visa - ODT %counter%                           | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa                          | classpath:files/pdf/main-1_1.pdf     | CAdES - Visa - PDF %counter%                           | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa                          | classpath:files/office/main-1_2.xls  | CAdES - Visa - XLS %counter%                           | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa                          | classpath:files/office/main-1_2.xlsx | CAdES - Visa - XLSX %counter%                          | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa et metadonnees           | classpath:files/office/main-1_1.doc  | CAdES - Visa et métadonnées - DOC %counter%            | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa et metadonnees           | classpath:files/office/main-1_1.docx | CAdES - Visa et métadonnées - DOCX %counter%           | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa et metadonnees           | classpath:files/office/main-1_2.ods  | CAdES - Visa et métadonnées - ODS %counter%            | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa et metadonnees           | classpath:files/office/main-1_1.odt  | CAdES - Visa et métadonnées - ODT %counter%            | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa et metadonnees           | classpath:files/pdf/main-1_1.pdf     | CAdES - Visa et métadonnées - PDF %counter%            | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa et metadonnees           | classpath:files/office/main-1_2.xls  | CAdES - Visa et métadonnées - XLS %counter%            | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | CAdES | Visa et metadonnees           | classpath:files/office/main-1_2.xlsx | CAdES - Visa et métadonnées - XLSX %counter%           | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES | Cachet serveur                | classpath:files/pdf/main-1_1.pdf     | PAdES - Cachet serveur - PDF %counter%                 | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES | Cachet serveur et metadonnees | classpath:files/pdf/main-1_1.pdf     | PAdES - Cachet serveur et métadonnées - PDF %counter%  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES | Mail securise                 | classpath:files/pdf/main-1_1.pdf     | PAdES - Mail securise - PDF %counter%                  | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES | Mail securise et metadonnees  | classpath:files/pdf/main-1_1.pdf     | PAdES - Mail securise et métadonnées - PDF %counter%   | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES | Signature                     | classpath:files/pdf/main-1_1.pdf     | PAdES - Signature - PDF %counter%                      | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES | Signature et metadonnees      | classpath:files/pdf/main-1_1.pdf     | PAdES - Signature et métadonnées - PDF %counter%       | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES | Visa                          | classpath:files/pdf/main-1_1.pdf     | PAdES - Visa - PDF %counter%                           | 1      | 10     | without       | {}     |
          | Circuits unitaires | ws-cu    | a123456  | WebService | PAdES | Visa et metadonnees           | classpath:files/pdf/main-1_1.pdf     | PAdES - Visa et métadonnées - PDF %counter%            | 1      | 10     | without       | {}     |
