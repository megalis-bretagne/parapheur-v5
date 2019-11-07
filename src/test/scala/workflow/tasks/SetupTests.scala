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


object SetupTests {


  val uploadVisaScenario: ScenarioBuilder = scenario("Upload Visa").exec(
    http("Upload")
      .post("flowable-rest/service/repository/deployments")
      .formUpload("file", "bpmn/visa.bpmn20.xml")
      .check(status.is(201))
      .check(jsonPath("$.id").exists)
      .check(jsonPath("$.name").is("visa"))
  )


  val uploadSignatureScenario: ScenarioBuilder = scenario("Upload Signature").exec(
    http("Upload")
      .post("flowable-rest/service/repository/deployments")
      .formUpload("file", "bpmn/signature.bpmn20.xml")
      .check(status.is(201))
      .check(jsonPath("$.id").exists)
      .check(jsonPath("$.name").is("signature"))
  )


  val uploadSecondOpinionScenario: ScenarioBuilder = scenario("Upload Second opinion").exec(
    http("Upload")
      .post("flowable-rest/service/repository/deployments")
      .formUpload("file", "bpmn/second_opinion.bpmn20.xml")
      .check(status.is(201))
      .check(jsonPath("$.id").exists)
      .check(jsonPath("$.name").is("second_opinion"))
  )

}
