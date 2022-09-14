@actes-helios-grandes-collectivites @prepare-business @ip5 @folder
Feature: Création de dossiers pour le paramétrage métier "ACTES HELIOS - grandes collectivités"

    @fixme-ip5 @issue-todo
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
        * def result = call read('classpath:lib/ip5/api/draft/create-and-send-monodoc-<withOrWithout>-annex.feature') folders
        #@fixme: IP 5, HELIOS - Monodoc, avec annexe: La signature XAdES enveloppée ne peut être effectuée que sur un unique document XML
        #@fixme: IP 5, HELIOS - Monodoc, sans annexe: Accès à la ressource refusé
        # core_1                          | 2022-06-20 16:01:13.227  WARN 7 --- [nio-8080-exec-1] c.l.i.s.p.KeycloakResourceService        : Caught an unexpected exception when testing permission : org.keycloak.authorization.client.util.HttpResponseException: Unexpected response from server: 400 / Bad Request / Response from server: {"error":"invalid_resource","error_description":"Resource with id [${i_Parapheur_internal_validation_variable_desk_id_0}] does not exist."}, caused by : org.keycloak.authorization.client.util.HttpResponseException: Unexpected response from server: 400 / Bad Request / Response from server: {"error":"invalid_resource","error_description":"Resource with id [${i_Parapheur_internal_validation_variable_desk_id_0}] does not exist."}
        # Précédemment: erreur 500 aussi
        #core_1                          | 2022-01-20 10:55:37.409 DEBUG 6 --- [nio-8080-exec-9] c.l.i.services.groovy.GroovyService      : Groovy resultCatcher:GroovyResultCatcher(workflowDefinitionId=signature_helios, variableDesks=[Bleu])
        #workflow_1                      | 2022-01-20 10:55:37.411 DEBUG 1 --- [nio-8080-exec-1] c.l.workflow.controller.TaskController   : Perform task:75664fd0-79df-11ec-82a2-0242ac1b0014 action:START user:b752d7da-847d-4cd6-b378-77f9f286bbff variables:{workflow_internal_validation_workflow_id=signature_helios}
        #workflow_1                      | 2022-01-20 10:55:37.438 ERROR 1 --- [nio-8080-exec-1] o.a.c.c.C.[.[.[.[dispatcherServlet]      : Servlet.service() for servlet [dispatcherServlet] in context with path [/workflow] threw exception [Request processing failed; nested exception is org.flowable.common.engine.api.FlowableException: Unknown property used in expression: ${i_Parapheur_internal_validation_variable_desk_id_0}] with root cause
        #workflow_1                      |
        #workflow_1                      | org.flowable.common.engine.impl.javax.el.PropertyNotFoundException: Cannot resolve identifier 'i_Parapheur_internal_validation_variable_desk_id_0'
      Examples:
          | tenant                               | username | password | desktop    | type          | subtype                 | mainFile!                                  | nameTemplate                                      | start! | count! | withOrWithout | extra!                            | annotation |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - PAdES - Monodoc - sans annexe - %counter% | 1      | 10     | without       | {}                                | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | ACTES - PAdES | ACTES - PAdES - Monodoc | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - PAdES - Monodoc - avec annexe - %counter% | 1      | 10     | with          | {}                                | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Monodoc - sans annexe - %counter%        | 1      | 10     | without       | { "metadata":{"GdaBjType":"1"} }  | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Monodoc - sans annexe - %counter%        | 11     | 10     | without       | { "metadata":{"GdaBjType":"2"} }  | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Monodoc - sans annexe - %counter%        | 21     | 10     | without       | { "metadata":{"GdaBjType":"3"} }  | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Monodoc - avec annexe - %counter%        | 1      | 10     | with          | { "metadata":{"GdaBjType":"1"} }  | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Monodoc - avec annexe - %counter%        | 11     | 10     | with          | { "metadata":{"GdaBjType":"2"} }  | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | HELIOS        | HELIOS - Monodoc        | 'classpath:files/xml/PESALR1_unsigned.xml' | HELIOS - Monodoc - avec annexe - %counter%        | 21     | 10     | with          | { "metadata":{"GdaBjType":"3"} }  | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - CAdES - Monodoc - sans annexe - %counter% | 1      | 10     | without       | {}                                | démarrage  |
          | ACTES HELIOS - grandes collectivités | ws-ahgc  | a123456  | WebService | ACTES - CAdES | ACTES - CAdES - Monodoc | 'classpath:files/pdf/main-1_1.pdf'         | ACTES - CAdES - Monodoc - avec annexe - %counter% | 1      | 10     | with          | {}                                | démarrage  |
