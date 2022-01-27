/*
 * i-Parapheur
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

package coop.libriciel.iparapheur.database

import coop.libriciel.iparapheur.CoreApi.{checkUp, getRandomTenantId, httpConf, repeatCount}
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._

import java.util.Random


class TypologySimulation extends Simulation {


  var getRandomWorkflowId: ScenarioBuilder = scenario(getClass.getName)
    .exec(
      http("Get")
        .get("api/v1/admin/tenant/${tenantId}/workflowDefinition")
        .header("Authorization", "bearer ${authToken}")
        .header("Accept", "application/json")
        .queryParam("page", 0)
        .queryParam("pageSize", 250)
        .check(status.is(200))
        .check(jsonPath("$.total").exists)
        .check(jsonPath("$.data").exists)
        .check(jsonPath("$.total").ofType[Int].gte(1))
        .check(jsonPath("$.data[*].key").ofType[String].findRandom.saveAs("workflowKey"))
    )


  var createType: ScenarioBuilder = scenario(getClass.getName)
    .exec(session => {
      session.setAll(
        ("randomTypeValue", new Random().nextInt(250000))
      )
    })
    .exec(
      http("Create")
        .post("api/v1/admin/tenant/${tenantId}/typology/type")
        .header("Authorization", "bearer ${authToken}")
        .header("Accept", "application/json")
        .body(StringBody(
          """
            {
              "id" : "type_${randomTypeValue}",
              "name" : "Type ${randomTypeValue}",
              "description" : "Gatling generated type with randomTypeValue:${randomTypeValue}",
              "signatureFormat" : "PADES"
            }
          """)).asJson
        .check(status.is(201))
        .check(jsonPath("$.id").exists)
        .check(jsonPath("$.id").ofType[String].saveAs("typeId"))
    )


  var createSubtype: ScenarioBuilder = scenario(getClass.getName)
    .exec(getRandomWorkflowId)
    .exec(session => {
      session.setAll(
        ("randomSubtypeValue", new Random().nextInt(250000))
      )
    })
    .exec(
      http("Create")
        .post("api/v1/admin/tenant/${tenantId}/typology/type/${typeId}/subtype")
        .header("Authorization", "bearer ${authToken}")
        .body(StringBody(
          """
            {
              "id" : "subtype_${randomSubtypeValue}",
              "name" : "SubType ${randomSubtypeValue}",
              "tenantId" : "${tenantId}",
              "creationWorkflowId" : null,
              "validationWorkflowId" : "${workflowKey}",
              "description" : "Gatling generated type with randomSubtypeValue:${randomSubtypeValue}",
              "isDigitalSignatureMandatory" : false,
              "isReadingMandatory" : true,
              "isMultiDocuments" : true
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
        exec(getRandomTenantId)
          .exec(createType)
          .exec(createSubtype)
      }
      .inject(atOnceUsers(1))
  ).protocols(httpConf)

}
