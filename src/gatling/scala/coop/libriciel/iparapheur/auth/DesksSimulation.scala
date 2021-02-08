/*
 * i-Parapheur
 * Copyright (C) 2019-2020 Libriciel-SCOP
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
package coop.libriciel.iparapheur.auth

import coop.libriciel.iparapheur.CoreApi._
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._

import java.util.Random


class DesksSimulation extends Simulation {


  var getUserId: ScenarioBuilder = scenario(getClass.getName)
    .exec(
      http("Get")
        .get("api/admin/tenant/${tenantId}/user")
        .header("Authorization", "bearer ${authToken}")
        .queryParam("page", 0)
        .queryParam("pageSize", 1)
        .queryParam("searchTerm", "sample-user@example")
        .check(status.is(200))
        .check(jsonPath("$.total").exists)
        .check(jsonPath("$.data").exists)
        .check(jsonPath("$.total").ofType[Int].gte(1))
        .check(jsonPath("$.data[*].id").ofType[String].findRandom.saveAs("userId"))
    )


  var createDesk: ScenarioBuilder = scenario(getClass.getName)
    .exec(getRandomTenantId)
    .exec(getUserId)
    .exec(session => {
      session.setAll(
        ("randomRole", ROLES_LIST(new Random().nextInt(ROLES_LIST.length))),
        ("randomCity", CITIES_LIST(new Random().nextInt(CITIES_LIST.length)))
      )
    })
    .exec(
      http("Create desk")
        .post("api/admin/tenant/${tenantId}/desk")
        .header("Authorization", "bearer ${authToken}")
        .body(StringBody(
          """
            {
              "name" : "${randomRole} de ${randomCity}",
              "description": "Gatling de ${randomRole} de ${randomCity}"
            }
          """)).asJson
        .check(status.is(201))
        .check(jsonPath("$.id").ofType[String].saveAs("deskId"))
    )
    .exec(
      http("Put")
        .put("api/admin/tenant/${tenantId}/desk/${deskId}/users")
        .header("Authorization", "bearer ${authToken}")
        .body(StringBody(
          """
            {
              "userIdList": [ "${userId}" ]
            }
          """)).asJson
        .check(status.in(200, 507))
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
        exec(createDesk)
      }
      .inject(atOnceUsers(1))
  ).protocols(httpConf)

}
