/*
 * i-Parapheur
 * Copyright (C) 2018-2019 Libriciel-SCOP
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
package workflow.tasks

import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder
import workflow.utils.Requests._
import workflow.utils.Scenarios._


object SignatureTests {


  // <editor-fold desc="Utils">


  val startSignatureTasks: ScenarioBuilder = scenario("Create Signature")
    .repeat(repeatCount) {
      exec(http("Upload")
        .post("flowable-rest/service/runtime/process-instances")
        .body(StringBody(
          """
            {
              "processDefinitionKey" : "signature",
              "variables": [
                {
                  "name": "current_candidate_groups",
                  "value": "current_user"
                },
                {
                  "name": "previous_candidate_groups",
                  "value": "previous_user"
                },
                {
                  "name": "previous_action",
                  "value": "visa"
                },
                {
                  "name":"folder_id",
                  "value":"dossier_id_123456"
                }
              ]
            }
          """)).asJson
        .check(status.is(201))
        .check(jsonPath("$.id").exists))
    }


  // </editor-fold desc="Utils">


  val simple: ScenarioBuilder = scenario("Signature Simple")
    .exec(startSignatureTasks)
    .exec(listTasks("current_user")).exec(signatureForAll)
    .exec(checkEmptiness)


  val reject: ScenarioBuilder = scenario("Signature Reject")
    .exec(startSignatureTasks)
    .exec(listTasks("current_user")).exec(rejectForAll)
    .exec(checkEmptiness)


  val secondOpinion: ScenarioBuilder = scenario("Signature Second opinion")
    .exec(startSignatureTasks)
    .exec(listTasks("current_user")).exec(secondOpinionForAll("delegate_user"))
    .exec(listTasks("delegate_user")).exec(visaForAll)
    .exec(listTasks("current_user")).exec(signatureForAll)
    .exec(checkEmptiness)


  val secondOpinionUndo: ScenarioBuilder = scenario("Signature Second opinion")
    .exec(startSignatureTasks)
    .exec(listTasks("current_user")).exec(secondOpinionForAll("delegate_user"))
    .exec(listTasks("current_user")).exec(undoForAll)
    .exec(checkNothingToDo("delegate_user"))
    .exec(listTasks("current_user")).exec(signatureForAll)
    .exec(checkEmptiness)


  val transfert: ScenarioBuilder = scenario("Signature Transfert")
    .exec(startSignatureTasks)
    .exec(listTasks("current_user")).exec(transfertForAll("delegate_user"))
    .exec(listTasks("delegate_user")).exec(signatureForAll)
    .exec(checkEmptiness)


  val transfertUndo: ScenarioBuilder = scenario("Signature Transfert")
    .exec(startSignatureTasks)
    .exec(listTasks("current_user")).exec(transfertForAll("delegate_user"))
    .exec(listTasks("current_user")).exec(undoForAll)
    .exec(checkNothingToDo("delegate_user"))
    .exec(listTasks("current_user")).exec(signatureForAll)
    .exec(checkEmptiness)


  val doubleTransfert: ScenarioBuilder = scenario("Signature Transfert")
    .exec(startSignatureTasks)
    .exec(listTasks("current_user")).exec(transfertForAll("delegate_user"))
    .exec(listTasks("delegate_user")).exec(transfertForAll("second_delegate_user"))
    .exec(checkNothingToDo("current_user"))
    .exec(listTasks("second_delegate_user")).exec(signatureForAll)
    .exec(checkEmptiness)


  val doubleTransfertUndo: ScenarioBuilder = scenario("Signature Transfert")
    .exec(startSignatureTasks)
    .exec(listTasks("current_user")).exec(transfertForAll("delegate_user"))
    .exec(listTasks("delegate_user")).exec(transfertForAll("second_delegate_user"))
    .exec(checkNothingToDo("current_user"))
    .exec(listTasks("delegate_user")).exec(undoForAll)
    .exec(checkNothingToDo("second_delegate_user"))
    .exec(listTasks("delegate_user")).exec(signatureForAll)
    .exec(checkEmptiness)


}
