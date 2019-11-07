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
package workflow

import java.util.UUID

import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder
import workflow.tasks.SetupTests
import workflow.utils.Requests._
import workflow.utils.Scenarios.repeatCount


class WorkflowSimulation extends Simulation {


  val uploadSimpleWorkflowScenario: ScenarioBuilder = scenario("Upload Simple Workflow").exec(
    http("Upload")
      .post("flowable-rest/service/repository/deployments")
      .formUpload("file", "data/simple_workflow.bpmn20.xml")
      .check(status.is(201))
      .check(jsonPath("$.id").exists)
      .check(jsonPath("$.name").is("simple_workflow"))
  )


  val startSimpleWorkflow: ScenarioBuilder = scenario("Create Simple Workflow")
    .repeat(repeatCount) {
      exec(http("Upload")
        .post("flowable-rest/service/runtime/process-instances")
        .body(StringBody(_ =>
          s"""
            {
              "processDefinitionKey" : "simple_workflow",
              "variables": [
                {
                  "name":"folder_id",
                  "value":"dossier_id_${UUID.randomUUID.toString}"
                },
                {
                  "name":"folder_name",
                  "value":"name_${UUID.randomUUID.toString}"
                }
              ]
            }
          """)).asJson
        .check(status.is(201))
        .check(jsonPath("$.id").exists)
      )
    }


  /**
   * The simulations need to be in a file named *Simulation, and execute this.
   * Every tests (Visa, Signature...) could be executed in a separate *Simulation file,
   * but Gatling it would create a separate log and report for each.
   *
   * For such simple tests cases, everything is called from here, merging everything in one report/log.
   */
  setUp(

    checkUp

      .exec(SetupTests.uploadVisaScenario)
      .exec(SetupTests.uploadSignatureScenario)
      .exec(SetupTests.uploadSecondOpinionScenario)
      .exec(uploadSimpleWorkflowScenario)
      .exec(startSimpleWorkflow)

      .inject(atOnceUsers(1))
  ).protocols(httpConf)

}
