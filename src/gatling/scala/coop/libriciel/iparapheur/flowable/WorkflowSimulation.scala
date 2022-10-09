/*
 * iparapheur
 * Copyright (C) 2019-2022 Libriciel SCOP
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

package coop.libriciel.iparapheur.flowable

import coop.libriciel.iparapheur.CoreApi._
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._

import java.util.Random


class WorkflowSimulation extends Simulation {


  var createWorkflow: ScenarioBuilder = scenario(getClass.getName)
    .exec(getRandomTenantId)
    .exec(getRandomDeskIdAsAdmin)
    .exec(session => {
      session.setAll(
        ("randomSimpleWorkflowValue", new Random().nextInt(250000))
      )
    })
    .exec(
      http("Create")
        .post("api/v1/admin/tenant/${tenantId}/workflowDefinition")
        .header("Authorization", "bearer ${authToken}")
        .body(StringBody(
          """
            {
              "deploymentChildrenCount": 0,
              "deploymentId": "simple_workflow_${randomSimpleWorkflowValue}",
              "id": "simple_workflow_${randomSimpleWorkflowValue}",
              "key": "simple_workflow_${randomSimpleWorkflowValue}",
              "name": "Simple workflow ${randomSimpleWorkflowValue}",
              "steps": [
                {
                  "type": "VISA",
                  "validators": [ "${deskId}" ]
                }
              ]
            }
          """)).asJson
        .check(status.is(201))
    )


  /**
   * The simulations need to be in a file named *Simulation, and execute this.
   * Every tests (Visa, Signature...) could be executed in a separate *Simulation file,
   * but Gatling it would create a separate log and report for each.
   *
   * For such simple tests cases, everything is called from here, merging everything in one report/log.
   */
  setUp(
    checkUp
      .repeat(repeatCount) {
        exec(createWorkflow)
      }
      .inject(atOnceUsers(1))
  ).protocols(httpConf)

}
